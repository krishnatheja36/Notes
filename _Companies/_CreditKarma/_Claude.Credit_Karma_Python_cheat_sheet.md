# Credit Karma — Python Cheat Sheet
*Last updated: 2026-05-25*

---

## Imports Found in Codebase

```python
from abc import ABC, abstractmethod
from collections import Counter
from collections import defaultdict
from collections import deque
from collections import Counter, defaultdict, deque
from dataclasses import dataclass, field
from functools import reduce
from itertools import combinations, permutations, product, accumulate, zip_longest
from typing import Optional, Union
import bisect
import heapq
import math
import re
```

---

## Quick Reference

```python
# -- heapq  (min-heap by default)
import heapq
heapq.heapify(lst)               # convert list → heap in-place          O(n)
heapq.heappush(heap, val)        # push val                               O(log n)
heapq.heappop(heap)              # pop & return smallest                  O(log n)
heapq.heapreplace(heap, val)     # pop smallest then push val             O(log n)
heapq.heappushpop(heap, val)     # push val then pop smallest             O(log n)
heapq.nlargest(k, iterable)      # k largest elements                     O(n log k)
heapq.nsmallest(k, iterable)     # k smallest elements                    O(n log k)
heap[0]                          # peek smallest without popping          O(1)
heapq.heappush(heap, -val)       # max-heap trick: negate values
heapq.heappush(heap, (priority, item))  # heap of tuples — sorts by first element

# -- collections.Counter
from collections import Counter
ctr = Counter("aabbbc")          # Counter({'b':3,'a':2,'c':1})
ctr['x']                         # 0  (no KeyError)
ctr.most_common(2)               # [('b',3), ('a',2)]  top-k
ctr.most_common()[:-k-1:-1]      # k least common
list(ctr.elements())             # ['a','a','b','b','b','c']
ctr.total()                      # sum of all counts
ctr.update("more")               # add more counts
ctr.subtract("aaa")              # subtract counts
ctr1 + ctr2                      # merge (keep positives)
ctr1 - ctr2                      # subtract (keep positives)
ctr1 & ctr2                      # intersection (min of counts)
ctr1 | ctr2                      # union (max of counts)

# -- collections.defaultdict
from collections import defaultdict
d = defaultdict(int)             # missing key → 0
d = defaultdict(list)            # missing key → []
d = defaultdict(set)             # missing key → set()
d = defaultdict(lambda: -1)      # missing key → -1

# -- collections.deque
from collections import deque
dq = deque([1, 2, 3])
dq.append(4)                     # add to right             O(1)
dq.appendleft(0)                 # add to left              O(1)
dq.pop()                         # remove from right        O(1)
dq.popleft()                     # remove from left         O(1)
dq.rotate(k)                     # rotate right k steps
dq[0]  /  dq[-1]                 # peek left / right        O(1)
deque(maxlen=k)                  # fixed-size sliding window

# -- String Methods
s.isalnum()                      # True if all alphanumeric
s.isalpha()                      # True if all letters
s.isdigit()                      # True if all digits
s.isupper() / s.islower()
s.upper() / s.lower()
s.strip() / s.lstrip() / s.rstrip()
s.split(sep)
sep.join(lst)                    # join list into string
s.startswith(prefix)
s.endswith(suffix)
s.find(sub)                      # index or -1
s.count(sub)
s.replace(old, new)
ord('a')                         # 97  — char → int
chr(97)                          # 'a' — int → char
ord(c) - ord('a')                # 0-25 index for lowercase letters

# -- List & Sorting
lst.sort()                       # in-place                 O(n log n)
lst.sort(reverse=True)
lst.sort(key=lambda x: x[1])
sorted(lst)                      # returns new list
lst[::-1]                        # reversed copy
lst.append(x)                    # O(1) amortized
lst.pop()                        # remove last              O(1)
lst.pop(i)                       # remove at index          O(n)
lst.insert(i, x)                 # O(n)
lst.index(x)                     # first index of x         O(n)
[0] * n                          # list of n zeros
[[0]*n for _ in range(m)]        # 2D grid (NOT [[0]*n]*m)

# -- bisect  (binary search on sorted list)
import bisect
bisect.bisect_left(lst, x)       # leftmost index to insert x
bisect.bisect_right(lst, x)      # rightmost index to insert x
bisect.insort_left(lst, x)       # insert x keeping sorted order
i = bisect.bisect_left(lst, x)
found = i < len(lst) and lst[i] == x

# -- Set
s = set()
s.add(x)         / s.remove(x)  # remove raises if missing
s.discard(x)                     # remove silently if missing
x in s                           # O(1) lookup
s1 & s2 / s1 | s2 / s1 - s2 / s1 ^ s2
s1.issubset(s2) / s1.issuperset(s2) / s1.isdisjoint(s2)
frozenset(lst)                   # immutable set (hashable, usable as dict key)

# -- Dict
d.get(key, default)
d.setdefault(key, default)       # set if missing, return value
d.items() / d.keys() / d.values()
key in d                         # O(1)
d.pop(key, default)
{k: v for k, v in d.items() if v > 0}
sorted(d.items(), key=lambda x: x[1])  # sort by value

# -- Built-in Functions
enumerate(lst)                   # (index, value) pairs
enumerate(lst, start=1)
zip(a, b)                        # pair elements
zip(*matrix)                     # transpose matrix
min(lst) / max(lst)
min(lst, key=lambda x: x[1])
sum(lst)
any(iterable) / all(iterable)
abs(x)
divmod(a, b)                     # (quotient, remainder)
pow(base, exp, mod)              # fast modular exponentiation
reversed(lst)
range(n) / range(start, stop, step)

# -- math
import math
math.inf  /  float('inf')        # infinity
math.floor(x) / math.ceil(x)
math.sqrt(x)
math.log(x) / math.log(x, base)
math.gcd(a, b) / math.lcm(a, b)
math.factorial(n)
math.comb(n, k)                  # n choose k
math.perm(n, k)                  # n permute k

# -- itertools
from itertools import combinations, permutations, product, accumulate, zip_longest
combinations(lst, r)             # r-length combos, no repeat
permutations(lst, r)             # r-length perms, order matters
product(lst, repeat=2)           # cartesian product
list(accumulate([1,2,3]))        # [1, 3, 6]  prefix sums
accumulate(lst, max)             # running max
zip_longest(a, b, fillvalue='-') # pad shorter iterable

# -- Decorators
@property                        # method behaves like attribute (no parentheses)
@staticmethod                    # utility, no self/cls
@classmethod                     # receives class; factory methods
from dataclasses import dataclass, field
@dataclass                       # auto-generates __init__, __repr__, __eq__

class Example:
    name: str
    tags: list = field(default_factory=list)  # mutable default

# -- Lambda, map, filter, reduce
square  = lambda x: x ** 2
pairs.sort(key=lambda x: x[1])
people.sort(key=lambda p: (p['age'], p['name']))

doubled  = list(map(lambda x: x * 2, numbers))
upper    = list(map(str.upper, words))
integers = list(map(int, ['1','2','3']))
sums     = list(map(lambda x, y: x + y, a, b))

evens     = list(filter(lambda x: x % 2 == 0, numbers))
non_empty = list(filter(None, ['a', '', 'b', '']))

from functools import reduce
product = reduce(lambda x, y: x * y, [1,2,3,4,5])  # 120
flat    = reduce(lambda x, y: x + y, [[1,2],[3,4]])  # [1,2,3,4]

funcs = [lambda x, i=i: x + i for i in range(3)]   # capture i correctly

# -- Comprehensions & Generators
squares  = [x**2 for x in range(10)]
even_sq  = [x**2 for x in range(10) if x % 2 == 0]
flat     = [x for sub in [[1,2],[3,4]] for x in sub]
squared  = {x: x**2 for x in range(5)}
filtered = {k: v for k, v in d.items() if v > 0}
unique   = {len(w) for w in words}
total    = sum(x**2 for x in range(1_000_000))   # generator — no list created
first    = next(x for x in numbers if x % 2 == 0)

def fibonacci():                 # generator function
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# -- Error Handling
try:
    result = a / b
except ZeroDivisionError:
    return None
except (TypeError, ValueError) as e:
    print(f"Error: {e}")
else:
    pass                         # runs only if NO exception
finally:
    pass                         # ALWAYS runs — cleanup

class InsufficientFundsError(Exception):
    def __init__(self, amount, balance):
        super().__init__(f"Cannot withdraw {amount}, balance is {balance}")

# -- Dunder Methods
def __repr__(self):  return f"Obj('{self.name}')"    # for devs
def __str__(self):   return f"{self.name}"            # for users
def __len__(self):   return len(self.items)           # len(obj)
def __contains__(self, item): return item in self.items  # x in obj
def __eq__(self, other):      return self.name == other.name
def __lt__(self, other):      return len(self) < len(other)
def __add__(self, other):     return Obj(self.items + other.items)

# -- Type Hints
from typing import Optional
def process(data: list[int], label: Optional[str] = None) -> dict[str, int]: ...
def find(nums: list[int], target: int) -> int: ...
value: int | str = 0            # Union (Python 3.10+)

# -- Context Managers
with open('file.txt', 'r') as f:
    data = f.read()             # file auto-closed even on exception

class Timer:
    def __enter__(self):
        import time; self.start = time.time(); return self
    def __exit__(self, *args):
        print(f"Elapsed: {time.time() - self.start:.3f}s")
        return False            # False = don't suppress exceptions

# -- re (Regular Expressions)
import re
re.search(pattern, string)      # first match anywhere
re.findall(pattern, string)     # list of all matches
re.sub(pattern, repl, string)   # replace matches
r'\d+'    # digits     r'\w+' # word chars   r'\s+' # whitespace
r'(\d+)\.(\d+)'              # capture groups → m.groups()

pattern = r'(\d+\.\d+\.\d+\.\d+).*"(\w+) (\S+) HTTP.*" (\d+) (\d+)'
m = re.search(pattern, line)
if m: ip, method, endpoint, status, size = m.groups()

# -- Data Structure Templates
class ListNode:
    def __init__(self, val=0, next=None): self.val = val; self.next = next

def build_list(arr):
    head = curr = ListNode(arr[0])
    for v in arr[1:]: curr.next = ListNode(v); curr = curr.next
    return head

def to_list(head):
    out = []
    while head: out.append(head.val); head = head.next
    return out

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val; self.left = left; self.right = right

class GraphNode:
    def __init__(self, val=0, neighbors=None):
        self.val = val; self.neighbors = neighbors or []

# -- Histogram Template (know these 4 lines cold)
from collections import Counter
def histogram(data):
    freq = Counter(data)
    for key in sorted(freq.keys()):
        print(f"{key:>4} | {'#' * freq[key]} ({freq[key]})")

def word_histogram(text):
    freq = Counter(text.lower().split())
    for word, count in sorted(freq.items(), key=lambda x: -x[1]):
        print(f"{word:>15} | {'#' * count} ({count})")

# -- OOP — Four Pillars
self.name   = name               # public
self._value = value              # protected (convention)
self.__pin  = 1234               # private (name mangled → _Class__pin)

class Child(Parent):
    def __init__(self, x, y): super().__init__(x); self.y = y
    def method(self):         super().method()     # call parent version

for obj in [Dog(), Cat()]: obj.speak()  # polymorphism — same call, different behavior

from abc import ABC, abstractmethod
class Shape(ABC):
    @abstractmethod
    def area(self) -> float: pass   # subclasses MUST implement
```

---

## Common Data Structure Operations

| Structure | Access | Search | Insert | Delete |
|-----------|--------|--------|--------|--------|
| Array | O(1) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1)* | O(1)* |
| Hash Table | O(1) | O(1) | O(1) | O(1) |
| Binary Search Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | O(1)** | O(n) | O(log n) | O(log n) |

*With reference to node
**Access to min/max only

---

## When to Use What

| Tool | Use When |
|---|---|
| `@property` | Method should behave like attribute |
| `@staticmethod` | Utility function, no self/cls needed |
| `@classmethod` | Need access to class, factory methods |
| `@abstractmethod` | Force subclasses to implement (use with ABC) |
| `lambda` | Simple one-liner, used as argument |
| `map()` | Apply function to every element |
| `filter()` | Keep elements that pass a test |
| `reduce()` | Fold list into single value |
| Generator | Large data, memory efficiency matters |
| Context manager | Resource cleanup (files, connections) |
| Dataclass | Simple data container class |
| ABC | Enforce interface on subclasses |

| Use | map() | List Comprehension |
|---|---|---|
| Apply built-in function | ✅ Cleaner | Verbose |
| Apply lambda | Either works | Usually cleaner |
| Multiple iterables | ✅ Cleaner | Need zip() |
| With condition | Use filter() | ✅ Cleaner |
| Readability | Less readable | ✅ More readable |

---

## Pattern Templates

### Stack
```python
stack = []
stack.append(item)    # Push
stack.pop()           # Pop (removes and returns top)
stack[-1]             # Peek (top without removing)
not stack             # Check if empty

# Balanced brackets
stack = []
pairs = {')': '(', ']': '[', '}': '{'}
for char in string:
    if char in '([{': stack.append(char)
    elif char in ')]}':
        if not stack or stack[-1] != pairs[char]: return False
        stack.pop()
return len(stack) == 0
```

### Hash Map
```python
from collections import Counter, defaultdict
freq = Counter(arr)
freq.most_common(k)       # Top k items
d = defaultdict(int)      # Default value 0
d[key] += 1
d = {}
d.get(key, default)       # Safe get
```

### Two Pointers
```python
left, right = 0, len(arr) - 1
while left < right:
    if condition:
        left += 1
    else:
        right -= 1
```

### Sliding Window
```python
# Fixed-size window
from collections import deque
dq = deque(maxlen=k)

# Variable-size window (expand right, shrink left on violation)
seen = set()
left = 0
max_len = 0
for right in range(len(s)):
    while s[right] in seen:       # shrink until valid
        seen.remove(s[left])
        left += 1
    seen.add(s[right])
    max_len = max(max_len, right - left + 1)

# Optimized variable window (jump left pointer directly)
last_seen = {}   # char → last index
left = 0
for right, char in enumerate(s):
    if char in last_seen and last_seen[char] >= left:
        left = last_seen[char] + 1
    last_seen[char] = right
    max_len = max(max_len, right - left + 1)
```

### Two Sum (Hash Map Complement)
```python
seen = {}   # value → index
for i, num in enumerate(nums):
    complement = target - num
    if complement in seen:
        return [seen[complement], i]
    seen[num] = i
```

### Anagram / Group Anagrams
```python
# Valid Anagram — O(n)
Counter(s) == Counter(t)                    # True if anagram

# Group Anagrams — O(n * k log k)
from collections import defaultdict
groups = defaultdict(list)
for word in strs:
    groups[tuple(sorted(word))].append(word)  # sorted tuple = canonical key
return list(groups.values())
```

### Sieve of Eratosthenes (Primes to N)
```python
def primes_to_n(n):
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False
    for i in range(2, int(n**0.5) + 1):
        if is_prime[i]:
            for j in range(i*i, n+1, i):   # start at i*i
                is_prime[j] = False
    return [i for i in range(2, n+1) if is_prime[i]]
```

### BFS / Graph
```python
from collections import deque
queue = deque([start])
visited = {start}
while queue:
    node = queue.popleft()
    for neighbor in graph[node]:
        if neighbor not in visited:
            visited.add(neighbor)
            queue.append(neighbor)
```

### DFS (Grid)
```python
def dfs(r, c):
    if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] == '0':
        return
    grid[r][c] = '0'        # Mark visited (sink it)
    dfs(r+1,c); dfs(r-1,c); dfs(r,c+1); dfs(r,c-1)

directions = [(1,0), (-1,0), (0,1), (0,-1)]
```

### Binary Search
```python
left, right = 0, len(arr) - 1
while left <= right:
    mid = (left + right) // 2
    if arr[mid] == target: return mid
    elif arr[mid] < target: left = mid + 1
    else: right = mid - 1
return -1
```

### DP — Linear
```python
dp = [0] * (n + 1)
dp[0] = base_case
for i in range(1, n + 1):
    dp[i] = dp[i-1] + ...      # recurrence relation
```

### DP — 2D Grid (Unique Paths)
```python
dp = [[1] * n for _ in range(m)]
for i in range(1, m):
    for j in range(1, n):
        dp[i][j] = dp[i-1][j] + dp[i][j-1]
return dp[m-1][n-1]
```

### Merge Intervals
```python
intervals.sort(key=lambda x: x[0])
merged = [intervals[0]]
for start, end in intervals[1:]:
    if start <= merged[-1][1]:
        merged[-1][1] = max(merged[-1][1], end)
    else:
        merged.append([start, end])
```

### Top K Frequent
```python
import heapq
from collections import Counter
freq = Counter(nums)
return heapq.nlargest(k, freq.keys(), key=freq.get)  # O(n log k)
```

### Rainwater (Trapped Water)
```python
max_left[0] = h[0]
for i in range(1, n): max_left[i] = max(max_left[i-1], h[i])
max_right[n-1] = h[n-1]
for i in range(n-2, -1, -1): max_right[i] = max(max_right[i+1], h[i])
total = sum(max(0, min(max_left[i], max_right[i]) - h[i]) for i in range(n))
```

---

## String Operations
```python
''.join(lst)          # Build string from list — O(n)
Counter(s)            # Char frequencies
zip(s1, s2)           # Pair characters
s.lower() / s.upper()
s[::-1]               # Reverse
ord(c) - ord('a')     # 0-25 letter index
```

---

## Edge Cases to Always Mention

```python
if not nums: return []            # 1. Empty input
if len(nums) == 1: return ...    # 2. Single element
# 3. All same elements:  [1,1,1,1]
# 4. Already sorted / reverse sorted
# 5. Negative numbers:   [-1,-2,0,1]
if nums is None: return None     # 6. None / null
```

---

## DP Decision Framework

```
When to use DP:
1. "Find maximum/minimum"    → DP
2. "Count number of ways"    → DP
3. "Is it possible to..."    → DP
4. Overlapping subproblems   → DP

Steps:
1. Define state: what does dp[i] represent?
2. Base case: smallest input?
3. Transition: how does dp[i] relate to dp[i-1]?
4. Answer: where in the dp array?
```

---

## Collaborative Interview Framework

### The 60-Second Rule

```
1. RESTATE  (10 sec):  "So I need to [restate], is that right?"
2. CLARIFY  (15 sec):  "Input format? Return type? Edge cases?"
3. APPROACH (20 sec):  "I'll use [pattern] because [reason]. Time O(...). Sound good?"
4. CODE:               Talk while you type.
5. TEST     (15 sec):  "Let me trace: input [X] → [Y] → output [Z] ✓"
```

### Key Phrases

**Starting:**
> "Let me make sure I understand — the input is X and I need to return Y, is that right?"

**Before coding:**
> "My approach is to use a [stack/hash map/two pointers] because [reason]. Time complexity O(n). Does that sound good before I start?"

**While coding:**
> "I'm using a dictionary here for O(1) lookup..."
> "This handles the edge case where the input is empty..."

**After coding:**
> "Let me trace through the example to verify..."
> "Time O(n), space O(n)..."
> "One optimization would be [X] but I kept it readable for now..."

**If stuck:**
> "Let me think through this out loud..."
> "The brute force would be [X]. Let me see if I can optimize..."
> "Could you give me a hint about whether I should focus on time or space?"

---

## CoderPad Tips

```
1. Interviewer sees everything you type in real time — type comments before code
2. Run your code early and often — fix errors out loud
3. Don't delete and restart — comment out old approach, iterate
4. Time awareness — if stuck 5+ min: "Let me try a different approach"
5. Comments as you think:
   # Step 1: count frequencies
   # Step 2: find top k
```

### Software Engineering Fundamentals Checklist
```
1. Clean readable code       - meaningful names, no magic numbers
2. Modular code              - small focused functions
3. Error handling            - validate inputs, edge cases
4. OOP basics                - classes, encapsulation
5. Time/space complexity     - mention Big O after solving
6. Testing mindset           - cover normal + edge cases
7. Comments/docstrings       - brief docstring on every function
```

### CoderPad Round Timeline
```
READ     (30 sec):   Read fully before saying anything
CLARIFY  (30 sec):   Input/output? Edge cases? Constraints?
APPROACH (1 min):    State pattern + complexity
CODE     (5-10 min): Write docstring first, talk while typing
TEST     (2 min):    Run it, trace example, test edge case
DESIGN   (2-3 min):  "In production I would also add..."
```

---

## Problem Pattern Map

| Pattern | Problems | Key Tool |
|---|---|---|
| Stack | Balanced brackets, matching parens | `stack = []`, `pairs = {')':'('}` |
| Two Pointers | Merge sorted, even/odd ordering | `left, right` |
| Hash Map (complement) | **Two Sum** | `seen = {}`, `target - num` |
| Hash Map (frequency) | String mapping, append frequency, top-k, **anagram** | `Counter`, `defaultdict` |
| Sliding Window (variable) | **Longest substring no repeat** | `set` + `left` pointer |
| Sliding Window (fixed) | Max in window | `deque(maxlen=k)` |
| Math | Missing number (Gauss), add strings | `n*(n+1)//2` |
| Math (Sieve) | **Prime to N** | `is_prime[]` boolean array |
| Intervals | Rectangle overlap, merge intervals | Sort by start |
| Graph BFS/DFS | Number of islands, clone graph | `deque`, `visited` |
| DP | Unique paths, rain water, LCS, knapsack | `dp[]` array |
| OOP | Bank account, robot class, credit score | Classes + encapsulation |
| Heap | Top K frequent | `heapq.nlargest` |
| Tree DFS | Validate BST, max depth | `min_val / max_val` bounds |
