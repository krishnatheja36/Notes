# Snowflake Round 1 — Final Interview Guide

**Interview:** Monday May 18, 2026 — 2:00 PM EDT
**Interviewers:** Divya Sharma + Kavya Sree Rajula (both Senior DEs)
**Format:** 1 hour, non-timed, Python + SQL, collaborative
**Zoom:** https://snowflake.zoom.us/j/83880695567?pwd=li7cBr0GdutvuYGHFRJ9WYkvA4w0HQ.1

---

## THE MOST IMPORTANT THING

**This round is non-timed and collaborative.**

- Talk through your approach BEFORE coding
- Think out loud WHILE coding
- Ask clarifying questions — they want to see your reasoning
- Correctness + clarity > speed

---

# SECTION 1: ROLE CONTEXT (2 min read)

## What This Job Actually Is

- **Internal data engineering** — not Snowflake's product, but Snowflake's own data infrastructure
- **Stack:** dbt + Airflow + Snowflake
- **Team owns:** ingestion from Salesforce/Workday/etc., executive reporting, data platform

## Your Bridge (Say This If Asked About Experience)

> "I haven't run Snowflake in production, but architecturally I understand the model — decoupled storage and compute, micro-partitioned columnar storage, MPP execution. At Susquehanna I've built petabyte-scale infrastructure on Hadoop/Hive with the same fundamental patterns: partitioning strategy, columnar formats (Parquet/ORC), resource isolation on YARN. Same concepts, different packaging."

## Your Resume Metrics — Drop These Naturally

- **800+ production pipelines** owned
- **75% operational overhead reduction** via config-driven PySpark framework
- **50% processing runtime reduction**
- **70% faster incident resolution**
- **Zero-downtime Hadoop v2.6 → v3.1 migration**

---

# SECTION 2: PYTHON PATTERNS (Know These Cold)

## Critical Imports

```python
from collections import Counter, defaultdict, deque, OrderedDict
import heapq
from bisect import bisect_left, bisect_right
from functools import reduce, lru_cache
import re, math
```

## Time Complexity

| Structure | Access | Insert | Delete | Search |
|---|---|---|---|---|
| List | O(1) | O(n) | O(n) | O(n) |
| Dict/Set | O(1) | O(1) | O(1) | O(1) |
| Heap | O(1) top | O(log n) | O(log n) | O(n) |
| Deque | O(1) both | O(1) both | O(1) both | O(n) |

---

## Pattern 1: Hash Maps (g1) — TIER 1

```python
# Two Sum
def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        if target - num in seen:
            return [seen[target - num], i]
        seen[num] = i

# Counting
from collections import Counter
freq = Counter(arr)
freq.most_common(k)   # top k items
```

---

## Pattern 2: Two Pointers (g2) — TIER 1

```python
# Valid Palindrome
def is_palindrome(s):
    left, right = 0, len(s) - 1
    while left < right:
        while left < right and not s[left].isalnum(): left += 1
        while left < right and not s[right].isalnum(): right -= 1
        if s[left].lower() != s[right].lower(): return False
        left += 1; right -= 1
    return True

# Merge Sorted
def merge_sorted(a, b):
    result, i, j = [], 0, 0
    while i < len(a) and j < len(b):
        if a[i] <= b[j]: result.append(a[i]); i += 1
        else: result.append(b[j]); j += 1
    result.extend(a[i:]); result.extend(b[j:])
    return result
```

---

## Pattern 3: Sliding Window (g3) — TIER 1

```python
# Longest substring without repeating
def length_of_longest_substring(s):
    window, left, max_len = {}, 0, 0
    for right in range(len(s)):
        if s[right] in window and window[s[right]] >= left:
            left = window[s[right]] + 1
        window[s[right]] = right
        max_len = max(max_len, right - left + 1)
    return max_len
```

---

## Pattern 4: Intervals (g16) — TIER 2

```python
# Merge intervals
def merge_intervals(intervals):
    intervals.sort(key=lambda x: x[0])
    merged = [intervals[0]]
    for start, end in intervals[1:]:
        if start <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], end))
        else:
            merged.append((start, end))
    return merged

# KEY FORMULA — interval overlap:
# a.start <= b.end AND b.start <= a.end
```

---

## Pattern 5: Heaps (g8) — TIER 2

```python
import heapq

heapq.heappush(heap, item)       # O(log n)
heapq.heappop(heap)              # O(log n) removes min
heapq.heapify(arr)               # O(n)
heapq.nlargest(k, arr)           # top k largest
heapq.nsmallest(k, arr)          # top k smallest

# Max-heap: negate values
heapq.heappush(heap, -value)
val = -heapq.heappop(heap)
```

---

## Pattern 6: Stack (g4) — TIER 2

```python
# Valid parentheses
def is_valid(s):
    stack = []
    pairs = {')': '(', ']': '[', '}': '{'}
    for char in s:
        if char in '([{': stack.append(char)
        elif not stack or stack.pop() != pairs[char]: return False
    return not stack
```

---

## Pattern 7: Binary Search (g5) — TIER 3

```python
def binary_search(nums, target):
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target: return mid
        elif nums[mid] < target: left = mid + 1
        else: right = mid - 1
    return -1
```

---

## Pattern 8: Graphs (g11) — TIER 2

```python
from collections import deque

# BFS — shortest path
def bfs(graph, start, end):
    visited, queue = {start}, deque([(start, [start])])
    while queue:
        node, path = queue.popleft()
        if node == end: return path
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
    return []

# DFS — all paths
def dfs(graph, node, end, visited, path, all_paths):
    if node == end: all_paths.append(path[:]); return
    for neighbor in graph.get(node, []):
        if neighbor not in visited:
            visited.add(neighbor); path.append(neighbor)
            dfs(graph, neighbor, end, visited, path, all_paths)
            path.pop(); visited.remove(neighbor)
```

---

## Python Gotchas

```python
# ❌ Shallow copy
matrix = [[0] * 3] * 3

# ✅ Deep copy
matrix = [[0] * 3 for _ in range(3)]

# ❌ Mutable default argument
def func(arr=[]):

# ✅ Correct
def func(arr=None):
    if arr is None: arr = []

# Slicing: 0-indexed, end exclusive
arr[1:4]   # indices 1, 2, 3 (NOT 4)
arr[::-1]  # reverse
```

---

## Clean Code Checklist

✅ Meaningful names: `target_sum`, not `x`
✅ Docstring with approach + complexity
✅ Test 3+ cases (normal, edge, empty)
✅ Handle None/empty input
✅ Talk while you code

---

# SECTION 3: SQL PATTERNS (Know These Cold)

## Window Functions

```sql
-- Basic syntax
function() OVER ([PARTITION BY col] [ORDER BY col] [frame])

-- Ranking
ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC)  -- 1,2,3,4
RANK()       OVER (PARTITION BY dept ORDER BY salary DESC)  -- 1,2,2,4
DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC)  -- 1,2,2,3

-- Offset
LAG(col)  OVER (ORDER BY col)   -- previous row
LEAD(col) OVER (ORDER BY col)   -- next row

-- Rolling
AVG(col) OVER (ORDER BY col ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

-- GOTCHA: LAST_VALUE needs explicit frame
LAST_VALUE(col) OVER (ORDER BY col ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
```

---

## 6 Interview SQL Problems (Know These Cold)

### 1. Subscription Overlap
```sql
-- KEY: a.start <= b.end AND b.start <= a.end
SELECT a.user_id,
       CASE WHEN EXISTS (
           SELECT 1 FROM subscriptions b
           WHERE b.user_id <> a.user_id
             AND b.end_date IS NOT NULL
             AND a.start_date <= b.end_date
             AND b.start_date <= a.end_date
       ) THEN 1 ELSE 0 END AS overlap
FROM subscriptions a
WHERE a.end_date IS NOT NULL;
```

### 2. Flight Routes (Pair Normalization)
```sql
SELECT DISTINCT
    LEAST(origin, destination)    AS loc1,
    GREATEST(origin, destination) AS loc2
FROM flights
ORDER BY loc1, loc2;
```

### 3. Paired Products (Self-Join)
```sql
SELECT p1.product_name AS p1, p2.product_name AS p2, COUNT(*) AS cnt
FROM transactions p1
JOIN transactions p2
    ON p1.user_id = p2.user_id
    AND p1.product_name < p2.product_name   -- enforces ordering, removes duplicates
GROUP BY p1.product_name, p2.product_name
ORDER BY cnt DESC
LIMIT 5;
```

### 4. First Touch Attribution
```sql
WITH first_touch AS (
    SELECT user_id, session_date, channel,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_date) AS rn
    FROM sessions
),
conversions AS (
    SELECT user_id,
           MAX(CASE WHEN converted = 1 THEN session_date END) AS converted_date
    FROM sessions
    GROUP BY user_id
    HAVING MAX(CASE WHEN converted = 1 THEN session_date END) IS NOT NULL
)
SELECT c.user_id, f.channel AS first_channel, c.converted_date
FROM conversions c
JOIN first_touch f ON c.user_id = f.user_id AND f.rn = 1
ORDER BY c.user_id;
```

### 5. Rolling Average
```sql
-- KEY: ROWS BETWEEN N PRECEDING AND CURRENT ROW (positional)
SELECT dt,
       AVG(amount) OVER (
           ORDER BY dt
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS rolling_3day
FROM transactions
ORDER BY dt;
```

### 6. Top 3 Salaries Per Department
```sql
WITH ranked AS (
    SELECT department, salary, COUNT(*) AS cnt,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
    GROUP BY department, salary
)
SELECT department, salary, cnt
FROM ranked
WHERE rnk <= 3
ORDER BY department, salary DESC;
```

---

## NULL Handling

```sql
WHERE col IS NULL          -- ✅ correct
WHERE col = NULL           -- ❌ always FALSE

COALESCE(col1, col2, 'default')   -- first non-null

COUNT(*)   -- counts rows including NULL
COUNT(col) -- counts non-NULL values only
```

---

## JOIN Patterns

```sql
-- Inner (only matches)
FROM a INNER JOIN b ON a.id = b.id

-- Left (all from left)
FROM a LEFT JOIN b ON a.id = b.id

-- Anti-join (in A not in B)
FROM a LEFT JOIN b ON a.id = b.id WHERE b.id IS NULL

-- Self-join without duplicates
FROM t a JOIN t b ON a.id < b.id
```

---

## Snowflake-Specific Syntax

```sql
LIMIT 5                              -- not FETCH FIRST
DATE_TRUNC('DAY', timestamp_col)     -- truncate date
DATEADD(DAY, 5, date_col)           -- add days
TO_CHAR(date_col, 'YYYY-MM-DD')     -- format date
col1 || col2                         -- string concat
OBJECT_AGG(key, value)              -- dynamic JSON pivot
```

---

# SECTION 4: SNOWFLAKE ARCHITECTURE (For Credibility)

## One Paragraph to Know Cold

> "Snowflake separates storage and compute entirely. Storage is columnar, compressed, and lives in S3 or similar object storage. Compute is virtual warehouses — MPP clusters that spin up and down independently. Data is organized in micro-partitions of 50-500MB, automatically clustered, with pruning metadata that tells the query engine which partitions to skip. This is how Snowflake achieves both unlimited concurrency and fast analytical queries without the resource contention I manage on YARN."

## Key Terms to Drop Naturally

- **Micro-partitions:** automatic, 50-500MB, prunable
- **Virtual warehouses:** isolated compute clusters, auto-suspend
- **Zero-copy cloning:** instant copy without duplicating data
- **Time Travel:** query historical data up to 90 days
- **Snowpipe:** continuous ingestion from S3
- **Streams:** CDC inside Snowflake
- **dbt:** transformation layer, `ref()`, `source()`, tests, materializations

---

# SECTION 5: BEHAVIORAL (Rounds 3-4, Not Today)

## Your 3 Core Stories

**Story 1: Config-driven framework (75% ops reduction)**
> "Our team had 800+ Informatica pipelines — high manual overhead. I built a config-driven PySpark framework: parameter files only, zero code changes per new dataset. Reduced ops overhead by 75%, enabled zero-engineering onboarding of new sources."

**Story 2: CDC-to-Kafka migration (streaming modernization)**
> "Led a hybrid CDC-to-Kafka migration off legacy Informatica PowerExchange. Decoupled producers from consumers, improved fault tolerance, enabled near-real-time propagation of Oracle and SQL Server change events."

**Story 3: Hadoop migration (zero-downtime)**
> "Led zero-downtime Hadoop v2.6 → v3.1 migration. Implemented Parquet columnar formatting and partition pruning. Measurable gains in query performance and storage efficiency."

---

# SECTION 6: RECRUITER SCREEN STAGING (Already Done)

**Why leaving:** Relocating to Bay Area, wife at Cisco
**Comp target:** $320-380K total
**Other processes:** "Late-stage with another Bay Area data platform team" (Snowflake = leverage)
**Start date:** 2 weeks from offer

---

# SECTION 7: MORNING OF INTERVIEW

## Timeline

| Time | Action |
|---|---|
| 8:00 AM | Read Section 1 (role context) |
| 8:15 AM | Read Section 2 (Python patterns) |
| 9:00 AM | Read Section 3 (SQL patterns) |
| 9:30 AM | Read Section 4 (architecture) |
| 10:00 AM | Break — walk, eat, decompress |
| 12:00 PM | Glance at this guide one more time |
| 1:50 PM | Open Zoom, test camera/audio |
| 1:58 PM | Join Zoom (2 min early) |
| 2:00 PM | **INTERVIEW STARTS** |

---

## Setup Checklist

- [ ] Zoom link tested and working
- [ ] Camera at eye level, good lighting
- [ ] Resume open in PDF reader
- [ ] This guide open in another tab
- [ ] Notepad nearby
- [ ] Water nearby
- [ ] All notifications off

---

# SECTION 8: DURING THE INTERVIEW

## For Every Problem — Say This First

```
1. RESTATE (10 sec):
   "So I need to [restate in your words], is that right?"

2. CLARIFY (10 sec):
   "Any constraints on time/space? Should I handle empty input?"

3. APPROACH (20 sec):
   "My approach is [pattern] because [reason].
   Time complexity would be O(...). Does that sound good?"

4. CODE:
   Talk while you type. Name variables clearly.

5. TEST (15 sec):
   "Let me trace through the example..."
```

## If You Blank

```
"Let me think through this out loud..."
"The brute force would be X — can I optimize from there?"
"I know the pattern I want — let me pseudocode first..."
```

## After Solving

```
"Time complexity is O(...), space is O(...)"
"One optimization would be..."
"Edge cases I handled: empty input, single element..."
```

---

# SECTION 9: RED FLAGS TO AVOID

❌ Don't say "SIG" — always say "**Susquehanna**"
❌ Don't say "I've never used Snowflake" without a bridge
❌ Don't use cryptic variable names (x, l, d)
❌ Don't skip edge cases
❌ Don't go silent for more than 30 seconds
❌ Don't say "I don't know" without attempting first

✅ Do say "Susquehanna"
✅ Do say "I haven't used Snowflake in production, but architecturally..."
✅ Do use clear names (num_to_index, left_pointer)
✅ Do test with examples
✅ Do think out loud

---

# SECTION 10: WHAT TO REMEMBER COLD

## Python (6 things)
1. `Counter.most_common(k)` for frequency + sorting
2. `heapq.nlargest(k, arr)` / `heapq.nsmallest(k, arr)`
3. Interval overlap: `a.start <= b.end AND b.start <= a.end`
4. Sliding window: expand right, contract left when invalid
5. Stack: `stack[-1]` to peek, `not stack` to check empty
6. BFS for shortest path, DFS for all paths

## SQL (6 things)
1. Window frame: `ROWS BETWEEN N PRECEDING AND CURRENT ROW`
2. LAST_VALUE gotcha: needs `UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`
3. Self-join without duplicates: `a.id < b.id`
4. Pair normalization: `LEAST()` / `GREATEST()`
5. First touch: `ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date) = 1`
6. GROUP BY: all non-aggregated columns must be included

---

# FINAL WORDS

**You've built 800+ production pipelines at petabyte scale.**
**You've led a streaming modernization, a cluster migration, and a framework rebuild.**
**You know these patterns. You've practiced them.**

The interviewers are Divya and Kavya — both Senior DEs. They want to hire someone good. They're rooting for you.

**Join 2 minutes early. Smile. Think out loud. Trust your prep.**

**Go crush it.**
