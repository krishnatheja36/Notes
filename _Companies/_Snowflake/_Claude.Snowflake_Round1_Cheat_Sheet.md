# SNOWFLAKE INTERVIEW CHEAT SHEET — Know This Cold

**Print this. Memorize this. Reference this before the interview.**

---

# PAGE 1: PYTHON IMPORTS & SYNTAX

## Critical Imports (MEMORIZE THESE)

```python
from collections import Counter, defaultdict, deque, OrderedDict, namedtuple
from itertools import combinations, permutations, groupby
import heapq
from bisect import bisect_left, bisect_right, insort
from functools import reduce, lru_cache
import json, re, math, random
from copy import copy, deepcopy
```

## Time Complexity Reference

| Structure  | Access | Insert   | Delete   | Search | Space |
| ---------- | ------ | -------- | -------- | ------ | ----- |
| List       | O(1)   | O(n)     | O(n)     | O(n)   | O(n)  |
| Dict/Set   | O(1)   | O(1)     | O(1)     | O(1)   | O(n)  |
| Heap (Min) | O(1)   | O(log n) | O(log n) | O(n)   | O(n)  |
| Deque      | O(1)   | O(1)     | O(1)     | O(n)   | O(n)  |

## Pattern 1: Hash Maps & Counting (g1)

**Two Sum:**

```python
def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []
```

**Count Frequencies:**

```python
from collections import Counter

count = Counter(nums)  # {item: frequency}
count.most_common(k)   # [(item, freq), ...] sorted by freq
list(count.keys())     # all unique items
```

---

## Pattern 2: Two Pointers (g2)

**Valid Palindrome:**

```python
def is_palindrome(s):
    left, right = 0, len(s) - 1
    while left < right:
        # Skip non-alphanumeric
        while left < right and not s[left].isalnum():
            left += 1
        while left < right and not s[right].isalnum():
            right -= 1
        # Compare
        if s[left].lower() != s[right].lower():
            return False
        left += 1
        right -= 1
    return True
```

**Merge Sorted Arrays:**

```python
def merge_sorted(arr1, arr2):
    merged = []
    i, j = 0, 0
    while i < len(arr1) and j < len(arr2):
        if arr1[i] <= arr2[j]:
            merged.append(arr1[i])
            i += 1
        else:
            merged.append(arr2[j])
            j += 1
    # Add remaining
    merged.extend(arr1[i:])
    merged.extend(arr2[j:])
    return merged
```

---

## Pattern 3: Sliding Window (g3)

**Longest Substring Without Repeating:**

```python
def length_of_longest_substring(s):
    window = {}
    left = 0
    max_len = 0
  
    for right in range(len(s)):
        # Add right character
        window[s[right]] = right
      
        # If duplicate, move left past previous occurrence
        if s[right] in window and window[s[right]] < right:
            left = window[s[right]] + 1
      
        max_len = max(max_len, right - left + 1)
  
    return max_len
```

**Template:**

```python
window = {}
left = 0
for right in range(len(s)):
    # Expand: add s[right]
    window[s[right]] = ...
  
    # Contract: while invalid
    while condition_invalid:
        del window[s[left]]
        left += 1
  
    # Update answer
    answer = max(answer, right - left + 1)
```

---

## Pattern 4: Intervals (g16)

**Merge Intervals:**

```python
def merge_intervals(intervals):
    if not intervals:
        return []
  
    intervals.sort(key=lambda x: x[0])
    merged = [intervals[0]]
  
    for start, end in intervals[1:]:
        # Overlapping intervals
        if start <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], end))
        else:
            merged.append((start, end))
  
    return merged
```

**KEY FORMULA - Interval Overlap:**

```python
# Two intervals overlap if:
if a.start <= b.end and b.start <= a.end:
    # Intervals overlap
    pass
```

**Erase Overlapping Intervals (Greedy):**

```python
def erase_overlap_intervals(intervals):
    if not intervals:
        return 0
  
    intervals.sort(key=lambda x: x[1])  # Sort by end time
    removed = 0
    end = intervals[0][1]
  
    for start, curr_end in intervals[1:]:
        if start < end:  # Overlapping
            removed += 1
        else:
            end = curr_end
  
    return removed
```

---

## Pattern 5: Heaps & Priority Queues (g8)

**Find K Largest:**

```python
import heapq

def find_k_largest(nums, k):
    return heapq.nlargest(k, nums)  # Top k largest
    # or
    return heapq.nsmallest(k, nums)  # Top k smallest

# Manual heap
heap = []
heapq.heappush(heap, item)      # Add, O(log n)
heapq.heappop(heap)             # Remove min, O(log n)
heapq.heapify(arr)              # Build heap, O(n)

# Max-heap: negate values
heapq.heappush(heap, -value)
val = -heapq.heappop(heap)
```

**Min Meeting Rooms:**

```python
def min_meeting_rooms(intervals):
    starts = sorted([s for s, e in intervals])
    ends = sorted([e for s, e in intervals])
  
    rooms = 0
    i, j = 0, 0
  
    while i < len(starts):
        if starts[i] < ends[j]:
            rooms += 1
            i += 1
        else:
            rooms -= 1
            j += 1
  
    return rooms
```

---

## Pattern 6: Stack (g4)

**Valid Parentheses:**

```python
def is_valid_parentheses(s):
    stack = []
    pairs = {'(': ')', '[': ']', '{': '}'}
  
    for char in s:
        if char in pairs:  # Opening bracket
            stack.append(char)
        else:  # Closing bracket
            if not stack or pairs[stack.pop()] != char:
                return False
  
    return not stack
```

**Daily Temperatures (Monotonic Stack):**

```python
def daily_temperatures(temps):
    result = [0] * len(temps)
    stack = []  # Store indices
  
    for i, temp in enumerate(temps):
        while stack and temps[stack[-1]] < temp:
            prev_idx = stack.pop()
            result[prev_idx] = i - prev_idx
        stack.append(i)
  
    return result
```

---

## Pattern 7: Binary Search (g5)

**Standard Binary Search:**

```python
def binary_search(nums, target):
    left, right = 0, len(nums) - 1
  
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
  
    return -1  # Not found
```

**Find First Position (Boundary Finding):**

```python
def find_first(nums, target):
    left, right = 0, len(nums) - 1
    result = -1
  
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            result = mid
            right = mid - 1  # Keep searching left
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
  
    return result
```

---

## Pattern 8: Graphs (g11)

**BFS (Shortest Path):**

```python
from collections import deque

def shortest_path_bfs(graph, start, end):
    visited = {start}
    queue = deque([(start, [start])])
  
    while queue:
        node, path = queue.popleft()
        if node == end:
            return path
      
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
  
    return []  # No path
```

**DFS (All Paths):**

```python
def dfs_all_paths(graph, start, end, visited, path, all_paths):
    if start == end:
        all_paths.append(path[:])
        return
  
    for neighbor in graph.get(start, []):
        if neighbor not in visited:
            visited.add(neighbor)
            path.append(neighbor)
            dfs_all_paths(graph, neighbor, end, visited, path, all_paths)
            path.pop()
            visited.remove(neighbor)
```

---

# PAGE 2: SQL ESSENTIALS

## Window Functions (MASTER THESE)

**Basic Syntax:**

```sql
function() OVER ([PARTITION BY col] [ORDER BY col] [frame])
```

**Ranking Functions:**

```sql
ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary)   -- 1,2,3,4
RANK() OVER (PARTITION BY dept ORDER BY salary)         -- 1,2,2,4
DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary)   -- 1,2,2,3
```

**Offset Functions:**

```sql
LAG(col, 1) OVER (ORDER BY col)      -- previous row
LEAD(col, 1) OVER (ORDER BY col)     -- next row
FIRST_VALUE(col) OVER (ORDER BY col) -- first in partition
LAST_VALUE(col) OVER (...)           -- last in partition (GOTCHA: needs frame!)
```

**Aggregate Window Functions:**

```sql
SUM(col) OVER (PARTITION BY dept)  -- total per dept
AVG(col) OVER (PARTITION BY dept ORDER BY salary ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
COUNT(*) OVER (PARTITION BY dept)
MIN/MAX(col) OVER (...)
```

**GOTCHA - LAST_VALUE Frame:**

```sql
-- ❌ WRONG: has default frame that ends at current row
SELECT LAST_VALUE(col) OVER (ORDER BY col)

-- ✓ CORRECT: specify unbounded frame
SELECT LAST_VALUE(col) OVER (
    ORDER BY col 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

---

## CTEs & Recursion

**Basic CTE:**

```sql
WITH cte AS (
    SELECT col1, col2
    FROM table1
    WHERE condition
)
SELECT * FROM cte;
```

**Multiple CTEs:**

```sql
WITH cte1 AS (
    SELECT col1, col2 FROM table1
),
cte2 AS (
    SELECT col1, col2 FROM table2
)
SELECT * FROM cte1 JOIN cte2 ON cte1.col1 = cte2.col1;
```

**Recursive CTE:**

```sql
WITH RECURSIVE cte AS (
    -- Anchor (base case)
    SELECT id, parent_id, 1 AS level
    FROM table1
    WHERE parent_id IS NULL
  
    UNION ALL
  
    -- Recursive (recursive case)
    SELECT t.id, t.parent_id, c.level + 1
    FROM table1 t
    JOIN cte c ON t.parent_id = c.id
    WHERE c.level < 10  -- STOP condition
)
SELECT * FROM cte;
```

---

## Critical Interview Patterns

### 1. Subscription Overlap (Interval Overlap)

```sql
-- KEY FORMULA: a.start <= b.end AND b.start <= a.end
SELECT a.user_id,
       CASE WHEN EXISTS (
           SELECT 1
           FROM subscriptions b
           WHERE b.user_id <> a.user_id
             AND b.end_date IS NOT NULL
             AND a.start_date <= b.end_date
             AND b.start_date <= a.end_date
       ) THEN 1 ELSE 0 END AS overlap
FROM subscriptions a
WHERE a.end_date IS NOT NULL
ORDER BY a.user_id;
```

### 2. Flight Routes (Pair Normalization with LEAST/GREATEST)

```sql
SELECT DISTINCT
    LEAST(origin, destination) AS loc1,
    GREATEST(origin, destination) AS loc2
FROM flights
ORDER BY loc1, loc2;
```

### 3. Paired Products (Self-Join with Ordering)

```sql
SELECT p1.product_name AS p1,
       p2.product_name AS p2,
       COUNT(*) AS count
FROM transactions p1
INNER JOIN transactions p2
    ON p1.user_id = p2.user_id
    AND p1.product_name < p2.product_name  -- enforce ordering
GROUP BY p1.product_name, p2.product_name
ORDER BY count DESC
LIMIT 5;
```

### 4. First Touch Attribution (CTE + MAX(CASE))

```sql
WITH first_session AS (
    SELECT user_id, MIN(session_date) AS first_date, channel
    FROM sessions
    GROUP BY user_id
),
conversions AS (
    SELECT user_id,
           MAX(CASE WHEN converted = 1 THEN session_date END) AS conv_date
    FROM sessions
    GROUP BY user_id
    HAVING conv_date IS NOT NULL
)
SELECT c.user_id, f.channel AS first_channel, c.conv_date
FROM conversions c
JOIN first_session f ON c.user_id = f.user_id
ORDER BY c.user_id;
```

### 5. Rolling Average (Window Frame - ROWS vs RANGE)

```sql
-- KEY: ROWS BETWEEN N PRECEDING AND CURRENT ROW (positional, not value-based)
SELECT dt,
       AVG(amount) OVER (
           ORDER BY dt
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS rolling_3day
FROM transactions
ORDER BY dt;

-- ROWS = positional (last 3 rows)
-- RANGE = value-based (last 3 days of values, handles duplicates)
-- For "last N days" use ROWS, for "last N days of values" use RANGE
```

### 6. Department Top 3 Salaries (RANK for Ranking with Ties)

```sql
WITH ranked_salaries AS (
    SELECT department,
           salary,
           COUNT(*) AS count,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
    FROM employees
    GROUP BY department, salary
)
SELECT department, salary, count
FROM ranked_salaries
WHERE rank <= 3
ORDER BY department, salary DESC;

-- RANK handles ties (1,2,2,4)
-- ROW_NUMBER breaks ties (1,2,3,4)
```

---

## Date/String Functions (Snowflake)

**Date Operations:**

```sql
DATE_TRUNC('DAY', timestamp_col)     -- truncate to day
DATEADD(DAY, 5, date_col)            -- add 5 days
DATEDIFF(DAY, date1, date2)          -- days between
TO_CHAR(date_col, 'YYYY-MM-DD')      -- format date
DATE_PART('MONTH', date_col)         -- extract month (1-12)
```

**String Operations:**

```sql
SUBSTR(str, start, length)           -- substring (1-indexed in SQL!)
LENGTH(str)
UPPER(str), LOWER(str), TRIM(str)
CONCAT(str1, str2) or str1 || str2   -- concatenate
REPLACE(str, old, new)
SPLIT_PART(str, delimiter, position)
```

---

## JOIN Patterns

**Inner Join (Only Matches):**

```sql
SELECT * FROM a INNER JOIN b ON a.id = b.id;
```

**Left Join (All Left, Matching Right):**

```sql
SELECT * FROM a LEFT JOIN b ON a.id = b.id;
```

**Anti-Join (In A But NOT in B):**

```sql
SELECT * FROM a LEFT JOIN b ON a.id = b.id 
WHERE b.id IS NULL;
```

**Self-Join for Pairs (No Duplicates):**

```sql
-- Only get (A, B) not (B, A)
SELECT a.id, b.id 
FROM table a
JOIN table b ON a.id < b.id;
```

---

## NULL Handling

**NULL is Never Equal to Anything:**

```sql
-- ❌ Wrong
WHERE col = NULL     -- always FALSE

-- ✓ Correct
WHERE col IS NULL
WHERE col IS NOT NULL
```

**COALESCE Returns First Non-Null:**

```sql
COALESCE(col1, col2, col3, 'default')
```

**NULLs in Aggregates (Ignored):**

```sql
COUNT(*)    -- counts rows (including NULL rows)
COUNT(col)  -- counts non-NULL values only
SUM(col)    -- ignores NULLs
AVG(col)    -- ignores NULLs
```

---

# PAGE 3: CRITICAL GOTCHAS & PATTERNS

## Python Gotchas

**❌ Shallow Copy (Arrays of Arrays):**

```python
# WRONG: all rows point to same array
matrix = [[0] * 3] * 3

# CORRECT: deep copy
matrix = [[0] * 3 for _ in range(3)]
```

**❌ Mutable Default Arguments:**

```python
# WRONG: list persists across function calls
def func(arr=[]):
    arr.append(1)

# CORRECT:
def func(arr=None):
    if arr is None:
        arr = []
```

**Slicing (0-indexed, End Exclusive):**

```python
arr[1:4]     # indices 1, 2, 3 (NOT 4)
arr[::-1]    # reverse
arr[::2]     # every other element
```

**String Operations:**

```python
s.upper(), s.lower(), s.strip()
s.split()                          # split on whitespace
''.join(list)                      # join list into string
s[i]                               # char at index i
ord('A')  # 65                     # char to ASCII
chr(65)   # 'A'                    # ASCII to char
```

---

## SQL Gotchas

**❌ Non-Aggregated Column Not in GROUP BY:**

```sql
-- WRONG
SELECT dept, salary, COUNT(*) FROM employees;

-- CORRECT
SELECT dept, salary, COUNT(*) FROM employees GROUP BY dept, salary;
```

**❌ DISTINCT with Aggregates:**

```sql
-- WRONG: mixing DISTINCT and non-aggregated column
SELECT DISTINCT dept, COUNT(*) FROM employees;

-- CORRECT:
SELECT dept, COUNT(*) FROM employees GROUP BY dept;

-- OK: DISTINCT inside aggregate
SELECT COUNT(DISTINCT dept) FROM employees;
```

**❌ LAST_VALUE Without Explicit Frame:**

```sql
-- WRONG: default frame ends at current row
SELECT LAST_VALUE(col) OVER (ORDER BY col)

-- CORRECT:
SELECT LAST_VALUE(col) OVER (ORDER BY col ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
```

**❌ Non-Deterministic ORDER BY in Window:**

```sql
-- WRONG: if multiple rows have same salary, result is non-deterministic
SELECT ROW_NUMBER() OVER (ORDER BY salary)

-- CORRECT: add tiebreaker
SELECT ROW_NUMBER() OVER (ORDER BY salary, emp_id)
```

**❌ UNION Removes Duplicates (Use UNION ALL):**

```sql
-- UNION removes duplicates (slow)
SELECT col FROM table1
UNION
SELECT col FROM table2;

-- UNION ALL keeps duplicates (faster)
SELECT col FROM table1
UNION ALL
SELECT col FROM table2;
```

---

## Clean Code Checklist (During Interview)

✅ **Meaningful variable names:** `target_sum`, `left_pointer`, not `x`, `l`, `d`
✅ **Docstrings:** Explain approach, time/space complexity
✅ **Edge cases:** Empty input, single element, all duplicates, negative numbers
✅ **Test with examples:** At least 3 test cases (normal, edge, boundary)
✅ **Explain out loud:** Walk through your logic as you code
✅ **Avoid deep nesting:** Extract helper functions
✅ **One responsibility per function:** Don't do parsing + logic + testing in one func

---

## What to Remember Cold

### Python

1. **Counter.most_common(k)** — frequency + sorting
2. **Interval overlap formula:** `a.start <= b.end AND b.start <= a.end`
3. **Sliding window template:** expand right, contract left on invalid
4. **Heap operations:** heappush, heappop, heapify, nlargest
5. **BFS vs DFS:** BFS for shortest path, DFS for all paths
6. **Two pointers:** useful for sorted arrays, palindromes

### SQL

1. **Window frame:** `ROWS BETWEEN N PRECEDING AND CURRENT ROW` (positional, not value-based)
2. **Self-join without duplicates:** `a.id < b.id` (not `<>`)
3. **Interval overlap:** `a.start <= b.end AND b.start <= a.end`
4. **LEAST/GREATEST:** normalize pairs regardless of order
5. **MAX(CASE WHEN):** find date/value from matching condition
6. **GROUP BY requirements:** all non-aggregated columns must be in GROUP BY

---

## During Interview — If You Get Stuck

1. **Pause 1-2 seconds** — shows you're thinking
2. **Say something true** — "Let me think about this for a moment"
3. **Ask clarifying questions** — "Are you asking about X or Y?"
4. **Pseudocode first** — then fill in syntax
5. **Test with example** — trace through with real data
6. **Admit gaps** — "I don't remember the exact syntax, let me write it out"

---

## Final Checklist Before Interview

- [ ] Read this sheet once
- [ ] Practice your 60-second pitch (Susquehanna, 800+ pipelines, config framework)
- [ ] Solve one Python problem from each pattern (g1, g2, g3)
- [ ] Solve one SQL problem from interview list (overlap, routes, products, attribution, rolling, top-k)
- [ ] Time yourself on one timed mock
- [ ] Get 8 hours of sleep
- [ ] Join Zoom 2 min early
- [ ] Smile — it comes through in your voice

---

**You know this. You've built 800+ pipelines. You've led modernizations. You can do this.**

**Go crush it.**
