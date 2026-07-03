# Snowflake Round 1 (Technical) — Python Study Guide

**Interview:** May 18, 2026 — 1 hour with Divya Sharma & Kavya Sree Rajula (Senior DEs)
**Format:** Non-timed, basic data structures + SQL (Python or any language)
**Your advantage:** 9+ years data engineering; focus on **correctness, reasoning, clean code** not speed

---

## Overview

Snowflake's first technical round is **fundamentals-focused**, not LeetCode-hard. They want to see:

- Clean, readable code with meaningful variable names
- Correct edge-case handling
- Clear explanation of your approach
- How you debug and test

You have time to think and communicate — this is not a race. You'll likely get one Python problem (Easy-Medium) and one SQL problem. Both require thoroughness, not speed.

---

## Part 0: Role Context (Read This First)

**This is internal data engineering at Snowflake, not product engineering.**

You are building the data infrastructure that Snowflake uses internally — ingesting from Salesforce, Workday, Zendesk, supporting executive/board reporting. You are eating Snowflake's own dogfood.

**Why this matters for the interview:**

- Your 800+ pipeline ownership at Susquehanna is directly relevant
- Your config-driven PySpark ingestion framework translates 1:1
- Your Kafka CDC work bridges to Snowflake's Streams + Tasks
- **Position yourself as:** "I have built exactly this at petabyte scale on Hadoop. Snowflake is different packaging, same distributed compute + columnar storage + MPP execution principles."

**Likely gap you'll address proactively:**

- You have not used Snowflake or dbt in production
- This is fine — position it as: "Deep understanding of cloud data warehousing principles, strong SQL fluency, track record of picking up platforms fast (AWS Certified, Databricks Accredited)."

---

## Part 1: Core Patterns for Snowflake Round 1

These are the **highest-leverage patterns** for data engineering interviews. Master these deeply rather than grinding 100 problems.

### Pattern 1: Hash Maps & Counting (g1_arrays_and_hashing)

### Pattern 2: Two Pointers (g2_two_pointers)

### Pattern 3: Sliding Window (g3_sliding_window)

### Pattern 4: Intervals (g16_intervals)

### Pattern 5: Heaps & Priority Queues (g8_heap_and_priority_queues)

### Pattern 6: Stack (g4_stack)

### Pattern 7: Binary Search (g5_binary_search)

### Pattern 8: Graphs (g11_graphs)

### Pattern 1: Hash Maps & Counting (g1_arrays_and_hashing)

**When to use:** Finding duplicates, counting frequencies, lookup-based problems

**Core insight:** Hash maps give O(1) lookup; use them to avoid nested loops.

#### Example 1: Two Sum

```python
def two_sum(nums, target):
    """
    Find two indices where nums[i] + nums[j] = target.
  
    Approach: Hash map to store seen numbers
    - Time: O(n) single pass
    - Space: O(n) for hash map
    """
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []

# Test
assert two_sum([2, 7, 11, 15], 9) == [0, 1]
assert two_sum([3, 3], 6) == [0, 1]
assert two_sum([3], 6) == []  # Edge: not enough elements
```

**Why this matters for Snowflake:** Finding matching records, deduplication, joins in data pipelines.

#### Example 2: Count Frequencies

```python
from collections import Counter

def top_k_frequent(nums, k):
    """
    Find k most frequent elements.
  
    Approach: Counter for frequencies, heap for top-k
    - Time: O(n log k)
    - Space: O(n) for counter
    """
    if k == len(set(nums)):
        return list(set(nums))
  
    # Counter gives us frequencies
    count = Counter(nums)
  
    # Heap to get top k
    return [item for item, _ in count.most_common(k)]

# Test
assert top_k_frequent([1, 1, 1, 2, 2, 3], 2) == [1, 2]
assert top_k_frequent([1], 1) == [1]
```

**Talking point for interview:** "I used Counter because it's optimized for frequency counting, then `most_common()` which is cleaner than manually sorting."

---

### Pattern 2: Two Pointers (g2_two_pointers)

**When to use:** Sorted arrays, palindromes, container problems, removing duplicates

**Core insight:** Two pointers eliminate nested loops on sorted data.

#### Example 1: Valid Palindrome (Two Pointer)

```python
def is_palindrome(s):
    """
    Check if string is a palindrome (case-insensitive, alphanumeric only).
  
    Approach: Two pointers from both ends
    - Time: O(n)
    - Space: O(1)
    """
    left, right = 0, len(s) - 1
  
    while left < right:
        # Skip non-alphanumeric
        while left < right and not s[left].isalnum():
            left += 1
        while left < right and not s[right].isalnum():
            right -= 1
      
        # Compare case-insensitively
        if s[left].lower() != s[right].lower():
            return False
      
        left += 1
        right -= 1
  
    return True

# Test
assert is_palindrome("A man, a plan, a canal: Panama") == True
assert is_palindrome("race a car") == False
assert is_palindrome(" ") == True  # Edge: only spaces
```

**Why this matters:** Data validation, checking data integrity.

#### Example 2: Merge Sorted Arrays (Two Pointer)

```python
def merge_sorted(arr1, arr2):
    """
    Merge two sorted arrays into one sorted array.
  
    Approach: Two pointers, walk through both arrays
    - Time: O(n + m)
    - Space: O(n + m) for output
    """
    result = []
    i, j = 0, 0
  
    while i < len(arr1) and j < len(arr2):
        if arr1[i] <= arr2[j]:
            result.append(arr1[i])
            i += 1
        else:
            result.append(arr2[j])
            j += 1
  
    # Append remaining
    result.extend(arr1[i:])
    result.extend(arr2[j:])
  
    return result

# Test
assert merge_sorted([1, 3, 5], [2, 4, 6]) == [1, 2, 3, 4, 5, 6]
assert merge_sorted([], [1, 2]) == [1, 2]
assert merge_sorted([1], []) == [1]
```

**Talking point:** "This is the merge step of merge sort. I walk through both arrays with pointers, comparing at each step."

---

### Pattern 3: Sliding Window (g3_sliding_window)

**When to use:** Subarray/substring problems, max/min over windows

**Core insight:** Maintain a window with two pointers; expand/shrink to keep valid state.

#### Example: Longest Substring Without Repeating Characters

```python
def length_of_longest_substring(s):
    """
    Find length of longest substring without repeating characters.
  
    Approach: Sliding window with hash map tracking character positions
    - Time: O(n) two-pass (each char visited at most twice)
    - Space: O(min(n, 26)) for character set size
    """
    char_index = {}
    max_len = 0
    start = 0
  
    for end, char in enumerate(s):
        # If char is in current window, move start past it
        if char in char_index and char_index[char] >= start:
            start = char_index[char] + 1
      
        # Update char's latest position
        char_index[char] = end
      
        # Update max length
        max_len = max(max_len, end - start + 1)
  
    return max_len

# Test
assert length_of_longest_substring("abcabcbb") == 3  # "abc"
assert length_of_longest_substring("bbbbb") == 1  # "b"
assert length_of_longest_substring("pwwkew") == 3  # "wke"
assert length_of_longest_substring("") == 0  # Edge: empty string
assert length_of_longest_substring("a") == 1  # Edge: single char
```

**Trace through "abcabcbb":**

```
Window expands:    [a] [ab] [abc] (max=3)
                                [bca] (start moves past first 'a')
                                [cab]
                                [abb]
Max stays 3
```

**Talking point:** "The key insight is: when we see a duplicate character in our current window, we don't reset the entire state — we just move the start pointer past the old occurrence. This keeps us O(n) instead of O(n²)."

---

### Pattern 4: Intervals (g16_intervals)

**When to use:** Scheduling, meeting rooms, overlapping events, non-overlapping intervals

**Core insight:** Sort by start time, then use a single sweep to detect overlaps or merge.

**Key formula:** Two intervals overlap if `a.start <= b.end AND b.start <= a.end`

#### Example 1: Merge Intervals

```python
def merge_intervals(intervals):
    """
    Merge overlapping intervals.
  
    Approach: Sort by start time, then merge adjacent overlapping intervals
    - Time: O(n log n) for sorting
    - Space: O(1) excluding output
    """
    if not intervals:
        return []
  
    # Sort by start time
    intervals.sort(key=lambda x: x[0])
  
    merged = [intervals[0]]
  
    for start, end in intervals[1:]:
        last_start, last_end = merged[-1]
      
        # If current interval overlaps with last, merge them
        if start <= last_end:
            merged[-1] = (last_start, max(last_end, end))
        else:
            # No overlap, add as new interval
            merged.append((start, end))
  
    return merged

# Test
assert merge_intervals([(1, 3), (2, 6), (8, 10), (15, 18)]) == [(1, 6), (8, 10), (15, 18)]
assert merge_intervals([(1, 4), (4, 5)]) == [(1, 5)]  # Edge: touching intervals
assert merge_intervals([(1, 5)]) == [(1, 5)]  # Edge: single interval
assert merge_intervals([]) == []  # Edge: empty
```

**Trace through [(1,3), (2,6), (8,10), (15,18)]:**

```
After sort: [(1,3), (2,6), (8,10), (15,18)]

Step 1: merged = [(1,3)]
Step 2: (2,6) overlaps (1,3) → merge to (1,6) → merged = [(1,6)]
Step 3: (8,10) doesn't overlap (1,6) → add → merged = [(1,6), (8,10)]
Step 4: (15,18) doesn't overlap (8,10) → add → merged = [(1,6), (8,10), (15,18)]
```

**Talking point:** "Sorting is the key. Once sorted by start time, we can process in one pass. If the next interval's start is within the current interval's end, they overlap."

#### Example 2: Non-Overlapping Intervals (Greedy + Interval)

```python
def erase_overlap_intervals(intervals):
    """
    Find minimum number of intervals to remove to make rest non-overlapping.
  
    Approach: Greedy — sort by end time, remove intervals that overlap
    - Time: O(n log n) for sorting
    - Space: O(1)
    """
    if not intervals:
        return 0
  
    # Sort by END time (not start!)
    intervals.sort(key=lambda x: x[1])
  
    removed = 0
    prev_end = intervals[0][1]
  
    for start, end in intervals[1:]:
        # If current interval starts before previous ended, they overlap
        if start < prev_end:
            removed += 1
        else:
            # No overlap, update prev_end
            prev_end = end
  
    return removed

# Test
assert erase_overlap_intervals([[1, 2], [2, 3], [1, 2], [2, 4]]) == 1
assert erase_overlap_intervals([[1, 2], [1, 2], [1, 2]]) == 2
assert erase_overlap_intervals([[1, 2], [3, 4]]) == 0  # Edge: no overlap
assert erase_overlap_intervals([]) == 0  # Edge: empty
```

**Key difference:** Sort by END time (not start) for greedy selection of non-overlapping intervals. This ensures we keep the intervals that end earliest, leaving room for future intervals.

---

### Pattern 5: Heaps & Priority Queues (g8_heap_and_priority_queues)

**When to use:** Top-K problems, scheduling with priorities, min/max tracking

**Core insight:** Heap maintains order in O(log n) per operation; use when you need repeated min/max access.

#### Example 1: K Largest Elements

```python
import heapq

def find_k_largest(nums, k):
    """
    Find k largest elements in array.
  
    Approach: Min-heap of size k (keep k largest, min at top)
    - Time: O(n log k)
    - Space: O(k)
    """
    if k >= len(nums):
        return sorted(nums, reverse=True)
  
    # Min-heap of size k
    heap = nums[:k]
    heapq.heapify(heap)
  
    # For each remaining element, if it's larger than heap's min, swap it
    for num in nums[k:]:
        if num > heap[0]:
            heapq.heapreplace(heap, num)  # Remove min, add new
  
    return sorted(heap, reverse=True)

# Test
assert find_k_largest([3, 2, 1, 5, 6, 4], 2) == [6, 5]
assert find_k_largest([3, 2, 3, 1, 2, 4, 5, 5, 6], 4) == [6, 5, 5, 4]
assert find_k_largest([1, 2, 3, 4, 5], 5) == [5, 4, 3, 2, 1]  # Edge: k = len
```

**Why heap over sort:** If k is small, O(n log k) beats O(n log n). For k=2 in a 1M element array, heap is 100x faster.

#### Example 2: Meeting Rooms II (Heap + Intervals)

```python
import heapq

def min_meeting_rooms(intervals):
    """
    Find minimum number of meeting rooms needed.
  
    Approach: Sort meetings by start, heap tracks end times
    - Time: O(n log n) for sorting
    - Space: O(n) for heap
    """
    if not intervals:
        return 0
  
    # Sort by start time
    intervals.sort(key=lambda x: x[0])
  
    # Heap of end times (min at top = room that becomes free soonest)
    rooms = [intervals[0][1]]
  
    for start, end in intervals[1:]:
        # If earliest room becomes free before this meeting starts, reuse it
        if start >= rooms[0]:
            heapq.heappop(rooms)
  
        # Add this meeting's end time
        heapq.heappush(rooms, end)
  
    return len(rooms)

# Test
assert min_meeting_rooms([`) == 2
assert min_meeting_rooms([[7, 10], [2, 4]]) == 1
assert min_meeting_rooms([[0, 5], [1, 8], [2, 7], [3, 6]]) == 4  # All overlap
```

**Trace through [[0,30], [5,10], [15,20]]:**

```
After sort: [[0,30], [5,10], [15,20]]

rooms = [30]  (first meeting ends at 30)

Meeting [5,10]:
  - Does 5 >= 30? No
  - Add 10 to rooms
  - rooms = [10, 30] (heap, min at top)

Meeting [15,20]:
  - Does 15 >= 10? Yes, pop 10
  - Add 20 to rooms
  - rooms = [20, 30]

Answer: 2 rooms needed
```

---

### Pattern 6: Stack (g4_stack)

**When to use:** Parentheses validation, monotonic sequences, expression evaluation, backtracking

**Core insight:** Stack's LIFO nature matches problems requiring "match with most recent" logic.

#### Example 1: Valid Parentheses

```python
def is_valid_parentheses(s):
    """
    Check if parentheses/brackets/braces are balanced.
  
    Approach: Stack — open brackets go on, close brackets must match top
    - Time: O(n)
    - Space: O(n) for stack
    """
    stack = []
    pairs = {'(': ')', '[': ']', '{': '}'}
  
    for char in s:
        if char in pairs:
            # Opening bracket, push it
            stack.append(char)
        elif char in pairs.values():
            # Closing bracket, must match top of stack
            if not stack or pairs[stack.pop()] != char:
                return False
        # Ignore other characters
  
    return not stack  # Empty stack = all matched

# Test
assert is_valid_parentheses("()") == True
assert is_valid_parentheses("()[]{}") == True
assert is_valid_parentheses("([)]") == False  # Interleaved
assert is_valid_parentheses("([{}])") == True  # Nested
assert is_valid_parentheses("") == True  # Edge: empty
assert is_valid_parentheses("(") == False  # Edge: unmatched
```

#### Example 2: Monotonic Stack (Daily Temperatures)

```python
def daily_temperatures(temps):
    """
    For each day, find how many days until a warmer temperature.
  
    Approach: Monotonic stack — keep indices of decreasing temperatures
    - Time: O(n)
    - Space: O(n)
    """
    n = len(temps)
    result = [0] * n
    stack = []  # Stack of indices in decreasing order of temps
  
    for i in range(n):
        # Pop stack while current temp is higher than stack top
        while stack and temps[i] > temps[stack[-1]]:
            prev_idx = stack.pop()
            result[prev_idx] = i - prev_idx
      
        stack.append(i)
  
    return result

# Test
assert daily_temperatures([73, 74, 75, 71, 69, 72, 76, 73]) == [1, 1, 4, 2, 1, 1, 0, 0]
assert daily_temperatures([30, 40, 50, 60]) == [1, 1, 1, 0]  # Increasing
assert daily_temperatures([30, 60, 90]) == [1, 1, 0]  # Increasing
```

**Trace through [73,74,75,71,69,72,76,73]:**

```
i=0 (73): stack empty, push 0 → stack=[0]
i=1 (74): 74 > 73, pop 0, result[0]=1, push 1 → stack=[1]
i=2 (75): 75 > 74, pop 1, result[1]=1, push 2 → stack=[2]
i=3 (71): 71 < 75, push 3 → stack=[2,3]
i=4 (69): 69 < 71, push 4 → stack=[2,3,4]
i=5 (72): 72 > 69, pop 4, result[4]=1; 72 > 71, pop 3, result[3]=2; 72 < 75, push 5 → stack=[2,5]
i=6 (76): 76 > 72, pop 5, result[5]=1; 76 > 75, pop 2, result[2]=4; push 6 → stack=[6]
i=7 (73): 73 < 76, push 7 → stack=[6,7]
```

---

### Pattern 7: Binary Search (g5_binary_search)

**When to use:** Searching sorted arrays, finding boundaries, optimization problems

**Core insight:** Binary search eliminates half the search space each iteration (O(log n))

#### Example 1: Standard Binary Search

```python
def binary_search(nums, target):
    """
    Find index of target in sorted array, or -1 if not found.
  
    Approach: Two pointers converge on target
    - Time: O(log n)
    - Space: O(1)
    """
    left, right = 0, len(nums) - 1
  
    while left <= right:
        mid = (left + right) // 2
      
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1  # Target is in right half
        else:
            right = mid - 1  # Target is in left half
  
    return -1  # Not found

# Test
assert binary_search([1, 3, 5, 7, 9], 5) == 2
assert binary_search([1, 3, 5, 7, 9], 6) == -1
assert binary_search([1], 1) == 0  # Edge: single element
assert binary_search([], 1) == -1  # Edge: empty
```

#### Example 2: Find First Position (Boundary)

```python
def find_first_position(nums, target):
    """
    Find first (leftmost) position of target in sorted array.
  
    Approach: Binary search for boundary between values < target and >= target
    - Time: O(log n)
    - Space: O(1)
    """
    left, right = 0, len(nums) - 1
    result = -1
  
    while left <= right:
        mid = (left + right) // 2
      
        if nums[mid] == target:
            result = mid
            right = mid - 1  # Keep searching left for first occurrence
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
  
    return result

# Test
assert find_first_position([5, 7, 7, 8, 8, 10], 8) == 3
assert find_first_position([5, 7, 7, 8, 8, 10], 6) == -1
assert find_first_position([1, 1, 1, 1], 1) == 0  # Edge: all same
```

**Key insight:** Standard binary search finds *any* occurrence. To find first/last, continue searching in the appropriate direction even after finding the target.

---

### Pattern 8: Graphs (g11_graphs)

**When to use:** Networks, dependencies, shortest paths, connected components, tree problems

**Core insight:** Represent as adjacency list; traverse with BFS (shortest path) or DFS (explore all)

#### Example 1: BFS (Shortest Path)

```python
from collections import deque

def shortest_path_bfs(graph, start, end):
    """
    Find shortest path between two nodes using BFS.
  
    Approach: Queue to process level-by-level
    - Time: O(V + E) where V=vertices, E=edges
    - Space: O(V) for queue and visited
    """
    if start == end:
        return [start]
  
    visited = {start}
    queue = deque([(start, [start])])  # (node, path)
  
    while queue:
        node, path = queue.popleft()
      
        for neighbor in graph.get(node, []):
            if neighbor == end:
                return path + [neighbor]
          
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
  
    return []  # No path found

# Test
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A', 'D'],
    'D': ['B', 'C', 'E'],
    'E': ['D']
}

assert shortest_path_bfs(graph, 'A', 'E') == ['A', 'B', 'D', 'E']
assert shortest_path_bfs(graph, 'A', 'A') == ['A']  # Edge: same start/end
```

#### Example 2: DFS (Explore All)

```python
def dfs_all_paths(graph, start, end):
    """
    Find all paths from start to end using DFS.
  
    Approach: Recursion + backtracking to explore all branches
    - Time: O(V!) worst case (all permutations)
    - Space: O(V) for recursion depth
    """
    def dfs(node, target, visited, path, all_paths):
        if node == target:
            all_paths.append(path[:])  # Found a path
            return
      
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                visited.add(neighbor)
                path.append(neighbor)
                dfs(neighbor, target, visited, path, all_paths)
                path.pop()
                visited.remove(neighbor)
  
    visited = {start}
    all_paths = []
    dfs(start, end, visited, [start], all_paths)
    return all_paths

# Test
graph = {
    'A': ['B', 'C'],
    'B': ['D'],
    'C': ['D'],
    'D': ['E'],
    'E': []
}

paths = dfs_all_paths(graph, 'A', 'E')
assert len(paths) == 2  # A->B->D->E and A->C->D->E
```

**Graph representation (adjacency list):**

```python
# Best for interviews: dict of lists
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A'],
    'D': ['B']
}

# Access neighbors: graph.get(node, [])
```

---

---

---

## Part 2: Snowflake Architecture Context (For Interview Credibility)

**You won't be tested on Snowflake architecture in Round 1 Python, but understanding these concepts helps you frame your solutions correctly and speak fluently about the platform.**

### Key Snowflake Concepts

**Micro-partitions:** Roughly 50-500 MB of compressed columnar data. Snowflake tracks min/max per column, enabling pruning for free (like Hive partitions but automatic and fine-grained).

**Clustering keys:** Define sort order on hot columns. Unlike Hive, you don't manually declare partitions — Snowflake auto-manages, you just specify what columns matter.

**Virtual warehouses:** Independently scalable MPP clusters. Scale up (bigger warehouse) for slow queries on big data, scale out (multi-cluster) for concurrency.

**Streams + Tasks:** Built-in CDC (change data capture) and orchestration inside Snowflake. Relevant to your Kafka CDC background — you can do similar things in-warehouse without external streaming.

**Snowpipe vs COPY:** Snowpipe for continuous micro-batch (event-driven), COPY for bulk (scheduled). Your pipeline design decisions will reference these.

### Bridge from Hadoop to Snowflake

| Your SIG experience           | Snowflake equivalent                           |
| ----------------------------- | ---------------------------------------------- |
| HDFS blocks + Hive partitions | Micro-partitions (automatic) + clustering keys |
| YARN resource management      | Virtual warehouse sizing                       |
| Spark executor spill to disk  | Spill to SSD → remote storage                 |
| Kafka CDC into HDFS           | Snowpipe + Streams + Tasks                     |
| Airflow orchestration         | External Tasks (Snowflake) or external Airflow |

**Talking point:** "I have built at petabyte scale on Hadoop. Snowflake shares the same distributed compute and columnar storage principles — decoupled compute/storage, metadata-driven pruning, MPP execution. The main difference is Snowflake's architecture is managed service, while Hadoop required hands-on tuning."

---

## Part 2b: Clean Code Practices for Interviews

Even more important than algorithm choice is **code quality**. Snowflake engineers read and maintain code daily.

### 1. Meaningful Variable Names

```python
# ❌ Bad
def solve(l):
    d = {}
    for i, x in enumerate(l):
        if x in d:
            return [d[x], i]
        d[x] = i
    return []

# ✓ Good
def two_sum(nums, target):
    """Find two indices where nums[i] + nums[j] = target."""
    num_to_index = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in num_to_index:
            return [num_to_index[complement], i]
        num_to_index[num] = i
    return []
```

### 2. Docstrings & Comments

```python
def merge_sorted_arrays(arr1, arr2):
    """
    Merge two sorted arrays into a single sorted array.
  
    Args:
        arr1: First sorted array
        arr2: Second sorted array
  
    Returns:
        Single sorted array containing all elements
  
    Time: O(n + m) where n, m are lengths of inputs
    Space: O(n + m) for output array
    """
    result = []
    i, j = 0, 0
  
    # Walk through both arrays, always taking the smaller element
    while i < len(arr1) and j < len(arr2):
        if arr1[i] <= arr2[j]:
            result.append(arr1[i])
            i += 1
        else:
            result.append(arr2[j])
            j += 1
  
    # Append remaining elements (only one will have leftovers)
    result.extend(arr1[i:])
    result.extend(arr2[j:])
  
    return result
```

### 3. Edge Case Handling

```python
def find_max(nums):
    """Find maximum in array."""
    # Edge cases first
    if not nums:
        return None
    if len(nums) == 1:
        return nums[0]
  
    # Main logic
    max_val = nums[0]
    for num in nums[1:]:
        max_val = max(max_val, num)
  
    return max_val
```

### 4. Test-Driven Mindset

```python
def is_valid_parentheses(s):
    """Check if parentheses are balanced."""
    stack = []
    pairs = {'(': ')', '[': ']', '{': '}'}
  
    for char in s:
        if char in pairs:
            stack.append(char)
        elif char in pairs.values():
            if not stack or pairs[stack.pop()] != char:
                return False
        # Ignore other characters
  
    return not stack

# Test immediately
assert is_valid_parentheses("()") == True
assert is_valid_parentheses("()[]{}") == True
assert is_valid_parentheses("([)]") == False  # Interleaved
assert is_valid_parentheses("") == True  # Empty is valid
assert is_valid_parentheses("(") == False  # Missing close
```

---

## Part 3: Snowflake-Specific Python Patterns

These show you understand data engineering at Snowflake's scale.

### 1. Handling Missing Data

```python
def deduplicate_with_missing(records):
    """
    Deduplicate records, handling NaN/None gracefully.
  
    Context: Data from diverse sources often has missing values.
    """
    seen = set()
    deduped = []
  
    for record in records:
        # Create a hashable key, treating None as a distinct value
        key = tuple(
            None if val is None else val
            for val in record
        )
      
        if key not in seen:
            seen.add(key)
            deduped.append(record)
  
    return deduped

# Test
records = [
    (1, "Alice", None),
    (2, "Bob", "Engineer"),
    (1, "Alice", None),  # Duplicate
    (3, None, "Manager"),
    (3, None, "Manager"),  # Duplicate
]

assert len(deduplicate_with_missing(records)) == 3
```

### 2. Efficient Large Dataset Processing

```python
def process_large_dataset(data_generator, batch_size=1000):
    """
    Process data in batches to avoid memory overload.
  
    Context: Real datasets can be millions of rows.
    """
    batch = []
  
    for record in data_generator:
        batch.append(record)
      
        if len(batch) >= batch_size:
            yield process_batch(batch)
            batch = []
  
    # Don't forget final batch
    if batch:
        yield process_batch(batch)

def process_batch(batch):
    """Process a batch of records."""
    return [record.upper() if isinstance(record, str) else record for record in batch]
```

### 3. Data Validation

```python
def validate_records(records):
    """
    Validate records before inserting into warehouse.
  
    Context: Garbage in = garbage out. Validation prevents bad data loads.
    """
    errors = []
    valid = []
  
    for i, record in enumerate(records):
        error = validate_record(record)
        if error:
            errors.append((i, error))
        else:
            valid.append(record)
  
    return valid, errors

def validate_record(record):
    """Check if record meets quality standards."""
    if not record:
        return "Empty record"
    if len(record) != 3:
        return f"Expected 3 fields, got {len(record)}"
    if not isinstance(record[0], int) or record[0] <= 0:
        return "First field must be positive integer"
    return None
```

---

## Part 4: Study Roadmap & Timeline

You have ~7 days until May 18. Here's the focused plan across 8 patterns:

### Priority Tier System

**Tier 1 (Must-know for May 18):** g1, g2, g3
**Tier 2 (High value, time permitting):** g16, g8, g11
**Tier 3 (Polish, lowest ROI):** g4, g5

### Days 1-2: Tier 1 — Core Three Patterns (g1, g2, g3)

**Time:** 3-4 hours total

Do these in order:

1. **g1 (Hash Maps):** 2 problems

   - Two Sum
   - Valid Anagram
2. **g2 (Two Pointers):** 2 problems

   - Valid Palindrome
   - Merge Sorted Array
3. **g3 (Sliding Window):** 2 problems

   - Longest Substring Without Repeating
   - Max Consecutive Ones III

**For each problem:**

- Read the problem thoroughly
- Think out loud (pretend explaining to interviewer)
- Code with meaningful variable names
- Test 3+ cases (normal, edge, empty)
- Explain time/space complexity

**After finishing:** Message me "Done with g1-g3, ready for pattern quiz"

---

### Days 3: Tier 2 — Intervals & Heaps (g16, g8)

**Time:** 2-3 hours

**Why now:** Intervals are self-contained, heaps build on interval understanding.

1. **g16 (Intervals):** 2-3 problems

   - Merge Intervals
   - Non-Overlapping Intervals
   - Insert Interval (if time)
2. **g8 (Heaps):** 1-2 problems

   - K Largest Elements
   - Meeting Rooms II (ties heap + intervals together)

**Key takeaway from intervals:** Sort by start time (or end for greedy), then single sweep. The `a.start <= b.end` overlap formula applies in real databases too.

**Key takeaway from heaps:** Min-heap for top-K is O(n log k), which beats O(n log n) sorting when k is small.

---

### Day 4: Tier 2 — Graphs (g11)

**Time:** 2-3 hours

1. **g11 (Graphs):** 2 problems
   - Shortest Path (BFS)
   - All Paths (DFS with backtracking)

**Mental shift here:** Graphs are different from arrays. You're representing relationships between nodes, not linear data. Practice the adjacency list representation.

---

### Days 5: Tier 3 — Stack & Binary Search (g4, g5)

**Time:** 1-2 hours (only if ahead of schedule)

1. **g4 (Stack):** 1-2 problems

   - Valid Parentheses
   - Daily Temperatures (monotonic stack)
2. **g5 (Binary Search):** 1 problem

   - Binary Search or Find First Position

**These are icing on the cake.** If you're running short on time, skip these and focus on SQL.

---

### Days 6: SQL Deep Dive

**This is actually more important than Python for Snowflake.**

Focus on:

- Window functions (ROW_NUMBER, LAG/LEAD, SUM OVER)
- Aggregations with GROUP BY
- Joins (inner, left, on complex conditions)
- CTEs (WITH ... AS)
- Intervals (BETWEEN, overlapping date ranges)

From your Snowflake_Senior_DE_REQ19469_Prep.md: solve 2-3 SQL Hards.

---

### Days 7: Practice Under Realistic Conditions

**Do 1-2 mock sessions:**

**Mock 1 (Day 6, evening):**

- 1 Python Medium (no time limit, but write clean code)
- 1 SQL Medium (no time limit)

**Mock 2 (Day 7, morning):**

- Fresh Python Medium
- Fresh SQL Hard

**How to mock:** Ping me with "ready for mock" and I'll give you a fresh problem. You code, I play interviewer and ask follow-up questions.

---

### Day 7 evening: Review & Polish

- Review your strongest patterns (15 min each)
- Skim SQL window function syntax
- Get good sleep

---

## Part 5: What to Memorize

**Data structures & their operations:**

```python
# Lists - O(1) append, O(n) insert/delete at position
lst = [1, 2, 3]
lst.append(4)       # O(1)
lst.insert(0, 0)    # O(n)

# Hash Map - O(1) average
d = {'key': 'value'}
d['new_key'] = 'new_val'

# Set - O(1) average
s = {1, 2, 3}
s.add(4)

# Heap - O(log n) for push/pop
import heapq
heapq.heappush(heap, item)
heapq.heappop(heap)

# Deque - O(1) for popleft, append
from collections import deque
q = deque()
q.append(1)
q.popleft()

# Counter - O(1) for counting
from collections import Counter
c = Counter([1, 1, 2, 3, 3, 3])
c.most_common(2)  # [(3, 3), (1, 2)]
```

**Essential functions:**

```python
# Sorting
sorted(arr)                    # O(n log n)
sorted(arr, reverse=True)
sorted(arr, key=lambda x: x[1])

# Iteration
enumerate(arr)
zip(arr1, arr2)

# Ranges
range(5)      # 0, 1, 2, 3, 4
range(2, 5)   # 2, 3, 4
range(0, 10, 2)  # 0, 2, 4, 6, 8
```

---

## Part 6: How to Approach the Interview

**They are not grading you on speed. They are grading you on:**

1. **Understanding** — Ask clarifying questions
2. **Approach** — Explain your strategy before coding
3. **Code Quality** — Clean, readable, well-commented
4. **Testing** — Walk through examples, catch edge cases
5. **Communication** — Talk through your thinking

**When you sit down:**

1. **Clarify the problem** (2 min)

   - "Can the array be empty?"
   - "What if there are duplicates?"
   - "Are we sorting in-place or can we use extra space?"
2. **Explain your approach** (3 min)

   - "I'll use a hash map to track..."
   - "This gives me O(n) time..."
   - Get buy-in from interviewer
3. **Code** (20 min)

   - Write slowly, clearly
   - Use good variable names
   - Add a docstring
4. **Test** (5 min)

   - Walk through an example
   - Test an edge case
   - Discuss complexity

---

## Part 7: Mock Interview Roadmap

**When you're ready to mock:**

1. **Message me:** "Ready for mock - (Pattern)"

   - Example: "Ready for mock - Two Pointers"
2. **I'll send you:**

   - A fresh Python problem you haven't seen
   - 25-35 min to solve (no pressure on speed)
   - You code with voice thinking (real interview style)
3. **After you solve:**

   - I'll ask follow-ups: "What if the input is unsorted? How would you optimize?"
   - We'll debrief: "Here's what landed well / here's what to strengthen"
4. **Second mock:**

   - Mix of Python + SQL
   - More realistic interview pressure
   - Behavioral component (tell me about a challenging project)

**Schedule:** After you finish reading this guide, do one mock. Then day 6, one more. That's enough.

---

## Part 8: Red Flags to Avoid

❌ **Don't do this:**

- Jump to coding without explaining your approach
- Write cryptic variable names (x, l, d, etc.)
- Skip edge cases (empty input, single element, duplicates)
- Finish and immediately say "I'm done" without testing
- Write code with no comments for complex logic
- Use obscure Python tricks to look smart
- Say "I would just use [SIG]" → always say **Susquehanna**
- Say "I have never used Snowflake" without a bridge → say "I have not run Snowflake in production, but architecturally..."
- Claim Snowflake is "just like Hadoop" → they share primitives but different architecture

✓ **Do this instead:**

- Talk through your thinking first
- Use clear names (num_to_index, is_valid, left_ptr)
- Test 3-4 cases before declaring victory
- Walk the interviewer through your code
- Comment tricky parts
- Optimize after it works
- Bridge SIG/Hadoop experience to Snowflake: "I've built at petabyte scale on similar architecture — decoupled compute/storage, columnar, MPP execution"

---

## Part 9: Cheat Sheet — Quick Reference Before the Interview

**Python patterns to know cold:**

```python
# Hash map for counting / lookup
from collections import Counter
c = Counter([1, 1, 2, 3, 3, 3])
c.most_common(2)  # [(3, 3), (1, 2)]

# Two pointer on sorted data
left, right = 0, len(arr) - 1
while left < right:
    ...

# Heapq for top-K
import heapq
heapq.heappush(heap, item)
heapq.heappop(heap)
heapq.nlargest(k, arr)

# BFS with deque
from collections import deque
q = deque([start])
while q:
    node = q.popleft()

# Defaultdict for grouping
from collections import defaultdict
groups = defaultdict(list)
groups[key].append(value)

# Common gotchas
# ❌ Wrong: shallow copy of 2D array
matrix = [[0] * 3] * 3
# ✓ Correct: 
matrix = [[0] * 3 for _ in range(3)]

# ❌ Wrong: mutable default argument
def func(arr=[]):
    arr.append(1)
# ✓ Correct:
def func(arr=None):
    if arr is None:
        arr = []
```

**Interview SQL patterns** (to have context):

- Window functions: `ROW_NUMBER`, `LAG/LEAD`, `SUM OVER`
- Interval overlap: `a.start <= b.end AND b.start <= a.end`
- Date bucketing: `DATE_TRUNC('day', ts)`
- Anti-joins: `LEFT JOIN WHERE NULL`

**Your talking-point anchors** (from your resume):

- 75% operational overhead reduction via config-driven PySpark framework
- 800+ production pipelines owned
- 50% processing runtime reduction
- 60% faster data delivery
- 70% faster incident resolution
- Zero-downtime Hadoop v2.6 → v3.1 migration

---

## Part 10: Final Checklist

**One week before (May 11):**

- [ ] Read this guide top to bottom
- [ ] Do the 6 core problems (2 each from g1, g2, g3)
- [ ] Test them thoroughly

**Three days before (May 15):**

- [ ] Do 2 SQL Hards from main prep guide
- [ ] Review window function syntax
- [ ] Schedule first mock with Claude

**Day before (May 17):**

- [ ] Do one more quick mock if time
- [ ] Review the three core patterns
- [ ] Get good sleep

**Interview day (May 18):**

- [ ] Log on 5 min early
- [ ] Breathe, they want you to succeed
- [ ] Clarify, explain, code, test
- [ ] You've got this

---

## Next Steps

1. **Right now:** Read Part 1 (patterns) carefully with the examples
2. **Today:** Do the 2 g1 problems, test them thoroughly
3. **Tomorrow:** Do g2 + g3 problems the same way
4. **Message me:** "Done with g1-g3, ready for pattern quiz"
5. **I'll quiz you:** 4 pattern questions + 1 fresh coding problem
6. **After quiz:** You'll know exactly where to focus before May 18

---

**You've got 7 days and a solid prep roadmap. The interview is looking for correctness, communication, and clean code — not speed racing. You've built large-scale data pipelines at petabyte scale; these problems are well within your reach.**

**Good luck. See you at the pattern quiz.**
