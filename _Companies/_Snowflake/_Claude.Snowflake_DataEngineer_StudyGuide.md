# Snowflake Senior Data Engineer — REQ19469 Interview Prep Guide

**Role:** Senior Data Engineer, Data Platform team, Menlo Park (3 days onsite)
**Candidate:** Krishna Upadhyaya — 9+ years at Susquehanna, PySpark / Hadoop / Kafka CDC / AWS

---

## 1. Role Framing — What This Job Actually Is

Read this section before anything else. The technical prep below is wasted if you walk in with the wrong mental model of the team.

This is **internal data engineering at Snowflake**, not Snowflake product engineering. You are not building Snowflake the product. You are eating Snowflake's own dogfood to build the data infrastructure that runs Snowflake the company. Concretely, the team:

- Owns the data infrastructure managing data and usage across Snowflake's own Snowflake account
- Builds custom ingestion pipelines from application APIs (Salesforce, Workday, Zendesk, internal tools)
- Partners with Engineering, Product, IT, Finance, and Compliance to inform decisions
- Supports executive reporting, board reporting, and industry publications

**Implication for your pitch:** your config-driven PySpark ingestion framework, 800+ pipeline ownership, and Kafka CDC migration are all directly relevant. Your edge is that you have been doing exactly this kind of work at petabyte scale at Susquehanna, just on Hadoop instead of Snowflake. Frame Hadoop / Hive / Spark experience as transferable warehousing-and-distributed-compute fluency, and lean into Python and SQL for the technical screens.

**Likely gap to address proactively:** you do not have production Snowflake or dbt experience. Do not pretend you do. Position it as: deep understanding of cloud data warehousing principles (MPP, columnar storage, partition pruning), strong SQL fluency, and a track record of picking up new platforms quickly (you have your AWS Data Engineer Associate cert, Databricks Accreditation). Read up on Snowflake architecture before the screen so you can speak to it conceptually.

---

## 2. Interview Process & What Each Round Tests

Per Interview Query and Snowflake's typical loop:

| Round | Format | What they test |
|---|---|---|
| 1. Recruiter screen | 30 min phone | Background, motivation, comp, location, AI-native culture fit signals |
| 2. Technical: Python | 45-60 min coding | Lists, strings, data manipulation, basic algorithms |
| 3. Technical: SQL | 45-60 min coding | Window functions, joins, aggregation patterns, performance |
| 4. Hiring manager / final | 45-60 min | System design, past projects, leadership, cultural fit |

Some loops add a data modeling round or a take-home. For senior level, expect at least one architecture / system design conversation embedded in the manager round.

---

## 3. Snowflake Architecture — Must-Know Concepts

You will be asked about these even if you have not used Snowflake in production. Know them cold.

### 3.1 The three-layer architecture

Snowflake separates compute, storage, and services. This is the single most important architectural fact about it.

- **Storage layer:** data sits in cloud object storage (S3, GCS, Azure Blob) as immutable, columnar, compressed micro-partitions. Snowflake manages the layout; you do not.
- **Compute layer:** virtual warehouses are independent MPP clusters that read from storage. You can spin up multiple warehouses against the same data with no contention, scale them up (T-shirt sizes XS through 6XL), or scale them out (multi-cluster warehouses for concurrency).
- **Cloud services layer:** metadata, query optimization, security, transactions. This is the brain.

The decoupling of compute and storage is why Snowflake can charge separately for each, why you can scale them independently, and why concurrent read workloads do not interfere with each other.

### 3.2 Micro-partitions

- Roughly 50-500 MB of uncompressed data per micro-partition, stored compressed and columnar
- Snowflake auto-clusters loosely by ingestion order, but you can define a **clustering key** to maintain ordering on hot columns
- Snowflake tracks min / max metadata per column per micro-partition. Queries that filter on those columns get **pruning** for free
- Pruning is the equivalent of partition pruning in Hive, but at finer granularity and without you having to declare partitions

### 3.3 Virtual warehouses

- Sized XS (1 server), S (2), M (4), L (8), XL (16), and so on, doubling each step
- **Scale up** for slow queries on big data, **scale out** (multi-cluster) for many concurrent queries
- Auto-suspend and auto-resume — billed per second after a 60-second minimum
- A query that does not fit in warehouse memory spills to local SSD then to remote storage. Same logic as Spark spill, just managed by Snowflake.

### 3.4 Time Travel and Zero-Copy Cloning

- **Time Travel:** query data as of a point in the past (default 1 day, up to 90 days on Enterprise). Backed by retained micro-partitions.
- **Zero-copy cloning:** `CREATE TABLE foo_dev CLONE foo_prod` creates a new table that shares micro-partitions with the source until either side is modified. Storage cost is zero at clone time. Game-changer for dev environments.

### 3.5 Snowpipe vs COPY

- **COPY INTO** is bulk batch loading from a stage (S3, internal). Run on demand, sized warehouse compute.
- **Snowpipe** is continuous micro-batch ingestion. Triggered by S3 events or REST API. Serverless compute (Snowflake-managed), billed per file processed.
- Use COPY for scheduled bulk loads, Snowpipe for streaming-ish ingestion of files arriving continuously.

### 3.6 Streams and Tasks (CDC inside Snowflake)

- **Stream:** records change data on a table (inserts, updates, deletes). Like a CDC log you can query.
- **Task:** scheduled SQL execution, can be chained into DAGs.
- Together, Streams + Tasks give you in-warehouse CDC pipelines without external orchestration. Useful talking point given your Kafka CDC background.

### 3.7 Snowflake vs your Hadoop world — the bridge

| Hadoop / Spark concept | Snowflake equivalent |
|---|---|
| HDFS blocks | Micro-partitions in object storage |
| YARN containers | Virtual warehouse compute nodes |
| Hive partitions | Clustering keys (looser, automatic) |
| Hive metastore | Cloud services layer (metadata) |
| Spark executor memory tuning | Warehouse T-shirt sizing |
| Shuffle spill | Spillage to local SSD / remote |
| Kafka CDC into HDFS | Snowpipe + Streams + Tasks |
| Airflow DAG | Tasks (for in-warehouse) or Airflow / Dagster external |

When asked "have you used Snowflake," the honest answer is "I have not run it in production at SIG, but architecturally it maps closely to the Hadoop and Spark systems I have built and operated. Decoupled compute and storage, columnar storage with metadata-driven pruning, MPP execution — these are the same primitives in different packaging." Then bridge to a specific story.

---

## 4. Python Round — Detailed Prep

The Python round at Snowflake DE is **not** LeetCode hard. It is data manipulation, lists, strings, dicts, and occasionally light algorithms. Below are the patterns you must be fluent in, plus worked solutions for the named problems from the Interview Query list.

### 4.1 Patterns to drill

1. **Two-pointer on sorted arrays** — pair sums, deduplication, merging
2. **Hash map for counting / lookup** — anagrams, frequency, missing element
3. **Sliding window** — substrings, max sum subarray of size k
4. **Sorting + linear scan** — interval problems, scheduling
5. **Set operations** — intersection, difference, dedup
6. **String manipulation** — split, join, reverse, regex basics
7. **Dict / list comprehensions** — Pythonic transformations
8. **Reading data into structures** — list of dicts, dict of lists, group by key

### 4.2 Worked solutions for named problems

#### Merge Sorted Lists (Easy)

Given two (or k) sorted lists, return a single sorted list.

**Two-list version, O(n + m):**
```python
def merge_two(a, b):
    i = j = 0
    out = []
    while i < len(a) and j < len(b):
        if a[i] <= b[j]:
            out.append(a[i]); i += 1
        else:
            out.append(b[j]); j += 1
    out.extend(a[i:])
    out.extend(b[j:])
    return out
```

**K-list version, O(N log k) using a heap:**
```python
import heapq
def merge_k(lists):
    return list(heapq.merge(*lists))  # if you can use the stdlib

# manual heap version if they want to see it:
def merge_k_manual(lists):
    h = []
    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(h, (lst[0], i, 0))
    out = []
    while h:
        val, list_idx, elem_idx = heapq.heappop(h)
        out.append(val)
        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(h, (next_val, list_idx, elem_idx + 1))
    return out
```

**Talking point:** mention that `heapq.merge` is the production answer; the manual version is for showing you understand the underlying algorithm.

#### Find the Missing Number (Easy)

Given an array of n distinct numbers from 0 to n, find the missing one.

**Three approaches, in increasing elegance:**
```python
# 1. Set difference: O(n) time, O(n) space
def missing_set(nums):
    return (set(range(len(nums) + 1)) - set(nums)).pop()

# 2. Sum formula: O(n) time, O(1) space
def missing_sum(nums):
    n = len(nums)
    return n * (n + 1) // 2 - sum(nums)

# 3. XOR: O(n) time, O(1) space, no overflow risk
def missing_xor(nums):
    result = len(nums)
    for i, v in enumerate(nums):
        result ^= i ^ v
    return result
```

The XOR version is the one to mention if asked "what if the numbers are huge?" The sum approach can overflow in fixed-width languages; in Python it does not but the interviewer may be looking for that awareness.

#### Prime to N (Medium)

Return all primes up to N. Sieve of Eratosthenes is the expected answer.

```python
def primes_up_to(n):
    if n < 2:
        return []
    sieve = [True] * (n + 1)
    sieve[0] = sieve[1] = False
    for i in range(2, int(n**0.5) + 1):
        if sieve[i]:
            for j in range(i*i, n + 1, i):
                sieve[j] = False
    return [i for i, is_p in enumerate(sieve) if is_p]
```

**Complexity:** O(n log log n) time, O(n) space. Mention the `i*i` start (smaller multiples already crossed off) and the `sqrt(n)` outer bound — both are signals you actually understand the algorithm.

#### String Shift (Easy)

Typical phrasing: given a string and a shift count, rotate the string left or right by k characters.

```python
def shift(s, k, direction='left'):
    if not s:
        return s
    k = k % len(s)
    if direction == 'left':
        return s[k:] + s[:k]
    else:
        return s[-k:] + s[:-k] if k else s
```

The `k % len(s)` is the gotcha — interviewers love to test whether you handle k larger than the string length.

#### Rectangle Overlap (Easy)

Given two rectangles as `(x1, y1, x2, y2)` (bottom-left and top-right), return whether they overlap.

```python
def overlap(r1, r2):
    # No overlap if one is entirely left, right, above, or below the other
    return not (r1[2] <= r2[0] or r2[2] <= r1[0] or
                r1[3] <= r2[1] or r2[3] <= r1[1])
```

The cleaner mental model is "negate the four cases of non-overlap." Whether `<` or `<=` depends on whether touching edges count — clarify with the interviewer.

#### Basic Regex (Medium)

Without seeing the exact problem, this is almost always either implementing `.` and `*` matching, or parsing a constrained pattern. The classic recursive solution for `.` and `*`:

```python
def is_match(s, p):
    if not p:
        return not s
    first_match = bool(s) and p[0] in {s[0], '.'}
    if len(p) >= 2 and p[1] == '*':
        # * matches zero of preceding, or one+ if first_match
        return is_match(s, p[2:]) or (first_match and is_match(s[1:], p))
    return first_match and is_match(s[1:], p[1:])
```

**If you want the DP version** for performance: O(m*n) memo over `(i, j)`. Mention you would memoize for production, recursion for clarity.

#### Shortest Path Algorithms (Medium)

This is open-ended — they probably want you to implement BFS for unweighted, Dijkstra for weighted non-negative.

```python
from collections import deque
def bfs_shortest(graph, start, end):
    """Unweighted shortest path."""
    q = deque([(start, [start])])
    seen = {start}
    while q:
        node, path = q.popleft()
        if node == end:
            return path
        for nb in graph[node]:
            if nb not in seen:
                seen.add(nb)
                q.append((nb, path + [nb]))
    return None

import heapq
def dijkstra(graph, start, end):
    """Weighted shortest path, non-negative weights. graph[u] = [(v, w), ...]"""
    heap = [(0, start, [start])]
    seen = set()
    while heap:
        cost, node, path = heapq.heappop(heap)
        if node == end:
            return cost, path
        if node in seen:
            continue
        seen.add(node)
        for nb, w in graph[node]:
            if nb not in seen:
                heapq.heappush(heap, (cost + w, nb, path + [nb]))
    return None, None
```

Know when to use which: BFS only works when all edges have equal weight. Dijkstra fails on negative weights (use Bellman-Ford). A* if you have a heuristic.

#### Minimum Days for Scheduling All Meetings (Medium)

**Problem:** Given a list of meetings as `[[start, end], ...]` with datetime strings, find the minimum number of days needed to schedule them all without conflicts. A meeting ending exactly when another starts is **not** a conflict.

**Example:**
```python
meetings = [
    ["2026-12-01 09:00", "2026-12-01 17:00"],
    ["2026-12-01 10:00", "2026-12-01 11:00"],
    ["2026-12-01 13:00", "2026-12-01 14:00"]
]
# All on the same calendar day, but the 9-17 meeting overlaps both others.
# Answer: 2 days
```

**Key insight:** this is the classic "minimum number of meeting rooms" problem with the rooms reframed as days. The answer is the **maximum number of simultaneously overlapping meetings** at any point in time.

**Solution: sweep line with two sorted arrays — O(n log n):**
```python
from datetime import datetime

def min_days(meetings: list[list[str]]) -> int:
    if not meetings:
        return 0

    fmt = "%Y-%m-%d %H:%M"
    starts = sorted(datetime.strptime(m[0], fmt) for m in meetings)
    ends   = sorted(datetime.strptime(m[1], fmt) for m in meetings)

    days = peak = 0
    s = e = 0
    n = len(meetings)

    while s < n:
        # If next start is strictly before next end, a new day is needed
        # (equality means meeting ends as another starts -> NOT a conflict)
        if starts[s] < ends[e]:
            days += 1
            peak = max(peak, days)
            s += 1
        else:
            days -= 1
            e += 1
    return peak
```

**Solution: heap of end times — O(n log n), more idiomatic:**
```python
import heapq
from datetime import datetime

def min_days(meetings: list[list[str]]) -> int:
    if not meetings:
        return 0

    fmt = "%Y-%m-%d %H:%M"
    parsed = [(datetime.strptime(s, fmt), datetime.strptime(e, fmt)) for s, e in meetings]
    parsed.sort()  # sort by start

    heap = []  # heap of end times for currently active meetings
    for start, end in parsed:
        # If earliest-ending active meeting is done by the time this one starts,
        # reuse that slot (pop it). Note: <= because end == start is NOT a conflict.
        if heap and heap[0] <= start:
            heapq.heappop(heap)
        heapq.heappush(heap, end)

    return len(heap)
```

**Trace through the example:**
- After sorting by start: [(09:00, 17:00), (10:00, 11:00), (13:00, 14:00)]
- Process (09:00, 17:00) → heap = [17:00], size 1
- Process (10:00, 11:00) → heap[0]=17:00 > 10:00, push → heap = [11:00, 17:00], size 2
- Process (13:00, 14:00) → heap[0]=11:00 ≤ 13:00, pop. Push → heap = [14:00, 17:00], size 2
- Answer: 2 ✓

**Talking points:**
- The `<` vs `<=` is the gotcha. The problem explicitly says end == start is not a conflict, so use `<` in the sweep version and `<=` in the heap pop check.
- Both approaches are O(n log n) due to sorting. The heap approach reads as cleaner code.
- Mention the related problem variants: max meetings in one room (greedy by end time), can-attend-all-meetings (just check if peak > 1).

#### Level Of Rain Water In 2D Terrain (Medium)

**Problem:** Despite the "2D" name, the problem is actually 1D — given a height array, compute total trapped water. The "2D" in the name refers to the 2D cross-section view, not a 2D grid.

**Required:** O(n) time, O(n) space.

**Example:**
```
heights = [3, 0, 2, 0, 4]
trapped = [0, 3, 1, 3, 0]
total   = 7
```

**Key insight:** for each position `i`, the water trapped above it is `min(max_left[i], max_right[i]) - heights[i]`, clamped to non-negative.

**Solution 1: Two arrays of prefix maxes — O(n) time, O(n) space (matches the spec):**
```python
def trap(heights: list[int]) -> int:
    n = len(heights)
    if n < 3:
        return 0

    left_max = [0] * n
    right_max = [0] * n

    left_max[0] = heights[0]
    for i in range(1, n):
        left_max[i] = max(left_max[i-1], heights[i])

    right_max[-1] = heights[-1]
    for i in range(n - 2, -1, -1):
        right_max[i] = max(right_max[i+1], heights[i])

    total = 0
    for i in range(n):
        water = min(left_max[i], right_max[i]) - heights[i]
        if water > 0:
            total += water
    return total
```

**Solution 2: Two-pointer — O(n) time, O(1) space (better, mention as the optimization):**
```python
def trap(heights: list[int]) -> int:
    if len(heights) < 3:
        return 0
    l, r = 0, len(heights) - 1
    lmax = rmax = total = 0
    while l < r:
        if heights[l] < heights[r]:
            if heights[l] >= lmax:
                lmax = heights[l]
            else:
                total += lmax - heights[l]
            l += 1
        else:
            if heights[r] >= rmax:
                rmax = heights[r]
            else:
                total += rmax - heights[r]
            r -= 1
    return total
```

**Trace through the example `[3, 0, 2, 0, 4]`:**
- left_max = [3, 3, 3, 3, 4]
- right_max = [4, 4, 4, 4, 4]
- min per index = [3, 3, 3, 3, 4]
- minus height = [0, 3, 1, 3, 0]
- sum = 7 ✓

**Talking points:**
- Walk through the intuition out loud: "water at position i is bounded by the tallest wall on each side. The shorter of the two walls is the limiting factor."
- Mention that the two-pointer version is the optimization most interviewers want to see — same time complexity, constant space.
- If asked about the true 2D grid version (water in a heightmap), pivot to the BFS-from-boundary-with-min-heap approach: water level at any cell is bounded by the lowest barrier on the path to the edge.

### 4.3 List vs tuple, dict vs set — the basics they always ask

| | List | Tuple |
|---|---|---|
| Mutable | Yes | No |
| Hashable | No | Yes (if elements are) |
| Memory | Higher (overallocates for growth) | Lower |
| Use case | Collections that change | Fixed records, dict keys |

| | Dict | Set |
|---|---|---|
| Stores | key→value | unique values |
| Lookup | O(1) avg | O(1) avg |
| Order | Insertion order (3.7+) | Insertion order (CPython detail, do not rely on it semantically) |

**Mutable default argument trap** — they may probe this:
```python
def append_to(item, lst=[]):  # WRONG: lst is shared across calls
    lst.append(item)
    return lst

def append_to(item, lst=None):  # RIGHT
    if lst is None:
        lst = []
    lst.append(item)
    return lst
```

**Shallow vs deep copy:** know that `copy.copy` copies the outer container only; `copy.deepcopy` recurses. You have already covered this in earlier prep.

### 4.4 Things to mention to score points

- Type hints: `def f(items: list[int]) -> dict[str, int]:`
- Generators for memory efficiency: `(x for x in big_list)` instead of `[x for x in big_list]`
- `collections.Counter`, `collections.defaultdict` — Pythonic and signals fluency
- `enumerate`, `zip`, `itertools.chain`, `itertools.groupby`

---

## 5. SQL Round — Detailed Prep

This is where you should be most confident. SQL is your daily bread. The Snowflake bar is high on window functions, CTEs, and clever aggregation.

### 5.1 Patterns to drill

1. **Window functions** — `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, running sums with `SUM() OVER`
2. **Top-N per group** — `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` then filter
3. **Gaps and islands** — sequence breaks, contiguous date ranges
4. **Histograms / bucketing** — `WIDTH_BUCKET`, `NTILE`, manual `CASE` bucketing
5. **Self-joins** — finding pairs, hierarchies, comparing rows to other rows
6. **Date math** — `DATEDIFF`, `DATE_TRUNC`, generating date series
7. **Sampling** — `TABLESAMPLE`, deterministic sampling with hash
8. **Anti-joins / not exists** — finding what is missing
9. **Pivoting** — `PIVOT`, `CASE WHEN` aggregation

### 5.2 Worked solutions for named problems

#### 2nd Highest Salary (Easy)

The classic. Three good approaches, knowing all three signals fluency.

```sql
-- Approach 1: subquery
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Approach 2: DENSE_RANK (handles ties correctly)
SELECT DISTINCT salary AS second_highest
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 2;

-- Approach 3: LIMIT / OFFSET (no ties handling)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

**The interviewer is checking** whether you handle ties. If two people share the highest salary, are they both "first" or is one "first" and one "second"? `DENSE_RANK` says both are first; `RANK` and `ROW_NUMBER` differ. Talk through this.

#### Top Three Salaries (Medium)

Top-N per group, but with a twist — typically "top 3 salaries per department."

```sql
SELECT department, name, salary
FROM (
    SELECT department, name, salary,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk <= 3;
```

Use `DENSE_RANK` if "top 3 distinct salaries"; `ROW_NUMBER` if "top 3 employees, breaking ties arbitrarily"; `RANK` if you want gaps after ties.

#### Empty Neighborhoods (Easy)

Find neighborhoods with no users (or any "X with no Y" pattern).

```sql
-- Anti-join via LEFT JOIN
SELECT n.name
FROM neighborhoods n
LEFT JOIN users u ON u.neighborhood_id = n.id
WHERE u.id IS NULL;

-- Or NOT EXISTS (often clearer, sometimes faster)
SELECT n.name
FROM neighborhoods n
WHERE NOT EXISTS (
    SELECT 1 FROM users u WHERE u.neighborhood_id = n.id
);
```

`NOT IN` works too, but **fails silently if the subquery returns NULL**. Mention this as a gotcha.

#### Average Quantity (Easy)

Whatever this is — `AVG()` with grouping. Watch for:
- NULL handling (`AVG` ignores NULLs by default)
- Whether they want average per group or overall
- Integer division gotchas in some dialects

```sql
SELECT product_id, AVG(quantity) AS avg_qty
FROM orders
GROUP BY product_id;
```

#### Manager Team Sizes (Easy)

Self-join on employees table, count direct reports.

```sql
SELECT m.id, m.name, COUNT(e.id) AS team_size
FROM employees m
LEFT JOIN employees e ON e.manager_id = m.id
WHERE m.is_manager = TRUE  -- or however managers are flagged
GROUP BY m.id, m.name
ORDER BY team_size DESC;
```

`LEFT JOIN` ensures managers with zero reports still show up.

#### Download Facts (Easy)

Likely a fact-table aggregation — count, group, filter. Standard `GROUP BY` with date filtering.

```sql
SELECT DATE_TRUNC('day', download_ts) AS day,
       COUNT(*) AS downloads,
       COUNT(DISTINCT user_id) AS unique_users
FROM downloads
WHERE download_ts >= CURRENT_DATE - 30
GROUP BY 1
ORDER BY 1;
```

#### Last Transaction (Medium)

Find the most recent transaction per user. Two approaches:

```sql
-- Window function (preferred, single scan)
SELECT user_id, transaction_id, amount, transaction_ts
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_ts DESC) AS rn
    FROM transactions
) t
WHERE rn = 1;

-- Correlated subquery (slower, but classic)
SELECT t.*
FROM transactions t
WHERE t.transaction_ts = (
    SELECT MAX(transaction_ts)
    FROM transactions WHERE user_id = t.user_id
);
```

The window approach scans once; the correlated subquery scans per row. Mention this.

#### Comments Histogram (Medium)

Histogram of users by comment count.

```sql
WITH user_counts AS (
    SELECT user_id, COUNT(*) AS comment_count
    FROM comments
    GROUP BY user_id
)
SELECT comment_count, COUNT(*) AS num_users
FROM user_counts
GROUP BY comment_count
ORDER BY comment_count;
```

For bucketed histograms (0-10, 11-50, 51+):
```sql
SELECT
    CASE
        WHEN comment_count <= 10 THEN '0-10'
        WHEN comment_count <= 50 THEN '11-50'
        ELSE '51+'
    END AS bucket,
    COUNT(*) AS num_users
FROM user_counts
GROUP BY 1
ORDER BY MIN(comment_count);
```

The `ORDER BY MIN(comment_count)` trick keeps buckets in numeric order rather than alphabetical.

#### Random SQL Sample (Medium)

Take a random N% sample. Snowflake-specific:

```sql
-- Snowflake TABLESAMPLE
SELECT * FROM events SAMPLE (1);  -- 1% sample

-- Or deterministic sampling by hash
SELECT * FROM events
WHERE ABS(HASH(event_id)) % 100 < 5;  -- ~5%, reproducible
```

Mention the difference: `TABLESAMPLE` is non-deterministic per query; hash-based is reproducible across runs, which matters for debugging.

#### Sample Time Series (Medium)

Likely "downsample a high-frequency time series to one row per N-minute bucket."

```sql
SELECT
    DATE_TRUNC('minute', event_ts) AS minute_bucket,
    AVG(value) AS avg_value,
    COUNT(*) AS sample_count
FROM events
WHERE event_ts BETWEEN :start AND :end
GROUP BY 1
ORDER BY 1;
```

For 5-minute buckets in Snowflake:
```sql
TIME_SLICE(event_ts, 5, 'MINUTE', 'START')
```

#### Average Unique Counts (Medium)

Probably "for each X, count distinct Y, then average across Xs." Two-step aggregation.

```sql
WITH per_x AS (
    SELECT x, COUNT(DISTINCT y) AS uniq
    FROM table
    GROUP BY x
)
SELECT AVG(uniq) AS avg_unique_per_x
FROM per_x;
```

#### Upsell Transactions (Medium)

Almost certainly "find transactions where the user later spent more" or "find users whose Nth transaction was larger than their (N-1)th." Self-join with `LAG`:

```sql
WITH ordered AS (
    SELECT user_id, transaction_id, amount,
           LAG(amount) OVER (PARTITION BY user_id ORDER BY transaction_ts) AS prev_amount
    FROM transactions
)
SELECT *
FROM ordered
WHERE amount > prev_amount;  -- upsell
```

#### Subscription Overlap (Hard)

**Problem:** For each user with a completed subscription (end_date is not null), return whether their subscription range overlaps with any **other** completed subscription. Output: `user_id, overlap` where overlap is 1 or 0.

**Sample data and expected output:**
```
user_id  start_date    end_date
1        2019-01-01    2019-01-31
2        2019-01-15    2019-01-17
3        2019-01-29    2019-02-04
4        2019-02-05    2019-02-10

→ users 1, 2, 3 overlap (1↔2, 1↔3); user 4 does not.
```

**Key insight:** the canonical interval overlap test is `a.start <= b.end AND b.start <= a.end`. Self-join the table to itself, exclude self-pairs, and flag overlaps.

**Solution (CASE + EXISTS, clean and readable):**
```sql
SELECT
    a.user_id,
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

**Alternative (LEFT JOIN + aggregation, single pass):**
```sql
SELECT
    a.user_id,
    MAX(CASE WHEN b.user_id IS NOT NULL THEN 1 ELSE 0 END) AS overlap
FROM subscriptions a
LEFT JOIN subscriptions b
  ON b.user_id <> a.user_id
  AND b.end_date IS NOT NULL
  AND a.start_date <= b.end_date
  AND b.start_date <= a.end_date
WHERE a.end_date IS NOT NULL
GROUP BY a.user_id
ORDER BY a.user_id;
```

**Talking points:**
- Mention the interval overlap formula explicitly. Interviewers love hearing it stated.
- Note that this is O(n²) in the worst case — for a real production version on hundreds of millions of rows, you would sort by start_date and use a sweep-line approach or window function with `LAG(end_date)`.
- Edge case: should a subscription that starts on the same day another ends count as overlapping? Clarify with the interviewer. The `<=` here says yes; switch to `<` for strict.

#### Flight Records → Flight Routes (Hard)

**Problem:** Create a table of unique location pairs from a flights table. Treat (Dallas → Seattle) and (Seattle → Dallas) as the same route — only one row in the output. Also dedupe exact duplicates.

**Sample input → output:**
```
flights:                                  flight_routes:
1  Seattle, WA       Dallas, TX           Dallas, TX        Seattle, WA
2  Dallas, TX        Seattle, WA          Portland, OR      San Francisco, CA
3  Seattle, WA       San Francisco, CA    San Francisco, CA Seattle, WA
4  San Francisco, CA Dallas, TX           Dallas, TX        San Francisco, CA
5  San Francisco, CA Portland, OR         Los Angeles, CA   San Francisco, CA
6  Seattle, WA       Dallas, TX  (dup)
7  Portland, OR      San Francisco, CA
8  San Francisco, CA Los Angeles, CA
```

**Key insight:** normalize each pair so the two locations are always in the same order, then take DISTINCT. Use `LEAST` and `GREATEST` to do this in a single expression.

**Solution:**
```sql
SELECT DISTINCT
    LEAST(source_location, destination_location)    AS destination_one,
    GREATEST(source_location, destination_location) AS destination_two
FROM flights;
```

If the platform wants you to actually create the table:
```sql
CREATE TABLE flight_routes AS
SELECT DISTINCT
    LEAST(source_location, destination_location)    AS destination_one,
    GREATEST(source_location, destination_location) AS destination_two
FROM flights;
```

**Talking points:**
- The `LEAST` / `GREATEST` trick is the elegant pattern for any "treat (A,B) and (B,A) as the same pair" problem. Mention this explicitly.
- Alternative without `LEAST` / `GREATEST` is a self-join with `source < destination`, but it is uglier and does not handle the deduping as cleanly.
- Edge case: a flight from Seattle to Seattle. Filter it out with `WHERE source_location <> destination_location` if needed.

#### Paired Products (Hard)

**Problem:** Find the top 5 product pairs that the same user purchases together (across all their transactions). Return product names. **Constraint:** `p2` should be the item that comes first alphabetically.

**Schema:**
```
transactions(id, user_id, created_at, product_id, quantity)
products(id, name, price)
```

**Output columns:** `p1, p2, qty` — where `p2` is alphabetically first, and `qty` is the count of how many times the pair appears.

**Key insights:**
1. "Bought together by the same user" — pair on `user_id`, not on `order_id` or timestamp. This is broader than per-transaction pairing.
2. Avoid self-pairs and double-counting (A,B) vs (B,A) — use `t1.product_id < t2.product_id` as the join condition, then swap order at output time per the constraint.
3. The constraint `p2 = alphabetically first` is unusual — most problems put the alphabetically first item in `p1`. Read carefully and follow what they ask.

**Solution:**
```sql
WITH pairs AS (
    SELECT
        t1.user_id,
        t1.product_id AS prod_a,
        t2.product_id AS prod_b
    FROM transactions t1
    JOIN transactions t2
      ON t1.user_id = t2.user_id
     AND t1.product_id < t2.product_id
)
SELECT
    pa.name AS p1,           -- alphabetically later
    pb.name AS p2,           -- alphabetically first (per problem spec)
    COUNT(*) AS qty
FROM pairs
JOIN products pa ON pa.id = pairs.prod_a
JOIN products pb ON pb.id = pairs.prod_b
GROUP BY pa.name, pb.name
-- after joining, reorder so p2 is alphabetically first
;
```

**Cleaner with name normalization in the CTE:**
```sql
WITH pair_names AS (
    SELECT
        GREATEST(p1.name, p2.name) AS p1,   -- alphabetically later
        LEAST(p1.name, p2.name)    AS p2    -- alphabetically first
    FROM transactions t1
    JOIN transactions t2
      ON t1.user_id = t2.user_id
     AND t1.product_id < t2.product_id
    JOIN products p1 ON p1.id = t1.product_id
    JOIN products p2 ON p2.id = t2.product_id
)
SELECT p1, p2, COUNT(*) AS qty
FROM pair_names
GROUP BY p1, p2
ORDER BY qty DESC
LIMIT 5;
```

**Talking points:**
- Discuss the de-duplication trick: `t1.product_id < t2.product_id` ensures each pair is counted once, not twice, and excludes self-pairs (A,A).
- Mention that on real data with millions of transactions per user, you would pre-aggregate to "distinct (user, product)" pairs first to avoid quadratic blowup if a single user bought a product many times.
- Edge case clarification: should buying the same product twice with two other products inflate the pair count? Probably yes (the qty column suggests volume matters), but worth confirming.

#### First Touch Attribution (Hard)

**Problem:** For each user who converted, return the channel from their **first session ever**. The conversion can have happened on any later session.

**Schema:**
```
attribution(session_id, channel, conversion)        -- conversion is BOOLEAN
user_sessions(session_id, created_at, user_id)      -- maps sessions to users
```

**Output:** `user_id, channel`

**Key insights:**
1. "First touch" = the channel of the user's **earliest session by created_at**, not the channel of the converting session.
2. You only output rows for users who **eventually converted on some session**. Filter to those users first.
3. Two-step problem: (a) identify converted users, (b) find their earliest session and its channel.

**Solution (window function approach, single pass):**
```sql
WITH converted_users AS (
    SELECT DISTINCT us.user_id
    FROM user_sessions us
    JOIN attribution a ON us.session_id = a.session_id
    WHERE a.conversion = TRUE
),
ranked_sessions AS (
    SELECT
        us.user_id,
        a.channel,
        ROW_NUMBER() OVER (PARTITION BY us.user_id ORDER BY us.created_at) AS rn
    FROM user_sessions us
    JOIN attribution a ON us.session_id = a.session_id
    WHERE us.user_id IN (SELECT user_id FROM converted_users)
)
SELECT user_id, channel
FROM ranked_sessions
WHERE rn = 1
ORDER BY user_id;
```

**Alternate (with QUALIFY, Snowflake-specific):**
```sql
SELECT us.user_id, a.channel
FROM user_sessions us
JOIN attribution a ON us.session_id = a.session_id
WHERE us.user_id IN (
    SELECT us2.user_id
    FROM user_sessions us2
    JOIN attribution a2 ON us2.session_id = a2.session_id
    WHERE a2.conversion = TRUE
)
QUALIFY ROW_NUMBER() OVER (PARTITION BY us.user_id ORDER BY us.created_at) = 1
ORDER BY us.user_id;
```

**Talking points:**
- `QUALIFY` is Snowflake-specific syntax that filters on window function results without a subquery wrapper. Mention it — signals you understand the dialect even if you have not used it daily.
- Last-touch attribution is the trivial variant: `ORDER BY us.created_at DESC`.
- For multi-touch attribution (linear, time-decay, U-shape), you would weight rows differently — common follow-up question.
- Performance note: if `user_sessions` is huge, the `IN` subquery becomes a semi-join — Snowflake handles this fine, but on Postgres you might prefer `EXISTS`.

#### Rolling Bank Transactions (Hard)

**Problem:** Compute the 3-day rolling average of **deposits** (positive transaction values) by day. Output: `dt` formatted as `'%Y-%m-%d'` and `rolling_three_day` as float.

**Schema:**
```
bank_transactions(user_id, created_at, transaction_value)
-- positive value = deposit, negative = withdrawal
```

**Output:** `dt VARCHAR, rolling_three_day FLOAT`

**Key insights:**
1. "Deposits" = `transaction_value > 0`. Filter these.
2. Aggregate to daily totals first, then take the rolling average over those daily totals.
3. "3-day rolling" typically means today plus the two previous days (a 3-row window). Confirm if they mean trailing 3 days vs centered.
4. Watch the date format — Snowflake uses `TO_CHAR(dt, 'YYYY-MM-DD')` (their format token is uppercase).

**Solution (Snowflake syntax):**
```sql
WITH daily_deposits AS (
    SELECT
        DATE(created_at) AS dt,
        SUM(transaction_value) AS daily_total
    FROM bank_transactions
    WHERE transaction_value > 0
    GROUP BY DATE(created_at)
)
SELECT
    TO_CHAR(dt, 'YYYY-MM-DD') AS dt,
    AVG(daily_total) OVER (
        ORDER BY dt
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_three_day
FROM daily_deposits
ORDER BY dt;
```

**Important nuances:**
- `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` gives a 3-row window (today + 2 prior days that have data). If a day has no deposits, it does not appear in the daily aggregation, which means the "3-day window" is actually 3 *days with deposits* not 3 calendar days.
- For a true calendar-based rolling window that includes empty days as zero, generate a date spine and left-join:

```sql
WITH date_spine AS (
    SELECT DATEADD(day, seq4(), '2019-01-01'::DATE) AS dt
    FROM TABLE(GENERATOR(ROWCOUNT => 365))
),
daily_deposits AS (
    SELECT DATE(created_at) AS dt, SUM(transaction_value) AS daily_total
    FROM bank_transactions
    WHERE transaction_value > 0
    GROUP BY DATE(created_at)
),
filled AS (
    SELECT s.dt, COALESCE(d.daily_total, 0) AS daily_total
    FROM date_spine s
    LEFT JOIN daily_deposits d ON s.dt = d.dt
    WHERE s.dt <= (SELECT MAX(dt) FROM daily_deposits)
)
SELECT
    TO_CHAR(dt, 'YYYY-MM-DD') AS dt,
    AVG(daily_total) OVER (ORDER BY dt ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_three_day
FROM filled
ORDER BY dt;
```

**Talking points:**
- Mention the `ROWS` vs `RANGE` distinction: `ROWS BETWEEN 2 PRECEDING` counts physical rows; `RANGE BETWEEN INTERVAL '2 days' PRECEDING` counts logical date offset (and would correctly handle missing days).
- The first two days will have a partial window (1 day, then 2 days). Some interpretations expect NULL for those rows. Clarify.
- For trailing 3 days *including* today's value: `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`. For 3 days *not* including today: `ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING`.

#### Order Assignment and Delivery Time → DoorDash Dasher Selection (Medium, case study)

**Problem (paraphrased):** DoorDash is launching in NYC and Charlotte. How would you decide which dashers (delivery drivers) get which deliveries? Are the criteria the same in both cities?

**This is a product / case-study question, not a SQL or coding problem.** Snowflake may use this style in the manager round to test how you think about real-world business problems with data. Below is a structured framework for answering.

**Step 1: Clarify what we are optimizing**

Before you propose anything, ask: *what is the business objective?* Common candidates:
- Minimize delivery time
- Maximize dasher earnings / utilization
- Maximize customer satisfaction (on-time rate, food temperature)
- Minimize cost to DoorDash (fewer subsidies)
- Balance fairness across dashers (equitable order distribution)

These conflict. Pick a primary metric and acknowledge the trade-offs. A good answer leads with: "I would optimize for on-time delivery rate as the primary metric, with dasher earnings per hour as a secondary constraint we must not regress."

**Step 2: Features for selection**

For each candidate dasher at the moment an order arrives:
- **Distance to restaurant** (most important)
- **Estimated time to restaurant** (driving conditions, current location's traffic)
- **Vehicle type** (bike vs car vs scooter — matters more in NYC than Charlotte)
- **Current dasher state** (available, finishing another delivery, en route)
- **Historical performance** (on-time rate, customer rating, cancellation rate)
- **Capacity** (some dashers batch multiple orders)
- **Order characteristics** (size, fragility, dietary, alcohol → ID check)

**Step 3: NYC vs Charlotte — yes, criteria differ**

| Factor | NYC | Charlotte |
|---|---|---|
| Primary mode | Bike, scooter, walking | Car (almost exclusively) |
| Distance metric | Walking / cycling time, not driving | Driving time |
| Traffic / parking | Severe parking penalty, traffic unpredictable | Lower traffic, parking trivial |
| Density | High restaurant + customer density → batching opportunities | Sparser, longer routes |
| Dasher pool | Larger, more competitive, higher turnover | Smaller, more stable |
| Customer expectations | Fast delivery (<30 min) standard | Slightly more tolerant |
| Cold-start risk for launch | Lower (DoorDash competes) | Higher (may be category-defining) |

**Step 4: Algorithm sketch**

```
For each incoming order:
    candidates = dashers within radius_R (R varies by city density)
    score each candidate by:
        score = w1 * (1 / time_to_restaurant)
              + w2 * historical_on_time_rate
              + w3 * vehicle_match_for_order
              - w4 * dasher_recent_workload (fairness)
    assign to top-scored, with batching consideration if multiple orders nearby
```

Weights `w1..w4` should be **learned per city** from historical data, not hardcoded. This is where a feature platform built on Snowflake fits in.

**Step 5: Cold-start problem**

For launch in a new market, you have no historical performance data. Mitigations:
- Bootstrap with simple distance-based assignment for the first 2-4 weeks
- Run an A/B test once data accumulates
- Use rider-supplied data (vehicle, license type, hours available)
- Explicitly flag cold-start and lower the weight on historical features until you have N deliveries per dasher

**How to deliver this answer:**
- Spend 30 seconds on Step 1 (objective) — this signals senior judgment
- 90 seconds on features and city differences
- 60 seconds on the algorithm sketch
- 30 seconds on cold-start
- Stop and check in: "happy to go deeper on any of these — modeling, fairness, or the data infra to support it"

**Why this question matters for a Snowflake DE role:** they want senior engineers who can talk to PMs and exec stakeholders, not just write SQL. Show that you can break down an ambiguous business question.

### 5.3 SQL performance talking points

When asked "how would you optimize this query":

1. **Look at the plan first** — `EXPLAIN` in Snowflake, see micro-partitions scanned vs total
2. **Pruning** — make sure your WHERE is on a clustered or auto-clustered column
3. **Spillage** — if your warehouse is spilling to remote storage, scale up or rewrite to avoid massive sorts/joins
4. **Join order and broadcast vs hash** — Snowflake decides, but check the plan
5. **Materialized views or pre-aggregations** for repeated heavy queries
6. **Result caching** — Snowflake caches identical query results for 24h
7. **Clustering keys** for tables that grow huge and are filtered on the same column constantly
8. **Avoid SELECT *** in production
9. **Window functions over self-joins** when possible (single scan vs multiple)

---

## 6. System Design / Architecture Round

For a senior role, expect a 30-45 min open-ended design conversation. Likely prompts:

### 6.1 Likely prompts

- "Design a data pipeline to ingest API data from Salesforce into Snowflake, hourly, with idempotency and replay."
- "How would you design usage telemetry for the Snowflake product itself, capturing query, warehouse, and user-level events at the scale of millions of events per second?"
- "Walk us through how you would migrate a legacy Informatica + Oracle ETL into a modern stack."
- "How would you design a data quality framework that runs across hundreds of pipelines?"

### 6.2 Framework for answering

1. **Clarify scope and SLAs** — volume, latency, freshness, accuracy, cost. Do not start designing until you have this.
2. **Sketch the high-level flow** — sources, ingestion, storage, transformation, serving. Whiteboard it.
3. **Drill into one or two components** — pick the most interesting trade-off and go deep.
4. **Discuss failure modes** — what happens if the source goes down, the warehouse fills, a transformation fails midway?
5. **Discuss observability and ops** — how do you know it is working, who gets paged, how do you replay.
6. **Mention cost** — Snowflake interviewers care about credits.

### 6.3 Stories you should have ready

Map these to your existing memory of SIG work. Each should be 2-3 minutes when told end to end.

| Story | Key metrics | Use for |
|---|---|---|
| Config-driven PySpark ingestion framework | 75% ops overhead reduction, 50% runtime reduction | "Tell me about a system you built" |
| Hadoop v2.6 → v3.1 migration with zero downtime | 800+ pipelines, no data loss | "Tell me about a complex migration" |
| Hybrid CDC-to-Kafka streaming from legacy Informatica | Real-time vs nightly batch | "Tell me about a streaming system" |
| Semi-automated ingestion framework | 70% faster incident resolution | "Tell me about reliability or observability" |
| 800+ production pipeline ownership | Operational scale | "How do you handle on-call / scale" |

For each, have ready: **the problem, the constraints, the design choices and trade-offs, the result.** Avoid vague impact claims; lead with the metric.

### 6.4 Snowflake-specific design considerations

If they ask you to design something on Snowflake specifically:

- **Ingestion:** Snowpipe for files arriving continuously, COPY INTO for batch, Streams for CDC into downstream tables
- **Transformation:** dbt is the de facto standard; mention you have not used it but understand the model (SQL with Jinja, lineage via `ref()`, tests, docs)
- **Orchestration:** Airflow / Dagster / Snowflake Tasks. Use Tasks for in-warehouse simple chains, external orchestrator for cross-system DAGs.
- **Cost control:** auto-suspend warehouses, right-size by workload, use resource monitors, query tag everything
- **Data quality:** dbt tests, Great Expectations, or custom assertions in Tasks
- **Governance:** RBAC at warehouse / database / schema / table / column level, dynamic data masking for PII, row access policies for tenant isolation

---

## 7. Behavioral Round

The Snowflake JD wording — "AI-native thinkers," "low-ego," "experimental mindset," "treating AI as a high-trust collaborator" — is doing a lot of work. They want people who are using AI tools in their daily work and treating it as an accelerator, not threat.

### 7.1 Likely behavioral prompts

- "Tell me about a time you disagreed with a stakeholder."
- "Tell me about a project that failed."
- "How do you stay current with new technologies?"
- "Tell me about a time you had to make a decision with incomplete data."
- "How are you using AI in your work?" ← *expect this, it is in the JD*
- "Tell me about a time you mentored someone."

### 7.2 The "AI-native" answer

Have a real, specific answer. Examples you can draw from:
- Using Claude or ChatGPT for code review and pair-programming on your PySpark framework
- Using AI for debugging Spark execution plans or optimizing SQL queries
- Generating test data, scaffolding boilerplate
- Drafting design docs and reviewing your own architecture decisions

Be specific about which tool, what task, and what the impact was. Avoid sounding like you only use it for fluff.

### 7.3 STAR scenarios you already have

From memory: you have a behavioral scenario bank mapped to your SIG metrics. Use those. Key ones to refresh:

- **Conflict / pushback:** the disagreement story (pick one — the orchestration tool selection or the migration approach)
- **Failure:** be honest about a real failure with a clear lesson learned
- **Leadership:** runbook authorship, PySpark adoption lifecycle docs, mentoring
- **Ambiguity:** the CDC-to-Kafka migration where the legacy Informatica was barely documented

### 7.4 Client Solution Pushback (Behavioral, Medium)

**Prompt:** "We proposed a new analytics dashboard to a client, but after reviewing our design and data sources, the client says the solution doesn't meet their needs and pushes back on several key features. How would you approach the conversation, and how do you handle the disagreement constructively to still reach a successful outcome?"

**This is a stakeholder-management question.** Snowflake's Data Platform team partners with Engineering, PM, IT, Finance, and Compliance — every project will involve someone pushing back. They want to see emotional intelligence, structured thinking, and a bias toward outcomes over ego.

**Framework for the answer:**

**1. Listen first, defend second.** The instinct is to explain why your design is right. The senior move is to assume the client has a reason you have not yet understood. Ask:
- "Help me understand which features are not meeting your needs — can we walk through them?"
- "What is the workflow you are imagining? What does success look like for you?"
- "Is the gap a missing feature, the wrong feature, or how the feature is presented?"

**2. Separate problem from solution.** Often the client describes pushback in solution terms ("we need X feature") when the underlying need is different. Translate back: "It sounds like you need to do Y. Is X the only way to get there, or is there flexibility?"

**3. Distinguish the three categories of pushback:**
- **Misunderstanding** — they thought your design did something it does. Fix with a demo or clarification, not redesign.
- **Genuine gap** — your design missed a real requirement. Acknowledge it directly, no defensiveness. Propose how to address it.
- **Scope expansion** — they want something you did not agree to deliver. Be honest about trade-offs (timeline, cost, complexity) and let them decide.

**4. Bring data, not opinions, to the trade-off conversation.** "If we add this feature, here is the impact on timeline / data freshness / cost. Here is what we would deprioritize. Which trade-off works for you?"

**5. Document and circulate decisions.** After the meeting, send a written summary of what was agreed, what was punted, and what remains open. This prevents the same conversation from happening again.

**STAR-style story you can tell:**
You can adapt your existing pushback scenarios from prior prep — the orchestration tool selection (Airflow vs Dagster) or the migration approach (CDC-to-Kafka) both have elements of stakeholder disagreement. Frame it like:

- **Situation:** "At Susquehanna, I proposed migrating from Informatica CDC to Kafka-based streaming. The platform team pushed back hard — they were concerned about operational risk on a system handling [X volume] of trading data."
- **Task:** "I needed to either change their mind or change my plan."
- **Action:** "I scheduled a working session, listened to their specific concerns (which turned out to be about replay capability and audit logs), and rescoped the migration into three phases with explicit rollback criteria for each. I also added the audit-log capability they wanted, which had not been in my original design."
- **Result:** "We delivered phase one with zero incidents, and the platform team became advocates for the rest of the migration. The audit log they pushed for ended up catching a downstream data quality issue we would have missed."

**What to avoid:**
- "I just explained why I was right and they came around." → Sounds rigid.
- "I gave in to their concerns." → Sounds passive.
- Vague answers without a real story → Sounds like you have not done this.

### 7.5 Experiment Validity (A/B Testing, Medium)

**Prompt:** "An A/B test on a landing page shows a p-value of 0.04. How would you assess the validity of the result?"

**This is a data-science / statistics question, but framed for an engineer.** A 0.04 p-value crosses the conventional 0.05 threshold, but a senior engineer should not just say "ship it." The right answer probes whether the test was set up correctly.

**Framework: validity threats to investigate before trusting the result:**

**1. Statistical validity — was the test designed correctly?**
- **Sample size and power.** Was the test sized for the minimum detectable effect (MDE) the team cared about? An underpowered test that happens to hit p=0.04 is suspicious.
- **Peeking / early stopping.** Did someone look at the results during the test and decide to stop when it crossed 0.05? This inflates false positive rates dramatically. The decision to stop must have been pre-registered.
- **Multiple comparisons.** If they tested 20 variants or 20 metrics, one will hit p<0.05 by chance (~64% chance of at least one false positive). Apply Bonferroni correction or false discovery rate.
- **One-sided vs two-sided test.** Was the alternative hypothesis pre-specified?

**2. Practical significance — is the effect size meaningful?**
- A statistically significant result with a 0.1% lift on conversion is probably not worth the complexity of shipping the change.
- p=0.04 is *barely* significant. Look at the confidence interval — if it ranges from "+0.01% to +5%", the test does not actually tell you the effect is large.

**3. Internal validity — was the experiment executed cleanly?**
- **Sample ratio mismatch (SRM).** If you assigned 50/50 but observed 48/52, something is broken in randomization. Run a chi-square test on the assignment counts.
- **Crossovers / contamination.** Were users exposed to both variants (caching, multi-device sessions, cookie issues)?
- **Novelty effect.** Did the metric improve only in week 1 because the change was new and attention-grabbing? Look at daily trends.
- **Seasonality.** Did the test span a holiday or unusual period?

**4. External validity — does it generalize?**
- Was the test run on a representative population, or just one geography / segment?
- New users vs returning users — effects often differ.
- Will the effect hold long-term, or is it short-term lift that decays?

**5. Metric validity — is the right thing being measured?**
- Is "conversion" defined the same way in both arms?
- Is there a downstream effect (more conversions but worse retention, more click-throughs but lower order value)?
- Guardrail metrics — did anything important get worse?

**How to deliver this answer:**
"A 0.04 p-value crosses the threshold but I would not ship on that alone. I would walk through four checks before trusting it: was the test pre-registered with a target sample size, did anyone peek, are there multiple comparisons going on, and how does it compare to guardrail metrics. Then I would look at the confidence interval to see if the effect size is practically meaningful, and check for SRM and novelty effects. Only if all of those pass would I recommend shipping."

**Talking points to drop:**
- "Pre-registration of hypothesis and sample size"
- "Sample ratio mismatch"
- "Guardrail metrics"
- "Bonferroni correction" or "false discovery rate"
- "Practical vs statistical significance"

These are the vocabulary of someone who has actually shipped experiments, not just read about them.

---

## 8. Recruiter Screen — What to Pre-Stage

The recruiter screen is filtering for fit and flag-no-go signals. Have crisp answers ready for:

- **Why Snowflake?** Frame around: data platform at scale, AI-native culture matches how you already work, internal data eng (not consulting / contracting) is what you want, Bay Area relocation is locked in. Avoid "I want to learn Snowflake" — sounds junior.
- **Why now?** Wife at Cisco in Bay Area, you are relocating, this is the kind of role you have been targeting.
- **Comp expectations:** know the band. Senior DE base in the Bay is roughly $180K-$240K depending on level; Snowflake total comp with RSUs typically lands $300K-$400K+ at senior. Have a number ready or say "I am calibrating against the market and would love to hear what the band is for this level."
- **Notice period:** standard two weeks.
- **Visa / work auth:** state it directly so it is not a surprise later.
- **Onsite 3 days a week in Menlo Park:** confirm you are okay with this.

---

## 9. Cheat Sheet — What to Look at on the Train to the Interview

### Snowflake architecture in one paragraph
Decoupled compute, storage, and services. Storage is columnar micro-partitions in cloud object storage. Compute is virtual warehouses (MPP clusters), independently scalable, pay per second. Services layer handles metadata and optimization. Pruning via min/max metadata per micro-partition. Clustering keys for hot columns. Time Travel via retained micro-partitions. Zero-copy clones via shared micro-partitions.

### SQL patterns to know cold
- `ROW_NUMBER / RANK / DENSE_RANK` — top-N per group, ranking with ties
- `LAG / LEAD` — previous / next row comparisons
- `SUM() OVER (... ROWS BETWEEN ...)` — running totals, rolling windows
- `LEFT JOIN ... WHERE NULL` and `NOT EXISTS` — anti-joins
- Interval overlap: `a.start <= b.end AND b.start <= a.end`
- Date bucketing: `DATE_TRUNC('day', ts)`, `TIME_SLICE(ts, 5, 'MINUTE')`
- Histograms via `CASE WHEN` bucket + `GROUP BY`
- Self-join for pairs: `a.id < b.id` to avoid duplicates

### Python patterns to know cold
- Hash map for counting / lookup
- Two pointer on sorted data
- `heapq` for top-K and merging k sorted lists
- BFS with `deque`, Dijkstra with heap
- `Counter`, `defaultdict`, `groupby`, `enumerate`, `zip`
- Mutable default argument trap, shallow vs deep copy

### System design checklist
1. SLAs first (volume, latency, freshness, cost)
2. High-level flow on the board
3. One component deep dive with trade-offs
4. Failure modes
5. Observability and replay
6. Cost

### Talking-point anchors (your stories)
- 75% / 50% reductions on the config-driven framework
- 800+ pipelines owned
- Zero-downtime Hadoop migration
- 70% faster incident resolution

### Things NOT to say
- "I would just use SIG..." → say Susquehanna
- "Snowflake is just like Hadoop" → it shares primitives, not the same architecture; show nuance
- "I have never used Snowflake" without a bridge → "I have not run Snowflake in prod, but architecturally..."
- Em-dashes in writing (you avoid them in writing; in speech do not let written habits leak)

### Snowflake-specific terms to drop naturally
Micro-partitions, virtual warehouse, multi-cluster, clustering key, Snowpipe, Streams, Tasks, Time Travel, zero-copy clone, RBAC, dynamic data masking, query tag, resource monitor, result cache, materialized view, external stage, internal stage.

---

## 10. Open Items — Still to Resolve

All 10 named problems now have worked solutions in the relevant sections. Remaining items:

1. **The actual REQ19469 JD text** if you have it saved, so the role framing can be sharpened. The framing in Section 1 is based on the public Data Platform team JD on the Snowflake careers site; if REQ19469 is a different team or scope, the pitch changes.

2. **Want a separate recruiter-screen one-pager?** The cheat sheet in Section 9 plus Section 8 covers the screen, but if you want a printable Q&A doc for the screen specifically, say the word.

3. **Mock interview prep** — once you have a phone screen scheduled, we can do a timed run-through of 2-3 SQL problems and 1 Python problem, and I will play interviewer.
