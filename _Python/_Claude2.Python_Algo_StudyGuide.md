# Python Algorithms & Data Structures Interview Guide

> **Comprehensive guide to Python programming, data structures, algorithms, and coding patterns for technical interviews**

---

## Cheat Sheet

### 1. Documentation
```python
python -m pydoc open or help(open) in the python shell
dir(), dir(object), type(a) #type() tells what an object is; dir() tells what you can do with or what is contained within an object.
isinstance(obj, type)        # Type checking
Comments -'#' or '"""' is used too
```

### 2. Imports
```python
from sys import argv
import os
import configargparse								# Modern
import argparse, configparser
from collections import Counter, defaultdict, deque, OrderedDict, namedtuple
from queue import PriorityQueue
from itertools import combinations, permutations, groupby, product, accumulate
from bisect import bisect_left, bisect_right, insort
import re
import math
import datetime
import pandas as pd
import json
from multipledispatch import dispatch
from functools import reduce, lru_cache
import heapq
import array as arr
import numpy as np
import random
from copy import copy, deepcopy
```

### 3. Data types, Operators and Functions
```python
Strings -> are immutable
Tuple	-> a = ('physics', 'chemistry', 1997, 2000) immutable, del tup; elements cannot be sorted
Arrays	-> Need to be declared, Fixed, Homogeneous (stores elements of a single type), Optimized for numerical operations,
Sets	-> The sets are an unordered collection of data types. These are mutable, iterable, and do not consist of any duplicate elements.
```

### 4. Numeric
```python
num, digit = divmod(number, 10), // - floor, ** - Exponential # +, -, *, % -> basic
pow(base, exp), pow(base, exp, mod)  # (base^exp) % mod
math.gcd(a, b), math.lcm(a, b), math.factorial(n), math.comb(n, k), math.perm(n, k)
```

### 5. Strings/Arrays/Lists
```python
str() vs chr() vs ord() #chr() chr(65)-> 'A', chr(97)-> 'a' chr(columnNumber % 26 + 65) ord('A') -> 65
.isalnum(), .isalpha(), .isnumeric(), isdigit(), .count('t')
.upper(), .lower(), title(), .split(), ''.join([]), .sort(), .reverse(), sorted()
len(s), .strip(), .ltrip(), .rstip(), .capitalize(), .replace('old', 'new'), s[::-1] #reverse
find(-1 if not found), index(value error, if not found), rfind, rindex
```

### 6. Sets
```python
add(), pop(), update(), intersection(), .discard()
DaysA|DaysB, DaysA & DaysB, DaysA - DaysB 	#union of sets, #intersection, #Difference
```

### 7. Dictionaries
```python
get('key','default'), .clear()
collections.ChainMap(dict1, dict2)
```

### 8. Counter
```python
Counter(list), .keys(), .values(), .get('B'), .most_common()
```

### 9. Functions
```python
def function_name(arg1, arg2 or *args) #functions vs method, every method is a function. Method created in a class and called by an object. Function not so, just called by name.
```

### 10. File handling
```python
with open('filename.txt', 'mode') as f:
	f.read(), f.readline(), f.readlines(), f.write("stuff"), f.truncate(), f.truncate(10), os.truncate(path, 10) # truncates to 10 bytes
```

### 11. Lambda functions
```python
lambda arguments : expression
s2 = lambda func: func.upper()												# print(s2("TestThisString"))
n = lambda x: "Positive" if x > 0 else "Negative" if x < 0 else "Zero"		# print(n(-5))
li = [lambda arg=x: arg * 10 for x in range(1, 5)] 							# for i in li: print(i())
sq = lambda x: x ** 2														# print(sq(3))
sq = lambda x: x ** (1/2)													# print(sq(16))
calc = lambda x, y: (x + y, x * y)											# print(calc(3, 4))
even = filter(lambda x: x % 2 == 0, n) or list(filter(lambda x: x%2 ==0, n))# n = [1, 2, 3, 4, 5, 6] print(list(even))
b = list(map(lambda x: x*2, n))												# n = [1, 2, 3, 4, 5, 6] print(b)
new_dict = dict(map(lambda item: (item[0], item[1]**2), my_dict.items()))	# my_dict = {'a': 1, 'b': 2, 'c': 3} print(new_dict)
s = reduce(lambda x, y: x + y, n)											# n = [1, 2, 3, 4, 5, 6] print(s) 			#from functools import reduce
p = reduce(lambda x, y: x * y, n)											# n = [1, 2, 3, 4, 5, 6] print(p)
```

### 12. Queues
```python
queue = deque(), queue.append(timestamp), queue.appendleft(timestamp), queue.pop(), queue.popleft() 		# double sided queue # lib->collections
pq = PriorityQueue(), pq.put((1, 'object1')), pq.put((2, 'object2')), pq.put((1, 'object3')) and pq.get()	# lib->queue
directly access internal list of pq -> print(pq.queue)

heapq.heapify(list) #By default this implements min heap. Multiply variables with -1 and add to implement max heap
heapq.heappop(minheap), heapq.heappush(self.minheap, val), minheap[0], minheap[-1] #min element, max element
```

### 13. One line list creations
```python
info = ["{}={}".format(k,v) for k,v in params.items()]
[dict.setdefault(l, 0) for l in range(len(weights[i]))]
```

### 14. Misc functions
```python
random.randint(1,300)
os.getcwd()
min(list) or min(list, key=len),
min(data, key=lambda person: person["age"]) #data = [{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}, {"name": "Charlie", "age": 35}]
max(def_dict.keys(), key=def_dict.get)

list.sort(key=len, reverse=True) or sorted(list, key=len, reverse=True) 	# my_list = ["apple", "banana", "kiwi", "grapefruit"]
sorted(map(str, list), key=len, reverse=True)								# n = [1, 2, 3, 4, 5, 62]
sorted(my_dict, key=my_dict.get, reverse=True)							# my_dict = {'apple': 5, 'banana': 2, 'cherry': 8}
sorted(my_dict.items(), key=lambda x:x[1], reverse=True)					#
res_lst = sorted(map(sorted, combinations(x,2)))

for i, node in enumerate(nodes): or for i, node in enumerate(nodes, 1): # to start from 1
for nums, target in zip(nums_lists,target_list):
for key, group in groupby(data, key=lambda x: x[0]):          # data = [('A', 1), ('A', 2), ('B', 3), ('B', 4), ('C', 5)]
    print(f"Key: {key}, Group: {list(group)}") 	              # -> data.sort(key=lambda x: x[0])  # Data must be sorted # lib-> itertools

json_str = json.dumps({'a':{'b':'c', 'd':'e'}})
json_obj = json.loads(json_str)
```

### 15. Abstract class
```python
from abc import ABC, abstractmethod
class Animal(ABC):						# This will raise an error - can't instantiate abstract class
    @abstractmethod						# animal = Animal()
    def make_sound(self):
        pass
    @abstractmethod
    def move(self):
        pass
    def sleep(self):  # Regular method (not abstract)
        print("Sleeping...")

class Dog(Animal):
    def make_sound(self):
        print("Woof!")

    def move(self):
        print("Running on four legs")

dog = Dog()
dog.make_sound()  # Woof!
dog.sleep()  # Sleeping...
```

### 16. Decorator
```python
1.	def my_decorator(func):
		def wrapper():
			print("Before function")
			func()
			print("After function")
		return wrapper

	@my_decorator
	def say_hello():
		print("Hello!")

	say_hello()
	# Output:
	# Before function
	# Hello!
	# After function

2.	import time

	def timing_decorator(func):
		def wrapper(*args, **kwargs):
			start = time.time()
			result = func(*args, **kwargs)
			end = time.time()
			print(f"{func.__name__} took {end - start:.4f} seconds")
			return result
		return wrapper

	@timing_decorator
	def slow_function():
		time.sleep(1)
		return "Done"

	slow_function()  # slow_function took 1.0012 seconds
```

---

## Python Basics

### Essential Documentation
```python
# Getting help
help(function_name)          # Built-in help
dir(object)                  # List attributes
type(object)                 # Get type
isinstance(obj, type)        # Type checking

# Command line documentation
python -m pydoc function_name

# Comments
# Single line comment

"""
Multi-line comment
or docstring
"""

def function(param):
    """
    Brief description.
    
    Args:
        param (type): Description
    
    Returns:
        type: Description
    """
    pass
```

### Critical Imports for Interviews
```python
# Essential imports
from collections import (
    Counter,           # Frequency counting
    defaultdict,       # Dict with default values
    deque,            # Double-ended queue
    OrderedDict,      # Ordered dictionary
    namedtuple        # Named tuple
)

# Algorithms
from itertools import (
    combinations,      # C(n,k)
    permutations,      # P(n,k)
    product,          # Cartesian product
    groupby,          # Group consecutive elements
    accumulate        # Running totals
)

# Heaps
import heapq

# Binary search
from bisect import bisect_left, bisect_right, insort

# Functional
from functools import reduce, lru_cache

# Data handling
import json
import re  # Regular expressions
import math
import random

# Deep copying
from copy import copy, deepcopy
```

**💡 Interview Tip:** Memorize these imports - they're crucial for efficient solutions

---

## Data Types & Structures

### Primitives & Immutables
```python
# Numbers
x = 42              # int
f = 3.14            # float
c = 3 + 4j          # complex
b = True            # bool

# Strings (IMMUTABLE)
s = "Hello"
s = 'World'
s = """Multi
line"""

# Tuples (IMMUTABLE)
t = (1, 2, 3)
single = (1,)       # Comma required!
```

### Mutable Collections
```python
# Lists (dynamic arrays)
lst = [1, 2, 3, 4]
lst = list(range(5))        # [0, 1, 2, 3, 4]
matrix = [[0]*3 for _ in range(3)]  # 3x3 matrix

# ⚠️ Common mistake
wrong = [[0]*3] * 3         # All rows reference same list!
correct = [[0]*3 for _ in range(3)]

# Dictionaries (hash tables)
d = {'key': 'value'}
d = dict(a=1, b=2)

# Sets (unique elements)
s = {1, 2, 3}
empty_set = set()           # NOT {} (that's empty dict)

# Frozen set (immutable)
fs = frozenset([1, 2, 3])
```

**💡 Key Insight:** 
- Lists: O(1) append, O(n) insert/delete at position
- Dicts/Sets: O(1) average lookup, insert, delete
- Tuples: Immutable, can be dict keys

---

## String Operations

### Essential String Methods
```python
s = "  Hello World  "

# Conversion
ord('A')            # 65 (char to ASCII)
chr(65)             # 'A' (ASCII to char)
int("42")           # 42
str(42)             # "42"

# Case
s.upper()           # "  HELLO WORLD  "
s.lower()           # "  hello world  "
s.title()           # "  Hello World  "
s.capitalize()      # "  hello world  "

# Whitespace
s.strip()           # "Hello World"
s.lstrip()          # "Hello World  "
s.rstrip()          # "  Hello World"

# Search
s.find('World')     # 8 (index or -1)
s.index('World')    # 8 (raises ValueError if not found)
s.count('l')        # Count occurrences
s.startswith('Hel')
s.endswith('rld')

# Modify
s.replace('World', 'Python')
parts = s.split()            # Split by whitespace
words = "a,b,c".split(',')   # ['a', 'b', 'c']
",".join(['a', 'b', 'c'])    # "a,b,c"

# Checking
s.isalnum()         # Alphanumeric
s.isalpha()         # Alphabetic
s.isdigit()         # Digit
s.isnumeric()       # Numeric
s.isspace()         # Whitespace

# Slicing
s[0]                # First char
s[-1]               # Last char
s[0:5]              # Substring
s[::-1]             # Reverse
```

### Advanced String Techniques
```python
# String formatting (f-strings - preferred)
name, age = "Alice", 30
s = f"Name: {name}, Age: {age}"
s = f"Calculation: {2 + 2}"
s = f"{3.14159:.2f}"        # "3.14"
s = f"{42:05d}"             # "00042" (zero padding)
s = f"{name:>10}"           # Right align in 10 chars

# Regular expressions
import re

text = "Phone: 123-456-7890"
pattern = r'\d{3}-\d{3}-\d{4}'

re.search(pattern, text)     # Find first match
re.findall(r'\d+', text)     # ['123', '456', '7890']
re.sub(r'\d', 'X', text)     # Replace digits

# Common patterns
r'\d'      # Digit
r'\w'      # Word character
r'\s'      # Whitespace
r'.'       # Any character
r'^'       # Start
r'$'       # End
r'*'       # 0 or more
r'+'       # 1 or more
r'?'       # 0 or 1
r'{n,m}'   # Between n and m
```

### Common String Interview Patterns
```python
# Check palindrome
def is_palindrome(s):
    # Two pointers
    left, right = 0, len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    return True

# Or simpler
def is_palindrome_simple(s):
    return s == s[::-1]

# Valid anagram
def is_anagram(s, t):
    return sorted(s) == sorted(t)
    # Or: Counter(s) == Counter(t)

# Group anagrams
def group_anagrams(strs):
    from collections import defaultdict
    groups = defaultdict(list)
    for s in strs:
        key = ''.join(sorted(s))
        groups[key].append(s)
    return list(groups.values())

# Longest substring without repeating characters
def length_of_longest_substring(s):
    char_index = {}
    max_len = start = 0
    
    for i, char in enumerate(s):
        if char in char_index and char_index[char] >= start:
            start = char_index[char] + 1
        max_len = max(max_len, i - start + 1)
        char_index[char] = i
    
    return max_len

# String to integer (atoi)
def my_atoi(s):
    s = s.lstrip()
    if not s:
        return 0
    
    sign = 1
    i = 0
    
    if s[0] in ['+', '-']:
        sign = -1 if s[0] == '-' else 1
        i = 1
    
    num = 0
    while i < len(s) and s[i].isdigit():
        num = num * 10 + int(s[i])
        i += 1
    
    num *= sign
    # Clamp to 32-bit signed integer range
    return max(-2**31, min(2**31 - 1, num))
```

**💡 Interview Tip:** For string manipulation, consider:
- Two pointers (palindrome, reverse)
- Hash table (anagrams, duplicates)
- Sliding window (substring problems)

---

## Arrays & Lists

### List Operations & Time Complexity
```python
lst = [1, 2, 3, 4, 5]

# Access - O(1)
first = lst[0]
last = lst[-1]
slice = lst[1:4]        # [2, 3, 4]

# Modify
lst[0] = 10             # O(1)

# Add
lst.append(6)           # O(1) amortized - add to end
lst.insert(0, 0)        # O(n) - insert at position
lst.extend([7, 8])      # O(k) - add multiple

# Remove
lst.pop()               # O(1) - remove last
lst.pop(0)              # O(n) - remove at position
lst.remove(3)           # O(n) - remove first occurrence
lst.clear()             # O(n) - remove all

# Search
index = lst.index(3)    # O(n) - find index
count = lst.count(2)    # O(n) - count occurrences
exists = 3 in lst       # O(n) - membership test

# Sort
lst.sort()              # O(n log n) - in-place
sorted_lst = sorted(lst) # O(n log n) - new list
lst.reverse()           # O(n) - in-place reverse

# Other
len(lst)                # O(1)
min(lst)                # O(n)
max(lst)                # O(n)
sum(lst)                # O(n)
```

### List Comprehensions
```python
# Basic
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]

# Nested
matrix = [[i+j for j in range(3)] for i in range(3)]
flattened = [num for row in matrix for num in row]

# With multiple conditions
result = [x for x in range(20) if x % 2 == 0 if x % 3 == 0]

# Conditional expression
result = [x if x % 2 == 0 else -x for x in range(5)]
# [0, -1, 2, -3, 4]
```

### Critical Array Patterns

#### Two Pointers
```python
# Two sum (sorted array)
def two_sum_sorted(nums, target):
    left, right = 0, len(nums) - 1
    
    while left < right:
        curr_sum = nums[left] + nums[right]
        if curr_sum == target:
            return [left, right]
        elif curr_sum < target:
            left += 1
        else:
            right -= 1
    
    return []

# Remove duplicates (sorted array)
def remove_duplicates(nums):
    if not nums:
        return 0
    
    slow = 0
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    
    return slow + 1

# Container with most water
def max_area(height):
    left, right = 0, len(height) - 1
    max_water = 0
    
    while left < right:
        width = right - left
        h = min(height[left], height[right])
        max_water = max(max_water, width * h)
        
        if height[left] < height[right]:
            left += 1
        else:
            right -= 1
    
    return max_water
```

#### Sliding Window
```python
# Maximum sum subarray of size k
def max_sum_subarray(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum
    
    for i in range(k, len(arr)):
        window_sum = window_sum - arr[i-k] + arr[i]
        max_sum = max(max_sum, window_sum)
    
    return max_sum

# Longest substring without repeating characters
def length_of_longest_substring(s):
    char_set = set()
    left = max_len = 0
    
    for right in range(len(s)):
        while s[right] in char_set:
            char_set.remove(s[left])
            left += 1
        
        char_set.add(s[right])
        max_len = max(max_len, right - left + 1)
    
    return max_len
```

#### Prefix Sum
```python
# Build prefix sum array
def build_prefix_sum(arr):
    prefix = [0]
    for num in arr:
        prefix.append(prefix[-1] + num)
    return prefix

# Query range sum: sum(arr[i:j+1]) = prefix[j+1] - prefix[i]
def range_sum(arr, i, j):
    prefix = build_prefix_sum(arr)
    return prefix[j+1] - prefix[i]

# Subarray sum equals K
def subarray_sum(nums, k):
    from collections import defaultdict
    prefix_sum = 0
    count = 0
    sum_count = defaultdict(int)
    sum_count[0] = 1
    
    for num in nums:
        prefix_sum += num
        count += sum_count[prefix_sum - k]
        sum_count[prefix_sum] += 1
    
    return count
```

#### Kadane's Algorithm (Max Subarray Sum)
```python
def max_subarray(nums):
    max_sum = curr_sum = nums[0]
    
    for num in nums[1:]:
        curr_sum = max(num, curr_sum + num)
        max_sum = max(max_sum, curr_sum)
    
    return max_sum
```

#### Dutch National Flag (3-way Partition)
```python
def sort_colors(nums):
    """Sort array with values 0, 1, 2"""
    low, mid, high = 0, 0, len(nums) - 1
    
    while mid <= high:
        if nums[mid] == 0:
            nums[low], nums[mid] = nums[mid], nums[low]
            low += 1
            mid += 1
        elif nums[mid] == 1:
            mid += 1
        else:  # nums[mid] == 2
            nums[mid], nums[high] = nums[high], nums[mid]
            high -= 1
```

**💡 Interview Tip:** Most array problems use one of these patterns:
- Two Pointers (sorted arrays, palindromes)
- Sliding Window (subarrays, substrings)
- Prefix Sum (range queries)
- Kadane's (max subarray)
- Dutch National Flag (3-way partition)

---

## Stacks & Queues

### Stack Implementation
```python
# Using list (simple, most common)
stack = []
stack.append(1)        # Push - O(1)
stack.append(2)
top = stack.pop()      # Pop - O(1)
peek = stack[-1]       # Peek - O(1)
is_empty = not stack

# Using deque (slightly better)
from collections import deque
stack = deque()
stack.append(1)
top = stack.pop()
```

### Queue Implementation
```python
# Using deque (efficient)
from collections import deque

queue = deque()
queue.append(1)          # Enqueue - O(1)
queue.append(2)
first = queue.popleft()  # Dequeue - O(1)
peek = queue[0]          # Peek front
is_empty = not queue

# ⚠️ DON'T use list for queue
queue = []
queue.append(1)
first = queue.pop(0)     # O(n) - SLOW!
```

### Stack Patterns

#### Valid Parentheses
```python
def is_valid_parentheses(s):
    stack = []
    pairs = {'(': ')', '[': ']', '{': '}'}
    
    for char in s:
        if char in pairs:
            stack.append(char)
        elif not stack or pairs[stack.pop()] != char:
            return False
    
    return not stack
```

#### Monotonic Stack (Next Greater Element)
```python
# Next greater element to the right
def next_greater_element(nums):
    result = [-1] * len(nums)
    stack = []  # Store indices
    
    for i in range(len(nums)):
        while stack and nums[stack[-1]] < nums[i]:
            idx = stack.pop()
            result[idx] = nums[i]
        stack.append(i)
    
    return result

# Daily temperatures
def daily_temperatures(temps):
    result = [0] * len(temps)
    stack = []
    
    for i, temp in enumerate(temps):
        while stack and temps[stack[-1]] < temp:
            prev_idx = stack.pop()
            result[prev_idx] = i - prev_idx
        stack.append(i)
    
    return result

# Largest rectangle in histogram
def largest_rectangle(heights):
    stack = []
    max_area = 0
    heights.append(0)  # Sentinel
    
    for i, h in enumerate(heights):
        while stack and heights[stack[-1]] > h:
            height = heights[stack.pop()]
            width = i if not stack else i - stack[-1] - 1
            max_area = max(max_area, height * width)
        stack.append(i)
    
    return max_area
```

#### Evaluate Expressions
```python
# Reverse Polish Notation
def eval_rpn(tokens):
    stack = []
    operators = {
        '+': lambda a, b: a + b,
        '-': lambda a, b: a - b,
        '*': lambda a, b: a * b,
        '/': lambda a, b: int(a / b)
    }
    
    for token in tokens:
        if token in operators:
            b = stack.pop()
            a = stack.pop()
            stack.append(operators[token](a, b))
        else:
            stack.append(int(token))
    
    return stack[0]
```

### Queue Patterns

#### BFS Template
```python
def bfs(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        node = queue.popleft()
        result.append(node.val)
        
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    
    return result

# Level-order traversal
def level_order(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level)
    
    return result
```

**💡 Interview Tip:** 
- Stacks: LIFO, use for backtracking, expression evaluation, monotonic sequences
- Queues: FIFO, use for BFS, level-order traversal, sliding window
- Monotonic stacks: Common for "next greater/smaller" problems

---

## Hash Tables & Sets

### Dictionary (Hash Table) Operations
```python
# Creation
d = {}
d = dict()
d = {'a': 1, 'b': 2}
d = dict(a=1, b=2)

# Access - O(1) average
value = d['a']           # KeyError if missing
value = d.get('a')       # None if missing
value = d.get('missing', 0)  # Default value
d.setdefault('c', 3)     # Set if not exists

# Modify - O(1) average
d['a'] = 10
d.update({'d': 4, 'e': 5})

# Delete - O(1) average
del d['a']
value = d.pop('b')
d.clear()

# Iteration
for key in d:
    pass
for key, value in d.items():
    pass
for key in d.keys():
    pass
for value in d.values():
    pass

# Checking
if 'a' in d:             # O(1)
    pass
len(d)                   # O(1)

# Comprehension
squared = {x: x**2 for x in range(5)}
filtered = {k: v for k, v in d.items() if v > 10}

# Merge (Python 3.9+)
merged = d1 | d2
```

### Counter
```python
from collections import Counter

# Create
cnt = Counter(['a', 'b', 'c', 'a', 'b', 'a'])
# Counter({'a': 3, 'b': 2, 'c': 1})

# Methods
cnt['a']                  # 3
cnt.most_common(2)        # [('a', 3), ('b', 2)]
list(cnt.elements())      # ['a', 'a', 'a', 'b', 'b', 'c']

# Operations
cnt1 + cnt2               # Add counts
cnt1 - cnt2               # Subtract
cnt1 & cnt2               # Intersection (min)
cnt1 | cnt2               # Union (max)
```

### DefaultDict
```python
from collections import defaultdict

# With different default factories
dd_int = defaultdict(int)        # Default: 0
dd_list = defaultdict(list)      # Default: []
dd_set = defaultdict(set)        # Default: set()
dd_custom = defaultdict(lambda: "N/A")

# Usage
dd_int['a'] += 1                 # No KeyError
dd_list['a'].append(1)

# Group by pattern
words = ["the", "quick", "brown", "the"]
groups = defaultdict(list)
for i, word in enumerate(words):
    groups[word].append(i)
```

### Set Operations
```python
# Creation
s = {1, 2, 3}
s = set([1, 2, 3])
empty = set()  # NOT {}

# Add/Remove - O(1) average
s.add(4)
s.remove(3)      # KeyError if missing
s.discard(3)     # No error
s.pop()          # Remove arbitrary
s.clear()

# Set operations
a = {1, 2, 3, 4}
b = {3, 4, 5, 6}

a | b            # Union: {1, 2, 3, 4, 5, 6}
a & b            # Intersection: {3, 4}
a - b            # Difference: {1, 2}
a ^ b            # Symmetric diff: {1, 2, 5, 6}

# Subset/Superset
{1, 2} <= {1, 2, 3}  # True
{1, 2}.issubset({1, 2, 3})

# Comprehension
squares = {x**2 for x in range(5)}
```

### Hash Table Patterns

#### Two Sum
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

#### Group Anagrams
```python
def group_anagrams(strs):
    from collections import defaultdict
    groups = defaultdict(list)
    
    for s in strs:
        key = ''.join(sorted(s))
        groups[key].append(s)
    
    return list(groups.values())
```

#### LRU Cache
```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cache = OrderedDict()
        self.capacity = capacity
    
    def get(self, key):
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)
        return self.cache[key]
    
    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)
```

#### Longest Consecutive Sequence
```python
def longest_consecutive(nums):
    num_set = set(nums)
    max_length = 0
    
    for num in num_set:
        # Only start from sequence beginning
        if num - 1 not in num_set:
            current = num
            length = 1
            
            while current + 1 in num_set:
                current += 1
                length += 1
            
            max_length = max(max_length, length)
    
    return max_length
```

**💡 Interview Tip:** Use hash tables for:
- O(1) lookups (two sum, frequency counting)
- Grouping/categorizing (anagrams, group by property)
- Detecting duplicates
- Caching/memoization

## Heaps & Priority Queues

### Heap Basics (Min Heap by default)
```python
import heapq

# Create heap
heap = []
heapq.heapify([3, 1, 4, 1, 5])   # In-place - O(n)

# Push - O(log n)
heapq.heappush(heap, 2)

# Pop minimum - O(log n)
min_val = heapq.heappop(heap)

# Peek minimum - O(1)
min_val = heap[0]

# Push and pop combined
val = heapq.heappushpop(heap, 6)  # Push then pop
val = heapq.heapreplace(heap, 6)  # Pop then push

# N largest/smallest - O(n log k)
largest_3 = heapq.nlargest(3, heap)
smallest_3 = heapq.nsmallest(3, heap)

# With key
data = [{'name': 'Alice', 'age': 30}, {'name': 'Bob', 'age': 25}]
youngest = heapq.nsmallest(1, data, key=lambda x: x['age'])
```

### Max Heap Workaround
```python
# Negate values for max heap
max_heap = []
heapq.heappush(max_heap, -5)
heapq.heappush(max_heap, -3)
max_val = -heapq.heappop(max_heap)  # 5

# Or with tuples
heap = []
heapq.heappush(heap, (-priority, value))
```

### Priority Queue
```python
from queue import PriorityQueue

pq = PriorityQueue()
pq.put((1, "Low priority"))
pq.put((3, "High priority"))

priority, item = pq.get()  # (1, "Low priority")

# Non-blocking
if not pq.empty():
    item = pq.get_nowait()
```

### Heap Patterns

#### K Closest Points
```python
def k_closest(points, k):
    heap = []
    for x, y in points:
        dist = -(x*x + y*y)  # Negative for max heap
        if len(heap) < k:
            heapq.heappush(heap, (dist, x, y))
        else:
            heapq.heappushpop(heap, (dist, x, y))
    
    return [(x, y) for (dist, x, y) in heap]
```

#### Merge K Sorted Lists
```python
def merge_k_lists(lists):
    heap = []
    result = []
    
    # Initialize with first from each list
    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(heap, (lst[0], i, 0))
    
    while heap:
        val, list_idx, elem_idx = heapq.heappop(heap)
        result.append(val)
        
        # Add next from same list
        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(heap, (next_val, list_idx, elem_idx + 1))
    
    return result
```

#### Find Median from Data Stream
```python
class MedianFinder:
    def __init__(self):
        self.small = []  # Max heap (negated)
        self.large = []  # Min heap
    
    def addNum(self, num):
        heapq.heappush(self.small, -num)
        
        # Balance heaps
        if (self.small and self.large and 
            -self.small[0] > self.large[0]):
            val = -heapq.heappop(self.small)
            heapq.heappush(self.large, val)
        
        # Maintain size (small heap at most 1 larger)
        if len(self.small) > len(self.large) + 1:
            val = -heapq.heappop(self.small)
            heapq.heappush(self.large, val)
        if len(self.large) > len(self.small):
            val = heapq.heappop(self.large)
            heapq.heappush(self.small, -val)
    
    def findMedian(self):
        if len(self.small) > len(self.large):
            return -self.small[0]
        return (-self.small[0] + self.large[0]) / 2.0
```

**💡 Interview Tip:** Use heaps for:
- K-th largest/smallest
- Merge K sorted sequences
- Running median
- Top K frequent elements

---

## Linked Lists

### Node Definition
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

# Doubly linked
class DListNode:
    def __init__(self, val=0, prev=None, next=None):
        self.val = val
        self.prev = prev
        self.next = next
```

### Essential Patterns

#### Reverse Linked List
```python
# Iterative
def reverse_list(head):
    prev = None
    curr = head
    
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node
    
    return prev

# Recursive
def reverse_recursive(head):
    if not head or not head.next:
        return head
    
    new_head = reverse_recursive(head.next)
    head.next.next = head
    head.next = None
    return new_head
```

#### Detect Cycle (Floyd's Algorithm)
```python
def has_cycle(head):
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    
    return False

# Find cycle start
def detect_cycle(head):
    slow = fast = head
    
    # Find meeting point
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            break
    else:
        return None
    
    # Move slow to head, advance both
    slow = head
    while slow != fast:
        slow = slow.next
        fast = fast.next
    
    return slow
```

#### Middle of Linked List
```python
def middle_node(head):
    slow = fast = head
    
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    
    return slow
```

#### Merge Two Sorted Lists
```python
def merge_two_lists(l1, l2):
    dummy = ListNode(0)
    curr = dummy
    
    while l1 and l2:
        if l1.val < l2.val:
            curr.next = l1
            l1 = l1.next
        else:
            curr.next = l2
            l2 = l2.next
        curr = curr.next
    
    curr.next = l1 or l2
    return dummy.next
```

#### Remove Nth Node from End
```python
def remove_nth_from_end(head, n):
    dummy = ListNode(0, head)
    fast = slow = dummy
    
    # Move fast n+1 steps ahead
    for _ in range(n + 1):
        fast = fast.next
    
    # Move both until fast reaches end
    while fast:
        fast = fast.next
        slow = slow.next
    
    # Remove node
    slow.next = slow.next.next
    return dummy.next
```

#### Palindrome Linked List
```python
def is_palindrome(head):
    # Find middle
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    
    # Reverse second half
    prev = None
    while slow:
        next_node = slow.next
        slow.next = prev
        prev = slow
        slow = next_node
    
    # Compare
    left, right = head, prev
    while right:
        if left.val != right.val:
            return False
        left = left.next
        right = right.next
    
    return True
```

**💡 Interview Tip:** Use dummy node to simplify edge cases

---

## Trees

### Tree Node
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
```

### Traversals

#### Recursive Traversals
```python
# Inorder (Left -> Root -> Right)
def inorder(root):
    if not root:
        return []
    return inorder(root.left) + [root.val] + inorder(root.right)

# Preorder (Root -> Left -> Right)
def preorder(root):
    if not root:
        return []
    return [root.val] + preorder(root.left) + preorder(root.right)

# Postorder (Left -> Right -> Root)
def postorder(root):
    if not root:
        return []
    return postorder(root.left) + postorder(root.right) + [root.val]
```

#### Iterative Traversals
```python
# Iterative inorder
def inorder_iterative(root):
    result = []
    stack = []
    curr = root
    
    while curr or stack:
        while curr:
            stack.append(curr)
            curr = curr.left
        curr = stack.pop()
        result.append(curr.val)
        curr = curr.right
    
    return result

# Iterative preorder
def preorder_iterative(root):
    if not root:
        return []
    
    result = []
    stack = [root]
    
    while stack:
        node = stack.pop()
        result.append(node.val)
        
        if node.right:
            stack.append(node.right)
        if node.left:
            stack.append(node.left)
    
    return result

# Level-order (BFS)
def level_order(root):
    if not root:
        return []
    
    result = []
    queue = deque([root])
    
    while queue:
        level_size = len(queue)
        level = []
        
        for _ in range(level_size):
            node = queue.popleft()
            level.append(node.val)
            
            if node.left:
                queue.append(node.left)
            if node.right:
                queue.append(node.right)
        
        result.append(level)
    
    return result
```

### Common Tree Problems

#### Maximum Depth
```python
def max_depth(root):
    if not root:
        return 0
    return 1 + max(max_depth(root.left), max_depth(root.right))
```

#### Validate BST
```python
def is_valid_bst(root):
    def validate(node, min_val, max_val):
        if not node:
            return True
        
        if node.val <= min_val or node.val >= max_val:
            return False
        
        return (validate(node.left, min_val, node.val) and
                validate(node.right, node.val, max_val))
    
    return validate(root, float('-inf'), float('inf'))
```

#### Lowest Common Ancestor
```python
def lowest_common_ancestor(root, p, q):
    if not root or root == p or root == q:
        return root
    
    left = lowest_common_ancestor(root.left, p, q)
    right = lowest_common_ancestor(root.right, p, q)
    
    if left and right:
        return root
    return left or right
```

#### Diameter of Binary Tree
```python
def diameter_of_binary_tree(root):
    diameter = [0]
    
    def height(node):
        if not node:
            return 0
        
        left_h = height(node.left)
        right_h = height(node.right)
        
        # Update diameter
        diameter[0] = max(diameter[0], left_h + right_h)
        
        return 1 + max(left_h, right_h)
    
    height(root)
    return diameter[0]
```

#### Serialize and Deserialize
```python
def serialize(root):
    def helper(node):
        if not node:
            return ['null']
        return ([str(node.val)] + 
                helper(node.left) + 
                helper(node.right))
    return ','.join(helper(root))

def deserialize(data):
    def helper(nodes):
        val = next(nodes)
        if val == 'null':
            return None
        node = TreeNode(int(val))
        node.left = helper(nodes)
        node.right = helper(nodes)
        return node
    return helper(iter(data.split(',')))
```

**💡 Interview Tip:** Most tree problems use:
- DFS for path/height problems
- BFS for level-order problems
- Post-order for bottom-up computation

---

## Binary Search Trees

### BST Operations
```python
class BST:
    def __init__(self):
        self.root = None
    
    def insert(self, val):
        def _insert(node, val):
            if not node:
                return TreeNode(val)
            
            if val < node.val:
                node.left = _insert(node.left, val)
            else:
                node.right = _insert(node.right, val)
            
            return node
        
        self.root = _insert(self.root, val)
    
    def search(self, val):
        node = self.root
        while node:
            if val == node.val:
                return node
            elif val < node.val:
                node = node.left
            else:
                node = node.right
        return None
    
    def delete(self, val):
        def _delete(node, val):
            if not node:
                return None
            
            if val < node.val:
                node.left = _delete(node.left, val)
            elif val > node.val:
                node.right = _delete(node.right, val)
            else:
                # Node to delete found
                if not node.left:
                    return node.right
                if not node.right:
                    return node.left
                
                # Two children: find inorder successor
                min_node = self._find_min(node.right)
                node.val = min_node.val
                node.right = _delete(node.right, min_node.val)
            
            return node
        
        self.root = _delete(self.root, val)
    
    def _find_min(self, node):
        while node.left:
            node = node.left
        return node
```

### BST Problems

#### Kth Smallest Element
```python
def kth_smallest(root, k):
    stack = []
    curr = root
    count = 0
    
    while curr or stack:
        while curr:
            stack.append(curr)
            curr = curr.left
        
        curr = stack.pop()
        count += 1
        if count == k:
            return curr.val
        
        curr = curr.right
```

#### Construct BST from Preorder
```python
def bst_from_preorder(preorder):
    def build(min_val, max_val):
        if not preorder:
            return None
        
        val = preorder[0]
        if val < min_val or val > max_val:
            return None
        
        preorder.pop(0)
        root = TreeNode(val)
        root.left = build(min_val, val)
        root.right = build(val, max_val)
        return root
    
    return build(float('-inf'), float('inf'))
```

---

## Graphs

### Graph Representations
```python
# Adjacency list (most common)
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A', 'F'],
    'D': ['B'],
    'F': ['C']
}

# Using defaultdict
from collections import defaultdict
graph = defaultdict(list)
graph['A'].append('B')

# Adjacency matrix
n = 4
matrix = [[0] * n for _ in range(n)]
matrix[0][1] = 1  # Edge 0 -> 1

# Edge list
edges = [(0, 1), (1, 2), (2, 3)]
```

### Graph Traversals

#### DFS
```python
# Recursive
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()
    
    visited.add(node)
    print(node)
    
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)
    
    return visited

# Iterative
def dfs_iterative(graph, start):
    visited = set()
    stack = [start]
    
    while stack:
        node = stack.pop()
        if node not in visited:
            visited.add(node)
            print(node)
            
            for neighbor in reversed(graph[node]):
                if neighbor not in visited:
                    stack.append(neighbor)
    
    return visited
```

#### BFS
```python
def bfs(graph, start):
    visited = set([start])
    queue = deque([start])
    
    while queue:
        node = queue.popleft()
        print(node)
        
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
    
    return visited
```

### Graph Patterns

#### Detect Cycle (Directed Graph)
```python
def has_cycle(graph):
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {node: WHITE for node in graph}
    
    def dfs(node):
        if color[node] == GRAY:
            return True  # Back edge
        if color[node] == BLACK:
            return False
        
        color[node] = GRAY
        for neighbor in graph[node]:
            if dfs(neighbor):
                return True
        color[node] = BLACK
        return False
    
    for node in graph:
        if color[node] == WHITE:
            if dfs(node):
                return True
    return False
```

#### Topological Sort
```python
def topological_sort(graph):
    in_degree = {node: 0 for node in graph}
    for node in graph:
        for neighbor in graph[node]:
            in_degree[neighbor] += 1
    
    queue = deque([n for n in in_degree if in_degree[n] == 0])
    result = []
    
    while queue:
        node = queue.popleft()
        result.append(node)
        
        for neighbor in graph[node]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)
    
    return result if len(result) == len(graph) else []
```

#### Dijkstra's Shortest Path
```python
def dijkstra(graph, start):
    import heapq
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    pq = [(0, start)]
    
    while pq:
        curr_dist, node = heapq.heappop(pq)
        
        if curr_dist > distances[node]:
            continue
        
        for neighbor, weight in graph[node]:
            distance = curr_dist + weight
            
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(pq, (distance, neighbor))
    
    return distances
```

#### Number of Islands (DFS)
```python
def num_islands(grid):
    if not grid:
        return 0
    
    count = 0
    
    def dfs(i, j):
        if (i < 0 or i >= len(grid) or 
            j < 0 or j >= len(grid[0]) or 
            grid[i][j] == '0'):
            return
        
        grid[i][j] = '0'  # Mark visited
        dfs(i+1, j)
        dfs(i-1, j)
        dfs(i, j+1)
        dfs(i, j-1)
    
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == '1':
                count += 1
                dfs(i, j)
    
    return count
```

---

## Tries

### Trie Implementation
```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()
    
    def insert(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True
    
    def search(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end
    
    def starts_with(self, prefix):
        node = self.root
        for char in prefix:
            if char not in node.children:
                return False
            node = node.children[char]
        return True
```

### Trie Problems

#### Word Search II
```python
def find_words(board, words):
    # Build trie
    trie = Trie()
    for word in words:
        trie.insert(word)
    
    result = set()
    
    def dfs(i, j, node, path):
        if node.is_end:
            result.add(path)
        
        if (i < 0 or i >= len(board) or 
            j < 0 or j >= len(board[0]) or 
            board[i][j] == '#'):
            return
        
        char = board[i][j]
        if char not in node.children:
            return
        
        board[i][j] = '#'  # Mark visited
        
        for di, dj in [(0,1), (1,0), (0,-1), (-1,0)]:
            dfs(i+di, j+dj, node.children[char], path+char)
        
        board[i][j] = char  # Restore
    
    for i in range(len(board)):
        for j in range(len(board[0])):
            dfs(i, j, trie.root, "")
    
    return list(result)
```

---

## Union-Find (Disjoint Set)

### Implementation
```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n
        self.count = n
    
    def find(self, x):
        # Path compression
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]
    
    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        
        if px == py:
            return False
        
        # Union by rank
        if self.rank[px] < self.rank[py]:
            self.parent[px] = py
        elif self.rank[px] > self.rank[py]:
            self.parent[py] = px
        else:
            self.parent[py] = px
            self.rank[px] += 1
        
        self.count -= 1
        return True
    
    def connected(self, x, y):
        return self.find(x) == self.find(y)
```

### Union-Find Problems

#### Number of Connected Components
```python
def count_components(n, edges):
    uf = UnionFind(n)
    for a, b in edges:
        uf.union(a, b)
    return uf.count
```

**💡 Interview Tip:** Use Union-Find for:
- Connected components
- Detecting cycles in undirected graphs
- Minimum spanning tree (Kruskal's)

---
## Sorting Algorithms

### Comparison of Sorting Algorithms
| Algorithm | Best | Average | Worst | Space | Stable |
|-----------|------|---------|-------|-------|--------|
| Bubble | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap | O(n log n) | O(n log n) | O(n log n) | O(1) | No |

### Built-in Sorting
```python
# In-place sort - O(n log n)
lst.sort()
lst.sort(reverse=True)
lst.sort(key=len)
lst.sort(key=lambda x: x[1])

# New sorted list
sorted_lst = sorted(lst)
sorted_lst = sorted(lst, key=lambda x: (x[0], -x[1]))
```

### Merge Sort
```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

### Quick Sort
```python
def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    
    return quick_sort(left) + middle + quick_sort(right)
```

---

## Dynamic Programming

### 1D DP Problems

#### Climbing Stairs
```python
def climb_stairs(n):
    if n <= 2:
        return n
    
    prev2, prev1 = 1, 2
    for i in range(3, n + 1):
        curr = prev1 + prev2
        prev2, prev1 = prev1, curr
    
    return prev1
```

#### House Robber
```python
def rob(nums):
    if not nums:
        return 0
    if len(nums) == 1:
        return nums[0]
    
    prev2 = prev1 = 0
    for num in nums:
        curr = max(prev1, prev2 + num)
        prev2, prev1 = prev1, curr
    
    return prev1
```

#### Longest Increasing Subsequence
```python
def length_of_lis(nums):
    if not nums:
        return 0
    
    dp = [1] * len(nums)
    
    for i in range(1, len(nums)):
        for j in range(i):
            if nums[i] > nums[j]:
                dp[i] = max(dp[i], dp[j] + 1)
    
    return max(dp)
```

#### Coin Change
```python
def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    
    for i in range(1, amount + 1):
        for coin in coins:
            if coin <= i:
                dp[i] = min(dp[i], dp[i - coin] + 1)
    
    return dp[amount] if dp[amount] != float('inf') else -1
```

### 2D DP Problems

#### Longest Common Subsequence
```python
def longest_common_subsequence(text1, text2):
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    
    return dp[m][n]
```

#### Edit Distance
```python
def min_distance(word1, word2):
    m, n = len(word1), len(word2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    for i in range(m + 1):
        dp[i][0] = i
    for j in range(n + 1):
        dp[0][j] = j
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i-1] == word2[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(
                    dp[i-1][j],      # Delete
                    dp[i][j-1],      # Insert
                    dp[i-1][j-1]     # Replace
                )
    
    return dp[m][n]
```

#### 0/1 Knapsack
```python
def knapsack(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for w in range(capacity + 1):
            if weights[i-1] <= w:
                dp[i][w] = max(
                    values[i-1] + dp[i-1][w - weights[i-1]],
                    dp[i-1][w]
                )
            else:
                dp[i][w] = dp[i-1][w]
    
    return dp[n][capacity]
```

**💡 DP Pattern Recognition:**
- Optimization problem (min/max)
- Count number of ways
- Overlapping subproblems
- Optimal substructure

---

## Backtracking

### Backtracking Template
```python
def backtrack(path, choices):
    if is_valid_solution(path):
        result.append(path.copy())
        return
    
    for choice in choices:
        # Make choice
        path.append(choice)
        
        # Recurse
        backtrack(path, get_next_choices())
        
        # Undo choice
        path.pop()
```

### Common Backtracking Problems

#### Subsets
```python
def subsets(nums):
    result = []
    
    def backtrack(start, path):
        result.append(path[:])
        
        for i in range(start, len(nums)):
            path.append(nums[i])
            backtrack(i + 1, path)
            path.pop()
    
    backtrack(0, [])
    return result
```

#### Permutations
```python
def permutations(nums):
    result = []
    
    def backtrack(path):
        if len(path) == len(nums):
            result.append(path[:])
            return
        
        for num in nums:
            if num not in path:
                path.append(num)
                backtrack(path)
                path.pop()
    
    backtrack([])
    return result
```

#### Combinations
```python
def combinations(n, k):
    result = []
    
    def backtrack(start, path):
        if len(path) == k:
            result.append(path[:])
            return
        
        for i in range(start, n + 1):
            path.append(i)
            backtrack(i + 1, path)
            path.pop()
    
    backtrack(1, [])
    return result
```

#### N-Queens
```python
def solve_n_queens(n):
    result = []
    board = [['.'] * n for _ in range(n)]
    
    def is_valid(row, col):
        # Check column
        for i in range(row):
            if board[i][col] == 'Q':
                return False
        
        # Check diagonals
        for i, j in zip(range(row-1, -1, -1), range(col-1, -1, -1)):
            if board[i][j] == 'Q':
                return False
        
        for i, j in zip(range(row-1, -1, -1), range(col+1, n)):
            if board[i][j] == 'Q':
                return False
        
        return True
    
    def backtrack(row):
        if row == n:
            result.append([''.join(r) for r in board])
            return
        
        for col in range(n):
            if is_valid(row, col):
                board[row][col] = 'Q'
                backtrack(row + 1)
                board[row][col] = '.'
    
    backtrack(0)
    return result
```

---

## Bit Manipulation

### Bit Operations
```python
# Basic operations
x & y      # AND
x | y      # OR
x ^ y      # XOR
~x         # NOT (flip bits)
x << n     # Left shift (multiply by 2^n)
x >> n     # Right shift (divide by 2^n)

# Check if bit is set
def is_bit_set(num, i):
    return (num & (1 << i)) != 0

# Set bit
def set_bit(num, i):
    return num | (1 << i)

# Clear bit
def clear_bit(num, i):
    return num & ~(1 << i)

# Toggle bit
def toggle_bit(num, i):
    return num ^ (1 << i)

# Count set bits
def count_bits(n):
    count = 0
    while n:
        n &= (n - 1)  # Clear rightmost set bit
        count += 1
    return count

# Or use built-in
bin(n).count('1')
```

### Common Bit Patterns

#### Single Number
```python
def single_number(nums):
    """Find number that appears once (others appear twice)"""
    result = 0
    for num in nums:
        result ^= num
    return result
```

#### Power of Two
```python
def is_power_of_two(n):
    return n > 0 and (n & (n - 1)) == 0
```

#### Missing Number
```python
def missing_number(nums):
    """Array contains [0, n] with one missing"""
    n = len(nums)
    return n * (n + 1) // 2 - sum(nums)

# Or using XOR
def missing_number_xor(nums):
    result = len(nums)
    for i, num in enumerate(nums):
        result ^= i ^ num
    return result
```

#### Reverse Bits
```python
def reverse_bits(n):
    result = 0
    for i in range(32):
        result = (result << 1) | (n & 1)
        n >>= 1
    return result
```

---

## Math & Number Theory

### GCD and LCM
```python
import math

# GCD
def gcd(a, b):
    while b:
        a, b = b, a % b
    return a

# Or built-in
math.gcd(a, b)

# LCM
def lcm(a, b):
    return (a * b) // gcd(a, b)

# Or Python 3.9+
math.lcm(a, b)
```

### Prime Numbers
```python
# Check prime
def is_prime(n):
    if n < 2:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

# Sieve of Eratosthenes
def sieve_of_eratosthenes(n):
    primes = [True] * (n + 1)
    primes[0] = primes[1] = False
    
    for i in range(2, int(n**0.5) + 1):
        if primes[i]:
            for j in range(i*i, n + 1, i):
                primes[j] = False
    
    return [i for i in range(n + 1) if primes[i]]
```

### Factorial & Combinations
```python
import math

# Factorial
math.factorial(n)

# Combinations C(n, k)
math.comb(n, k)

# Permutations P(n, k)
math.perm(n, k)
```

### Power & Modulo
```python
# Power
pow(base, exp)
pow(base, exp, mod)  # (base^exp) % mod

# Modular exponentiation
def mod_pow(base, exp, mod):
    result = 1
    base %= mod
    
    while exp > 0:
        if exp % 2 == 1:
            result = (result * base) % mod
        exp //= 2
        base = (base * base) % mod
    
    return result
```

---

## Coding Patterns Decision Guide

### Pattern Selection Flowchart

#### 1. **Two Pointers** ✅
**Use when:**
- Sorted array/list problems
- Finding pairs with specific sum
- Removing duplicates
- Palindrome checking
- Merging sorted arrays

**Don't use when:**
- Unsorted data
- Need random access
- Complex relationships between elements

#### 2. **Sliding Window** ✅
**Use when:**
- Subarray/substring problems
- Fixed or variable window size
- Find min/max in window
- Count subarrays meeting criteria

**Don't use when:**
- Need complete array
- Non-contiguous elements
- Complex dependencies

#### 3. **Fast & Slow Pointers** ✅
**Use when:**
- Linked list cycle detection
- Finding middle of linked list
- Palindrome linked list

#### 4. **Merge Intervals** ✅
**Use when:**
- Overlapping intervals
- Meeting rooms
- Insert interval
- Calendar problems

#### 5. **Cyclic Sort** ✅
**Use when:**
- Array with numbers 1 to n
- Finding missing/duplicate numbers
- In-place sorting required

#### 6. **In-place Reversal of Linked List** ✅
**Use when:**
- Reversing linked list
- Reversing sublist
- Palindrome linked list

#### 7. **BFS (Breadth-First Search)** ✅
**Use when:**
- Shortest path (unweighted)
- Level-order traversal
- Minimum steps/moves
- All nodes at distance k

#### 8. **DFS (Depth-First Search)** ✅
**Use when:**
- All paths/solutions
- Connected components
- Topological sort
- Detecting cycles

#### 9. **Two Heaps** ✅
**Use when:**
- Find median in stream
- Sliding window median
- Scheduling with priority

#### 10. **Top K Elements** ✅
**Use when:**
- K largest/smallest elements
- K frequent elements
- K closest points

#### 11. **Binary Search** ✅
**Use when:**
- Sorted array search
- Search in rotated array
- Find peak element
- Search 2D matrix

#### 12. **Backtracking** ✅
**Use when:**
- Generate all combinations/permutations
- Sudoku solver
- N-Queens
- Word search

#### 13. **Dynamic Programming** ✅
**Use when:**
- Optimization problems (min/max)
- Count number of ways
- Overlapping subproblems
- Optimal substructure

**Identify by:**
- "Maximum/minimum" → optimization
- "How many ways" → counting
- Subproblems repeat → overlapping

#### 14. **Greedy** ✅
**Use when:**
- Local optimum leads to global optimum
- Interval scheduling
- Huffman coding
- Minimum coins

**Don't use when:**
- Need global view
- Future choices affect past

---

## Time & Space Complexity

### Big-O Notation
| Complexity | Name | Example |
|------------|------|---------|
| O(1) | Constant | Array access, hash lookup |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Linear search, traversal |
| O(n log n) | Linearithmic | Merge sort, heap sort |
| O(n²) | Quadratic | Nested loops, bubble sort |
| O(n³) | Cubic | Triple nested loops |
| O(2ⁿ) | Exponential | Recursive Fibonacci |
| O(n!) | Factorial | Permutations |

### Common Data Structure Operations
| Structure | Access | Search | Insert | Delete |
|-----------|--------|--------|--------|--------|
| Array | O(1) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1)* | O(1)* |
| Hash Table | O(1) | O(1) | O(1) | O(1) |
| Binary Search Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | O(1)** | O(n) | O(log n) | O(log n) |

*With reference to node
**Access to min/max only

### Complexity Analysis Examples
```python
# O(n) - Linear
def linear_search(arr, target):
    for num in arr:  # n iterations
        if num == target:
            return True
    return False

# O(log n) - Logarithmic
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:  # log n iterations
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# O(n²) - Quadratic
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):  # n iterations
        for j in range(n - i - 1):  # n iterations
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]

# O(n log n) - Linearithmic
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])  # log n levels
    right = merge_sort(arr[mid:])
    return merge(left, right)  # n work per level
```

---

## Common Interview Questions

### Easy Level

1. **Two Sum**
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

2. **Valid Parentheses**
```python
def is_valid(s):
    stack = []
    pairs = {'(': ')', '[': ']', '{': '}'}
    for char in s:
        if char in pairs:
            stack.append(char)
        elif not stack or pairs[stack.pop()] != char:
            return False
    return not stack
```

3. **Merge Two Sorted Lists**
```python
def merge_two_lists(l1, l2):
    dummy = ListNode(0)
    curr = dummy
    
    while l1 and l2:
        if l1.val < l2.val:
            curr.next = l1
            l1 = l1.next
        else:
            curr.next = l2
            l2 = l2.next
        curr = curr.next
    
    curr.next = l1 or l2
    return dummy.next
```

### Medium Level

4. **3Sum**
```python
def three_sum(nums):
    nums.sort()
    result = []
    
    for i in range(len(nums) - 2):
        if i > 0 and nums[i] == nums[i-1]:
            continue
        
        left, right = i + 1, len(nums) - 1
        while left < right:
            total = nums[i] + nums[left] + nums[right]
            
            if total == 0:
                result.append([nums[i], nums[left], nums[right]])
                while left < right and nums[left] == nums[left+1]:
                    left += 1
                while left < right and nums[right] == nums[right-1]:
                    right -= 1
                left += 1
                right -= 1
            elif total < 0:
                left += 1
            else:
                right -= 1
    
    return result
```

5. **Product of Array Except Self**
```python
def product_except_self(nums):
    n = len(nums)
    result = [1] * n
    
    # Left products
    left = 1
    for i in range(n):
        result[i] = left
        left *= nums[i]
    
    # Right products
    right = 1
    for i in range(n - 1, -1, -1):
        result[i] *= right
        right *= nums[i]
    
    return result
```

### Hard Level

6. **Median of Two Sorted Arrays**
```python
def find_median_sorted_arrays(nums1, nums2):
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1
    
    m, n = len(nums1), len(nums2)
    left, right = 0, m
    
    while left <= right:
        partition1 = (left + right) // 2
        partition2 = (m + n + 1) // 2 - partition1
        
        max_left1 = float('-inf') if partition1 == 0 else nums1[partition1-1]
        min_right1 = float('inf') if partition1 == m else nums1[partition1]
        
        max_left2 = float('-inf') if partition2 == 0 else nums2[partition2-1]
        min_right2 = float('inf') if partition2 == n else nums2[partition2]
        
        if max_left1 <= min_right2 and max_left2 <= min_right1:
            if (m + n) % 2 == 0:
                return (max(max_left1, max_left2) + min(min_right1, min_right2)) / 2
            else:
                return max(max_left1, max_left2)
        elif max_left1 > min_right2:
            right = partition1 - 1
        else:
            left = partition1 + 1
```

---

## Interview Tips & Strategies

### Before the Interview
1. **Review fundamentals**: Data structures, algorithms, time complexity
2. **Practice coding**: LeetCode, HackerRank (50-100 problems)
3. **Mock interviews**: Pramp, interviewing.io
4. **Know your resume**: Be ready to discuss projects in detail

### During the Interview

#### Step 1: Understand the Problem (5 min)
```
✓ Ask clarifying questions
✓ Confirm input/output format
✓ Ask about edge cases
✓ Confirm constraints (time, space)
✓ Ask about duplicates, negative numbers, etc.
```

#### Step 2: Plan the Approach (10 min)
```
✓ Discuss brute force first
✓ Optimize gradually
✓ Explain trade-offs
✓ Get interviewer's buy-in before coding
```

#### Step 3: Code the Solution (20 min)
```
✓ Write clean, readable code
✓ Use meaningful variable names
✓ Comment complex logic
✓ Handle edge cases
```

#### Step 4: Test Your Code (5 min)
```
✓ Walk through with example input
✓ Test edge cases
✓ Check for off-by-one errors
✓ Verify time/space complexity
```

### Communication Tips
- **Think out loud**: Explain your thought process
- **Ask questions**: Clarify ambiguities
- **Be honest**: If stuck, say so and ask for hints
- **Consider alternatives**: Discuss multiple approaches
- **Handle hints**: Use them productively

### Red Flags to Avoid
- ❌ Jumping straight to code
- ❌ Silent coding
- ❌ Giving up quickly
- ❌ Not testing your code
- ❌ Dismissing interviewer's hints

### What Interviewers Look For
1. **Problem-solving ability**: Can you break down problems?
2. **Coding skills**: Can you translate ideas to code?
3. **Communication**: Can you explain your thinking?
4. **Testing**: Do you verify your solution?
5. **Optimization**: Can you improve your approach?

### Common Mistakes
1. Not asking clarifying questions
2. Rushing to code without planning
3. Not considering edge cases
4. Poor variable naming
5. Not analyzing complexity
6. Giving up too easily

### Time Management
| Phase | Time |
|-------|------|
| Understanding | 5 min |
| Planning | 10 min |
| Coding | 20 min |
| Testing | 5 min |
| **Total** | **40 min** |

### Problem-Solving Framework

**1. UMPIRE Method**
- **U**nderstand
- **M**atch pattern
- **P**lan
- **I**mplement
- **R**eview
- **E**valuate

**2. Pattern Recognition**
```
Input type → Pattern
- Array/String → Two Pointers, Sliding Window
- Linked List → Fast/Slow Pointers
- Tree/Graph → DFS/BFS
- Sorted Array → Binary Search
- Optimization → DP or Greedy
- Permutations → Backtracking
```

---

## Quick Reference Cheat Sheet

### Essential Python Snippets
```python
# Sort with custom key
sorted(arr, key=lambda x: (x[0], -x[1]))

# Counter most common
Counter(arr).most_common(k)

# DefaultDict
dd = defaultdict(list)

# Heap operations
heapq.heappush(heap, item)
heapq.heappop(heap)
heapq.nlargest(k, arr)

# Binary search
bisect_left(arr, target)

# String reverse
s[::-1]

# All subsets
from itertools import combinations
list(combinations(arr, k))

# Deep copy
from copy import deepcopy
new_list = deepcopy(old_list)

# Infinity
float('inf')
float('-inf')

# Range
range(start, stop, step)
range(5, 0, -1)  # [5, 4, 3, 2, 1]
```

### Common Gotchas
```python
# ❌ Wrong: Shallow copy of 2D array
matrix = [[0] * 3] * 3

# ✓ Correct: Deep copy
matrix = [[0] * 3 for _ in range(3)]

# ❌ Wrong: Mutable default argument
def func(arr=[]):
    arr.append(1)

# ✓ Correct
def func(arr=None):
    if arr is None:
        arr = []

# ❌ Wrong: Integer division in Python 2
5 / 2  # 2 in Python 2

# ✓ Correct: Use // for integer division
5 // 2  # 2 in both versions
```

---

## Final Checklist

### Before Interview
- [ ] Review this guide
- [ ] Solve 5-10 practice problems
- [ ] Test your webcam/mic
- [ ] Prepare questions for interviewer
- [ ] Have pen and paper ready

### During Interview
- [ ] Ask clarifying questions
- [ ] Discuss approach before coding
- [ ] Write clean, readable code
- [ ] Test with examples
- [ ] Analyze time/space complexity

### After Interview
- [ ] Send thank-you email
- [ ] Reflect on performance
- [ ] Note questions asked
- [ ] Continue practicing

---

**Good luck with your Python interviews! 🚀**

Remember: Interviewers want to see your thought process, not just the final solution. Communication and problem-solving approach are as important as getting the right answer.