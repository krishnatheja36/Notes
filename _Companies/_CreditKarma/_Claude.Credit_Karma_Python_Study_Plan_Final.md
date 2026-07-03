# Credit Karma — Python Coding Round Study Plan

**Round:** Technical Coding (Python only) — CoderPad
**Format:** Collaborative — explain your thinking, have a conversation
**Interview:** Wednesday May 27, 2:00 PM
**Key advice from Boris:** Explain as you go, be collaborative, not just solve and submit

---

> Tracking: see `_Claude.Credit_Karma_Tracking.md` for the battle plan and checklist.

---

## Problem Set Overview

| #  | Problem                        | Pattern            | Difficulty | Priority  |
| -- | ------------------------------ | ------------------ | ---------- | --------- |
| 1  | The Brackets Problem           | Stack              | Easy       | 🔴 High   |
| 2  | Check Matching Parentheses     | Stack              | Medium     | 🔴 High   |
| 3  | Merge Sorted Lists             | Two Pointers       | Easy       | 🔴 High   |
| 4  | Find the Missing Number        | Math/Hash Map      | Easy       | 🔴 High   |
| 5  | Rectangle Overlap              | Intervals/Math     | Easy       | 🔴 High   |
| 6  | String Mapping                 | Hash Map           | Easy       | 🔴 High   |
| 7  | Append Frequency               | Hash Map + String  | Medium     | 🟡 Medium |
| 8  | Level of Rain Water            | Stack/DP           | Medium     | 🟡 Medium |
| 9  | Robot Grid (Unique Paths)      | DP                 | Medium     | 🔴 High   |
| 10 | Bank Account (OOP)             | OOP                | Medium     | 🔴 High   |
| 11 | Number of Islands              | Graph/BFS/DFS      | Medium     | 🔴 High   |
| 12 | Even/Odd Ordering              | Array/Two Pointers | Easy       | 🔴 High   |
| 13 | Dynamic Programming (General)  | DP                 | Medium     | 🟡 Medium |
| 14 | Add Two Numbers (Strings)      | String/Math        | Easy       | 🔴 High   |
| 15 | Reverse String / Palindrome    | String             | Easy       | 🔴 High   |
| 16 | FizzBuzz / CreditKarma variant | String/Math        | Easy       | 🔴 High   |
| 17 | Reverse Linked List            | Linked List        | Easy       | 🔴 High   |
| 18 | Add Two Numbers (Linked List)  | Linked List        | Medium     | 🔴 High   |
| 19 | Validate Binary Search Tree    | Tree/DFS           | Medium     | 🔴 High   |
| 20 | Maximum Depth of Binary Tree   | Tree/DFS           | Easy       | 🔴 High   |
| 21 | Clone Undirected Graph         | Graph/BFS          | Medium     | 🟡 Medium |
| 22 | Top K Frequent Elements        | Heap/Hash Map      | Medium     | 🔴 High   |
| 23 | Merge Intervals                | Intervals          | Medium     | 🔴 High   |
| 24 | Prime to N                     | Math/Sieve         | Medium     | 🟢 Lower  |

---

## How This Round Works (Critical Context)

Boris said: **"Explain and have a conversation during this round. Be collaborative."**

This means:

- ✅ Talk through your approach BEFORE coding
- ✅ Ask clarifying questions
- ✅ Think out loud while coding
- ✅ Explain edge cases as you handle them
- ✅ After solving, discuss time/space complexity
- ✅ Suggest improvements even if you don't implement them

**This is NOT a "heads down and code" round.** It's a conversation.

---

---

# 📚 START HERE — Python Fundamentals (~2–3 hrs, Night 1 Phase 1)

---

## Part 0: Python Fundamentals (Software Engineering Essentials)

**Read this first. Credit Karma said "Software Engineering Fundamentals" three times in their email. This section covers exactly what they mean.**

---

### 0.1 Decorators

A decorator is a function that wraps another function to add behavior before or after it runs, without changing the original function.

**Think of it as:** A wrapper around a gift. The gift (function) is unchanged, but the wrapper (decorator) adds something around it.

```python
# Basic decorator structure
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Before the function runs")
        result = func(*args, **kwargs)   # call the original function
        print("After the function runs")
        return result
    return wrapper

@my_decorator
def say_hello(name):
    print(f"Hello {name}")

say_hello("Krishna")
# Output:
# Before the function runs
# Hello Krishna
# After the function runs
```

**What `@my_decorator` actually does:**

```python
# These two are identical:
@my_decorator
def say_hello(name):
    print(f"Hello {name}")

# is the same as:
def say_hello(name):
    print(f"Hello {name}")
say_hello = my_decorator(say_hello)   # wrap the function
```

**Real-world example (timing a function):**

```python
import time

def timer(func):
    def wrapper(*args, **kwargs):
        start  = time.time()
        result = func(*args, **kwargs)
        end    = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timer
def process_data(n):
    return sum(range(n))

process_data(1000000)
# Output: process_data took 0.0342 seconds
```

**Built-in decorators you must know:**

```python
class Pipeline:
    pipeline_count = 0    # class variable
  
    def __init__(self, name):
        self.name = name
        Pipeline.pipeline_count += 1
  
    @property
    def info(self):
        """Access like an attribute, not a method call."""
        return f"Pipeline: {self.name}"
  
    @staticmethod
    def validate_name(name):
        """No access to self or class. Pure utility function."""
        return len(name) > 0
  
    @classmethod
    def get_count(cls):
        """Access to class, not instance. Factory methods use this."""
        return cls.pipeline_count


p = Pipeline("ETL")
print(p.info)                    # Pipeline: ETL (no parentheses!)
print(Pipeline.validate_name("ETL"))  # True
print(Pipeline.get_count())      # 1
```

**`@abstractmethod` — Force subclasses to implement a method:**

```python
from abc import ABC, abstractmethod

class DataPipeline(ABC):
    """Abstract base class — cannot be instantiated directly."""
  
    @abstractmethod
    def extract(self) -> list:
        """Every subclass MUST implement this."""
        pass
  
    @abstractmethod
    def transform(self, data: list) -> list:
        pass
  
    def run(self):
        """Concrete method that calls the abstract ones."""
        data = self.extract()
        return self.transform(data)


class SparkPipeline(DataPipeline):
    def extract(self) -> list:
        return [1, 2, 3]
  
    def transform(self, data: list) -> list:
        return [x * 2 for x in data]


# DataPipeline()   # TypeError: Can't instantiate abstract class
p = SparkPipeline()
print(p.run())    # [2, 4, 6]
```

**`@abstractmethod` vs `raise NotImplementedError`:**

```
@abstractmethod  - Enforced at class instantiation — you can't even create the object
                   if a required method is missing. Clear contract.

raise NotImplementedError - Enforced at call time — object is created fine,
                            error only happens when the method is actually called.

Use @abstractmethod when you want to guarantee the interface is complete.
```

**When to use each:**

```
@property        - When you want a method that behaves like an attribute
@staticmethod    - Utility function related to the class but needs no self/cls
@classmethod     - Factory methods, or when you need access to the class itself
@abstractmethod  - Force subclasses to implement specific methods (with ABC)
```

---

#### @classmethod Deep Dive

A `@classmethod` receives the **class itself** (`cls`) as its first argument instead of the instance (`self`). This means it can access and modify class-level state, and it works correctly through inheritance.

**`self` vs `cls` — the key difference:**

```python
class Pipeline:
    default_timeout = 30    # class variable

    def __init__(self, name):
        self.name = name     # instance variable

    def instance_method(self):
        # self = the specific Pipeline object
        print(f"Instance: {self.name}")

    @classmethod
    def class_method(cls):
        # cls = the Pipeline class itself (or subclass if inherited)
        print(f"Class timeout: {cls.default_timeout}")

    @staticmethod
    def static_method():
        # neither self nor cls — pure utility
        print("No access to instance or class")
```

---

**Primary Use Case: Factory Methods**

The most common reason to use `@classmethod` is to provide alternative constructors — multiple ways to create an object from different input formats.

```python
class Pipeline:
    def __init__(self, name: str, source: str, target: str, schedule: str):
        self.name     = name
        self.source   = source
        self.target   = target
        self.schedule = schedule

    @classmethod
    def from_dict(cls, config: dict):
        """Create a Pipeline from a config dictionary."""
        return cls(
            name     = config['name'],
            source   = config['source'],
            target   = config['target'],
            schedule = config.get('schedule', 'daily')
        )

    @classmethod
    def from_string(cls, config_str: str):
        """Create a Pipeline from a 'name:source:target' string."""
        parts = config_str.split(':')
        return cls(name=parts[0], source=parts[1], target=parts[2], schedule='daily')

    def __repr__(self):
        return f"Pipeline({self.name}, {self.source} → {self.target}, {self.schedule})"


# Three ways to create the same type of object
p1 = Pipeline("ETL", "oracle", "hive", "daily")

p2 = Pipeline.from_dict({
    'name': 'ETL', 'source': 'oracle', 'target': 'hive'
})

p3 = Pipeline.from_string("ETL:oracle:hive")

print(p1)   # Pipeline(ETL, oracle → hive, daily)
print(p2)   # Pipeline(ETL, oracle → hive, daily)
print(p3)   # Pipeline(ETL, oracle → hive, daily)
```

**Why `cls(...)` instead of `Pipeline(...)`:**

- If a subclass calls `SparkPipeline.from_dict(config)`, `cls` is `SparkPipeline` — it creates the right type automatically.
- Hardcoding `Pipeline(...)` would break in subclasses.

---

**`@classmethod` with Inheritance**

```python
class Animal:
    sound = "..."

    def __init__(self, name: str):
        self.name = name

    @classmethod
    def create(cls, name: str):
        """Factory that always creates the correct subclass."""
        return cls(name)

    def speak(self):
        return f"{self.name} says {self.sound}"


class Dog(Animal):
    sound = "Woof"

class Cat(Animal):
    sound = "Meow"


# cls is Dog here, not Animal — creates a Dog object
d = Dog.create("Rex")
c = Cat.create("Whiskers")

print(d.speak())   # Rex says Woof
print(c.speak())   # Whiskers says Meow

print(type(d))     # <class '__main__.Dog'>  ← correct type!
```

---

**`@classmethod` for Class-Level State**

```python
class DatabaseConnection:
    _instance_count = 0    # shared across all instances

    def __init__(self, host: str):
        self.host = host
        DatabaseConnection._instance_count += 1

    @classmethod
    def get_instance_count(cls) -> int:
        return cls._instance_count

    @classmethod
    def reset_count(cls) -> None:
        cls._instance_count = 0


db1 = DatabaseConnection("prod-db")
db2 = DatabaseConnection("staging-db")

print(DatabaseConnection.get_instance_count())   # 2
DatabaseConnection.reset_count()
print(DatabaseConnection.get_instance_count())   # 0
```

---

**`@classmethod` vs `@staticmethod` — When to Choose**

```python
class DateUtils:

    @staticmethod
    def is_leap_year(year: int) -> bool:
        """No class needed — pure calculation."""
        return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

    @classmethod
    def today(cls):
        """Uses cls so subclasses can override behavior."""
        from datetime import date
        return cls(date.today().year, date.today().month, date.today().day)
```

```
Use @staticmethod when:
  - The function doesn't need self OR cls
  - It's a pure utility (validation, formatting, calculation)
  - You'd write it as a standalone function but it belongs with the class

Use @classmethod when:
  - You need to call cls(...) to create an instance (factory method)
  - You need to read or modify a class variable
  - The method should work correctly when called on a subclass
```

---

**Calling a classmethod — three equivalent ways:**

```python
class Config:
    env = "prod"

    @classmethod
    def get_env(cls) -> str:
        return cls.env

# All three call the same method:
print(Config.get_env())           # via the class — most common
c = Config()
print(c.get_env())                # via an instance — works but unusual
print(Config.get_env.__func__(Config))  # explicit — never do this
```

**`@classmethod` chaining (builder pattern):**

```python
class QueryBuilder:
    def __init__(self):
        self._table  = ""
        self._where  = []
        self._limit  = None

    @classmethod
    def select(cls, table: str):
        """Entry point — returns a new builder."""
        builder = cls()
        builder._table = table
        return builder

    def where(self, condition: str):
        self._where.append(condition)
        return self    # enables chaining

    def limit(self, n: int):
        self._limit = n
        return self

    def build(self) -> str:
        q = f"SELECT * FROM {self._table}"
        if self._where:
            q += " WHERE " + " AND ".join(self._where)
        if self._limit:
            q += f" LIMIT {self._limit}"
        return q


# Fluent interface using classmethod as entry point
query = (QueryBuilder.select("users")
                     .where("age > 18")
                     .where("active = true")
                     .limit(10)
                     .build())

print(query)
# SELECT * FROM users WHERE age > 18 AND active = true LIMIT 10
```

---

### 0.2 OOP - Four Pillars

**1. Encapsulation - Hide internal data, expose only what's needed**

```python
class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner    = owner          # public
        self._balance = balance        # protected (convention: don't touch from outside)
        self.__pin    = 1234           # private (name mangled, hard to access)
  
    def deposit(self, amount: float) -> float:
        """Public interface to modify private data."""
        if amount <= 0:
            raise ValueError("Amount must be positive")
        self._balance += amount
        return self._balance
  
    def get_balance(self) -> float:
        """Controlled read access."""
        return self._balance
  
    # Using @property for cleaner access
    @property
    def balance(self) -> float:
        return self._balance

acc = BankAccount("Krishna", 1000)
print(acc.balance)       # 1000  (via property)
print(acc._balance)      # 1000  (works but bad practice)
print(acc.__pin)         # AttributeError! name mangled to _BankAccount__pin
```

**2. Inheritance - Reuse and extend behavior**

```python
class DataPipeline:
    """Base class for all pipelines."""
  
    def __init__(self, name: str, source: str):
        self.name   = name
        self.source = source
  
    def extract(self):
        print(f"Extracting from {self.source}")
  
    def run(self):
        """Template method - defines the skeleton."""
        self.extract()
        self.transform()
        self.load()
  
    def transform(self):
        raise NotImplementedError("Subclass must implement transform")
  
    def load(self):
        raise NotImplementedError("Subclass must implement load")


class SparkPipeline(DataPipeline):
    """Inherits from DataPipeline, adds Spark-specific behavior."""
  
    def __init__(self, name: str, source: str, partitions: int):
        super().__init__(name, source)   # call parent __init__
        self.partitions = partitions
  
    def transform(self):
        print(f"Transforming with Spark, {self.partitions} partitions")
  
    def load(self):
        print(f"Loading to data lake")


pipeline = SparkPipeline("ETL", "oracle", 100)
pipeline.run()
# Extracting from oracle
# Transforming with Spark, 100 partitions
# Loading to data lake
```

**3. Polymorphism - Same interface, different behavior**

```python
class Animal:
    def speak(self) -> str:
        raise NotImplementedError

class Dog(Animal):
    def speak(self) -> str:
        return "Woof"

class Cat(Animal):
    def speak(self) -> str:
        return "Meow"

class Duck(Animal):
    def speak(self) -> str:
        return "Quack"

# Polymorphism: same call, different behavior
animals = [Dog(), Cat(), Duck()]
for animal in animals:
    print(animal.speak())    # Woof, Meow, Quack

# Real-world example: different data sources, same interface
class DataSource:
    def read(self) -> list:
        raise NotImplementedError

class OracleSource(DataSource):
    def read(self) -> list:
        print("Reading from Oracle")
        return []

class KafkaSource(DataSource):
    def read(self) -> list:
        print("Reading from Kafka")
        return []

class S3Source(DataSource):
    def read(self) -> list:
        print("Reading from S3")
        return []

# Same code works for all sources
sources = [OracleSource(), KafkaSource(), S3Source()]
for source in sources:
    data = source.read()     # polymorphic call
```

**4. Abstraction - Hide complexity, expose only what's needed**

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    """Abstract base class - cannot be instantiated directly."""
  
    @abstractmethod
    def area(self) -> float:
        """Subclasses MUST implement this."""
        pass
  
    @abstractmethod
    def perimeter(self) -> float:
        pass
  
    def describe(self) -> str:
        """Concrete method using abstract methods."""
        return f"Area: {self.area():.2f}, Perimeter: {self.perimeter():.2f}"


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius
  
    def area(self) -> float:
        return 3.14159 * self.radius ** 2
  
    def perimeter(self) -> float:
        return 2 * 3.14159 * self.radius


class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width  = width
        self.height = height
  
    def area(self) -> float:
        return self.width * self.height
  
    def perimeter(self) -> float:
        return 2 * (self.width + self.height)


# Shape()        # TypeError: Can't instantiate abstract class
circle = Circle(5)
rect   = Rectangle(4, 6)
print(circle.describe())    # Area: 78.54, Perimeter: 31.42
print(rect.describe())      # Area: 24.00, Perimeter: 20.00
```

---

### 0.3 Error Handling

```python
# Basic try/except
def divide(a, b):
    try:
        result = a / b
    except ZeroDivisionError:
        print("Cannot divide by zero")
        return None
    except TypeError as e:
        print(f"Wrong type: {e}")
        return None
    else:
        print("Division successful")  # runs only if NO exception
        return result
    finally:
        print("Always runs")          # cleanup, always executes

divide(10, 2)   # Division successful, Always runs -> 5.0
divide(10, 0)   # Cannot divide by zero, Always runs -> None
```

**Multiple exceptions and custom exceptions:**

```python
# Catch multiple in one line
except (TypeError, ValueError) as e:
    print(f"Error: {e}")

# Custom exception
class InsufficientFundsError(Exception):
    def __init__(self, amount: float, balance: float):
        self.amount  = amount
        self.balance = balance
        super().__init__(f"Cannot withdraw {amount:.2f}, balance is {balance:.2f}")

def withdraw(amount: float, balance: float) -> float:
    if amount <= 0:
        raise ValueError("Withdrawal amount must be positive")
    if amount > balance:
        raise InsufficientFundsError(amount, balance)
    return balance - amount

try:
    withdraw(500, 100)
except InsufficientFundsError as e:
    print(e)    # Cannot withdraw 500.00, balance is 100.00
except ValueError as e:
    print(e)
```

---

### 0.4 Lambda Functions (Deep Dive)

A lambda is a small anonymous function. It's defined in one line and used where you need a simple function without formally naming it.

**Basic syntax:**

```python
lambda arguments: expression

# Regular function:
def square(x):
    return x ** 2

# Equivalent lambda:
square = lambda x: x ** 2

print(square(5))    # 25
```

**Multiple arguments:**

```python
add      = lambda x, y: x + y
multiply = lambda x, y, z: x * y * z

print(add(3, 4))           # 7
print(multiply(2, 3, 4))   # 24
```

**Where lambdas shine - sorting:**

```python
# Sort list of tuples by second element
pairs = [(1, 'banana'), (3, 'apple'), (2, 'cherry')]
pairs.sort(key=lambda x: x[1])    # sort by fruit name
print(pairs)   # [(3, 'apple'), (1, 'banana'), (2, 'cherry')]

# Sort by string length
words = ['banana', 'apple', 'fig', 'cherry']
words.sort(key=lambda w: len(w))
print(words)   # ['fig', 'apple', 'banana', 'cherry']

# Sort list of dicts by a key
people = [
    {'name': 'Krishna', 'age': 32},
    {'name': 'Alice',   'age': 28},
    {'name': 'Bob',     'age': 35}
]
people.sort(key=lambda p: p['age'])
print(people)   # Alice(28), Krishna(32), Bob(35)

# Sort by multiple keys
people.sort(key=lambda p: (p['age'], p['name']))

# Reverse sort
people.sort(key=lambda p: p['age'], reverse=True)
```

**Lambda with map() - apply function to every element:**

```python
# Without lambda (verbose)
numbers = [1, 2, 3, 4, 5]
doubled = list(map(lambda x: x * 2, numbers))
print(doubled)   # [2, 4, 6, 8, 10]

# More examples
words    = ['hello', 'world']
upper    = list(map(lambda w: w.upper(), words))
lengths  = list(map(lambda w: len(w), words))

# With multiple lists
a = [1, 2, 3]
b = [4, 5, 6]
sums = list(map(lambda x, y: x + y, a, b))
print(sums)   # [5, 7, 9]
```

**Lambda with filter() - keep elements that pass a test:**

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

evens    = list(filter(lambda x: x % 2 == 0, numbers))
odds     = list(filter(lambda x: x % 2 != 0, numbers))
big_nums = list(filter(lambda x: x > 5, numbers))

print(evens)     # [2, 4, 6, 8, 10]
print(big_nums)  # [6, 7, 8, 9, 10]

# Filter objects
people = [
    {'name': 'Krishna', 'age': 32},
    {'name': 'Alice',   'age': 16},
    {'name': 'Bob',     'age': 25}
]
adults = list(filter(lambda p: p['age'] >= 18, people))
print(adults)   # Krishna and Bob only
```

**Lambda with sorted() - non-destructive sort:**

```python
# sorted() returns new list, sort() modifies in place
numbers  = [3, 1, 4, 1, 5, 9, 2, 6]
sorted_n = sorted(numbers, key=lambda x: -x)   # descending
print(numbers)    # [3, 1, 4, 1, 5, 9, 2, 6]  unchanged!
print(sorted_n)   # [9, 6, 5, 4, 3, 2, 1, 1]
```

**Lambda with reduce() - fold list into single value:**

```python
from functools import reduce

numbers = [1, 2, 3, 4, 5]

product = reduce(lambda x, y: x * y, numbers)
print(product)   # 120 (1*2*3*4*5)

maximum = reduce(lambda x, y: x if x > y else y, numbers)
print(maximum)   # 5

# Flatten a list of lists
nested  = [[1,2], [3,4], [5,6]]
flat    = reduce(lambda x, y: x + y, nested)
print(flat)   # [1, 2, 3, 4, 5, 6]
```

**When to use lambda vs regular function:**

```python
# USE lambda: simple, one-line, used once, usually as argument
pairs.sort(key=lambda x: x[1])

# USE regular function: complex logic, reused, needs docstring
def get_sort_key(person: dict) -> tuple:
    """Sort by age then name for stable ordering."""
    return (person['age'], person['name'])

people.sort(key=get_sort_key)
```

**Lambda gotcha - in loops:**

```python
# WRONG: all lambdas capture the same i
funcs = [lambda x: x + i for i in range(3)]
print([f(0) for f in funcs])   # [2, 2, 2] not [0, 1, 2]!

# CORRECT: capture i at definition time
funcs = [lambda x, i=i: x + i for i in range(3)]
print([f(0) for f in funcs])   # [0, 1, 2]
```

---

### 0.5 map(), filter() and zip() (Deep Dive)

These are built-in Python functions that apply operations to iterables. They return **iterator objects** — wrap with `list()` to see the values.

---

#### **map() — Apply a Function to Every Element**

```
map(function, iterable)

Think of it as: "For every item in the list, apply this function"
```

**Basic usage:**

```python
numbers = [1, 2, 3, 4, 5]

# Without map (verbose)
doubled = []
for n in numbers:
    doubled.append(n * 2)

# With map (clean)
doubled = list(map(lambda x: x * 2, numbers))
print(doubled)   # [2, 4, 6, 8, 10]
```

**With a named function:**

```python
def square(x):
    return x ** 2

numbers = [1, 2, 3, 4, 5]
squared = list(map(square, numbers))
print(squared)   # [1, 4, 9, 16, 25]

# With built-in functions
words = ['hello', 'world', 'python']
upper = list(map(str.upper, words))   # no lambda needed
lens  = list(map(len, words))

print(upper)   # ['HELLO', 'WORLD', 'PYTHON']
print(lens)    # [5, 5, 6]
```

**With multiple iterables:**

```python
# map() can take multiple iterables
a = [1, 2, 3]
b = [4, 5, 6]

sums     = list(map(lambda x, y: x + y, a, b))
products = list(map(lambda x, y: x * y, a, b))

print(sums)      # [5, 7, 9]
print(products)  # [4, 10, 18]

# Built-in with multiple iterables
maxes = list(map(max, a, b))
print(maxes)     # [4, 5, 6]
```

**Real-world examples:**

```python
# Convert strings to integers
str_nums = ['1', '2', '3', '4', '5']
integers = list(map(int, str_nums))
print(integers)   # [1, 2, 3, 4, 5]

# Convert integers to strings
nums    = [1, 2, 3, 4, 5]
strings = list(map(str, nums))
print(strings)    # ['1', '2', '3', '4', '5']

# Process a list of dicts
users = [
    {'name': 'Krishna', 'age': 32},
    {'name': 'Alice',   'age': 28},
    {'name': 'Bob',     'age': 35}
]

names = list(map(lambda u: u['name'], users))
ages  = list(map(lambda u: u['age'],  users))

print(names)   # ['Krishna', 'Alice', 'Bob']
print(ages)    # [32, 28, 35]

# Clean/normalize data
raw_data = ['  hello  ', ' world ', '  python  ']
cleaned  = list(map(str.strip, raw_data))
print(cleaned)   # ['hello', 'world', 'python']

# Apply multiple transformations
pipeline = [str.strip, str.lower, str.title]
text = '  hello world  '
for transform in pipeline:
    text = transform(text)
print(text)   # 'Hello World'
```

**map() is lazy (returns iterator, not list):**

```python
# map() does NOT compute immediately
result = map(lambda x: x * 2, [1, 2, 3])
print(result)         # <map object at 0x...>
print(list(result))   # [2, 4, 6]  - forces evaluation

# Useful for large datasets - process one at a time
big_data = range(1000000)
mapped   = map(lambda x: x ** 2, big_data)   # no memory used yet
first    = next(mapped)                        # compute only first
print(first)   # 0
```

---

#### **filter() — Keep Elements That Pass a Test**

```
filter(function, iterable)

Think of it as: "Keep only the items where function returns True"
```

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

evens    = list(filter(lambda x: x % 2 == 0, numbers))
odds     = list(filter(lambda x: x % 2 != 0, numbers))
big_nums = list(filter(lambda x: x > 5, numbers))

print(evens)     # [2, 4, 6, 8, 10]
print(odds)      # [1, 3, 5, 7, 9]
print(big_nums)  # [6, 7, 8, 9, 10]

# Filter with named function
def is_adult(person):
    return person['age'] >= 18

people = [
    {'name': 'Krishna', 'age': 32},
    {'name': 'Alice',   'age': 16},
    {'name': 'Bob',     'age': 25}
]

adults = list(filter(is_adult, people))
print(adults)   # Krishna and Bob only

# Filter None values
data    = [1, None, 2, None, 3, None]
cleaned = list(filter(None, data))   # None as function removes falsy values
print(cleaned)  # [1, 2, 3]

# Filter empty strings
words   = ['hello', '', 'world', '', 'python']
non_empty = list(filter(None, words))
print(non_empty)   # ['hello', 'world', 'python']
```

---

#### **zip() — Pair Elements From Multiple Iterables**

```
zip(iterable1, iterable2, ...)

Think of it as: "Pair up elements from multiple lists by position"
```

```python
names  = ['Krishna', 'Alice', 'Bob']
ages   = [32, 28, 35]
cities = ['Philadelphia', 'NYC', 'Chicago']

# Zip two lists
paired = list(zip(names, ages))
print(paired)   # [('Krishna', 32), ('Alice', 28), ('Bob', 35)]

# Zip three lists
tripled = list(zip(names, ages, cities))
print(tripled)  # [('Krishna', 32, 'Philadelphia'), ...]

# Unzip (reverse zip)
pairs  = [('a', 1), ('b', 2), ('c', 3)]
keys, values = zip(*pairs)
print(keys)    # ('a', 'b', 'c')
print(values)  # (1, 2, 3)

# zip with dict
d = dict(zip(names, ages))
print(d)   # {'Krishna': 32, 'Alice': 28, 'Bob': 35}

# zip stops at shortest iterable
a = [1, 2, 3, 4, 5]
b = ['a', 'b', 'c']
print(list(zip(a, b)))   # [(1,'a'), (2,'b'), (3,'c')] -- 4,5 dropped

# zip_longest to keep all
from itertools import zip_longest
print(list(zip_longest(a, b, fillvalue='-')))
# [(1,'a'), (2,'b'), (3,'c'), (4,'-'), (5,'-')]
```

---

#### **Combining map, filter, zip**

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Chain them together
result = list(
    map(
        lambda x: x ** 2,          # square each number
        filter(
            lambda x: x % 2 == 0,  # keep only evens
            numbers
        )
    )
)
print(result)   # [4, 16, 36, 64, 100]

# Equivalent list comprehension (often cleaner)
result = [x**2 for x in numbers if x % 2 == 0]
print(result)   # [4, 16, 36, 64, 100]
```

---

#### **map() vs List Comprehension — When to Use Which**

```python
numbers = [1, 2, 3, 4, 5]

# map() - cleaner when using existing function
result = list(map(str, numbers))       # clean
result = [str(x) for x in numbers]    # also fine

# map() with lambda - comprehension is usually cleaner
result = list(map(lambda x: x**2, numbers))    # ok
result = [x**2 for x in numbers]               # cleaner

# map() with multiple iterables - no comprehension equivalent
a, b   = [1,2,3], [4,5,6]
result = list(map(lambda x,y: x+y, a, b))      # map wins here
result = [x+y for x,y in zip(a,b)]             # need zip for comprehension
```

| Use                     | map()         | List Comprehension |
| ----------------------- | ------------- | ------------------ |
| Apply built-in function | ✅ Cleaner    | Verbose            |
| Apply lambda            | Either works  | Usually cleaner    |
| Multiple iterables      | ✅ Cleaner    | Need zip()         |
| With condition          | Use filter()  | ✅ Cleaner         |
| Readability             | Less readable | ✅ More readable   |

---

### 0.5 List/Dict/Set Comprehensions

```python
# List comprehension
squares    = [x**2 for x in range(10)]
even_sq    = [x**2 for x in range(10) if x % 2 == 0]
flat       = [x for sublist in [[1,2],[3,4]] for x in sublist]

# Dict comprehension
freq       = {char: s.count(char) for char in set(s)}
squared    = {x: x**2 for x in range(5)}
filtered   = {k: v for k, v in d.items() if v > 0}

# Set comprehension
unique_len = {len(word) for word in words}

# Generator expression (lazy, memory efficient)
total      = sum(x**2 for x in range(1000000))   # no list created!
first_even = next(x for x in numbers if x % 2 == 0)
```

---

### 0.6 Generators

```python
# Generator function - uses yield instead of return
def count_up(n):
    i = 0
    while i < n:
        yield i      # pause here, return value, resume next time
        i += 1

gen = count_up(5)
print(next(gen))    # 0
print(next(gen))    # 1
print(list(gen))    # [2, 3, 4]  (rest of values)

# Infinite generator
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

fib = fibonacci()
first_10 = [next(fib) for _ in range(10)]
print(first_10)   # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

# Why generators? Memory efficiency
# List: creates ALL values in memory at once
big_list = [x**2 for x in range(1000000)]    # 8MB in memory

# Generator: creates values ONE AT A TIME
big_gen  = (x**2 for x in range(1000000))    # ~120 bytes in memory
total    = sum(big_gen)                        # processes one by one
```

---

### 0.7 Context Managers

```python
# Built-in: file handling
with open('file.txt', 'r') as f:
    data = f.read()
# file automatically closed even if exception occurs

# Custom context manager
class DatabaseConnection:
    def __init__(self, host: str):
        self.host = host
        self.conn = None
  
    def __enter__(self):
        print(f"Connecting to {self.host}")
        self.conn = f"connection_to_{self.host}"
        return self.conn
  
    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Closing connection to {self.host}")
        self.conn = None
        return False    # False = don't suppress exceptions

with DatabaseConnection("oracle.prod") as conn:
    print(f"Using {conn}")
# Connecting to oracle.prod
# Using connection_to_oracle.prod
# Closing connection to oracle.prod
```

---

### 0.8 Type Hints

```python
# Basic type hints
def greet(name: str) -> str:
    return f"Hello {name}"

def add(x: int, y: int) -> int:
    return x + y

# Collections
from typing import Optional, Union

def process(
    data:      list[int],
    threshold: float = 0.5,
    label:     Optional[str] = None    # can be str or None
) -> dict[str, int]:
    return {'count': len(data)}

# Union types (Python 3.10+)
def parse(value: int | str) -> str:
    return str(value)
```

---

### 0.9 Dunder Methods

```python
class Pipeline:
    def __init__(self, name: str, steps: list):
        self.name  = name
        self.steps = steps
  
    def __repr__(self) -> str:
        """For developers - unambiguous representation."""
        return f"Pipeline(name='{self.name}', steps={self.steps})"
  
    def __str__(self) -> str:
        """For users - readable string."""
        return f"{self.name} ({len(self.steps)} steps)"
  
    def __len__(self) -> int:
        """len(pipeline)"""
        return len(self.steps)
  
    def __contains__(self, item) -> bool:
        """'step' in pipeline"""
        return item in self.steps
  
    def __eq__(self, other) -> bool:
        """pipeline1 == pipeline2"""
        return self.name == other.name
  
    def __add__(self, other):
        """pipeline1 + pipeline2"""
        return Pipeline(
            f"{self.name}+{other.name}",
            self.steps + other.steps
        )

p1 = Pipeline("ETL", ["extract", "transform", "load"])
p2 = Pipeline("Validation", ["validate", "reconcile"])

print(len(p1))              # 3
print("extract" in p1)      # True
print(str(p1))              # ETL (3 steps)
print(repr(p1))             # Pipeline(name='ETL', steps=[...])
p3 = p1 + p2                # combines pipelines
```

---

### 0.10 Dataclasses

```python
from dataclasses import dataclass, field

@dataclass
class Pipeline:
    """Auto-generates __init__, __repr__, __eq__."""
    name:    str
    source:  str
    target:  str
    enabled: bool = True
    tags:    list = field(default_factory=list)   # mutable default
  
    def is_active(self) -> bool:
        return self.enabled
  
    def add_tag(self, tag: str) -> None:
        self.tags.append(tag)

p = Pipeline("ETL", "oracle", "hive")
print(p)            # Pipeline(name='ETL', source='oracle', ...)
print(p.is_active()) # True
p.add_tag("daily")
print(p.tags)       # ['daily']
```

---

### Quick Reference: When to Use What

| Tool                | Use When                                     |
| ------------------- | -------------------------------------------- |
| `@property`       | Method should behave like attribute          |
| `@staticmethod`   | Utility function, no self/cls needed         |
| `@classmethod`    | Need access to class, factory methods        |
| `@abstractmethod` | Force subclasses to implement (use with ABC) |
| `lambda`          | Simple one-liner, used as argument           |
| `map()`           | Apply function to every element              |
| `filter()`        | Keep elements that pass a test               |
| `reduce()`        | Fold list into single value                  |
| Generator           | Large data, memory efficiency matters        |
| Context manager     | Resource cleanup (files, connections)        |
| Dataclass           | Simple data container class                  |
| ABC                 | Enforce interface on subclasses              |

### Common Data Structure Operations

| Structure          | Access   | Search   | Insert   | Delete   |
| ------------------ | -------- | -------- | -------- | -------- |
| Array              | O(1)     | O(n)     | O(n)     | O(n)     |
| Linked List        | O(n)     | O(n)     | O(1)*    | O(1)*    |
| Hash Table         | O(1)     | O(1)     | O(1)     | O(1)     |
| Binary Search Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap               | O(1)**   | O(n)     | O(log n) | O(log n) |

*With reference to node
**Access to min/max only

# 🔴 TIER 1 — CONFIRMED ASKED (Do These First)

## Part 10b: Additional Problems (Glassdoor + High Priority)

### Problem 9: Robot Grid / Unique Paths (DP/Graph)

**Problem:**

```
A robot is in the top-left corner of an m x n grid.
It can only move right or down.
How many unique paths are there to reach the bottom-right corner?

Example:
m=3, n=7 → 28 unique paths
```

**Before You Code — Say This Out Loud:**

> "Classic DP problem. At each cell, the number of ways to get there equals ways from above plus ways from left. First row and column are all 1s since there's only one way to reach them. Build the grid bottom-up."

**Solution:**

```python
def unique_paths(m: int, n: int) -> int:
    """
    Count unique paths in an m x n grid (right or down only).
  
    Approach: DP — dp[i][j] = dp[i-1][j] + dp[i][j-1]
    Time: O(m * n)
    Space: O(m * n)
    """
    # Initialize grid with 1s (base case)
    dp = [[1] * n for _ in range(m)]
  
    # Fill in the rest
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = dp[i-1][j] + dp[i][j-1]
  
    return dp[m-1][n-1]


# Test cases
print(unique_paths(3, 7))   # 28
print(unique_paths(3, 2))   # 3
print(unique_paths(1, 1))   # 1 (edge: single cell)
```

**Space-Optimized Version (1D DP):**

```python
def unique_paths_optimized(m: int, n: int) -> int:
    """
    Optimized: Use 1D array instead of 2D grid.
    Time: O(m * n)
    Space: O(n) — only one row needed
    """
    dp = [1] * n
  
    for i in range(1, m):
        for j in range(1, n):
            dp[j] += dp[j-1]
  
    return dp[n-1]
```

**Walkthrough:**

```
3x3 grid:
Initial:    After filling:
1 1 1       1 1 1
1 1 1  →    1 2 3
1 1 1       1 3 6

dp[1][1] = dp[0][1] + dp[1][0] = 1 + 1 = 2
dp[1][2] = dp[0][2] + dp[1][1] = 1 + 2 = 3
dp[2][1] = dp[1][1] + dp[2][0] = 2 + 1 = 3
dp[2][2] = dp[1][2] + dp[2][1] = 3 + 3 = 6
```

**Talking Points:**

- "DP is perfect here — overlapping subproblems, optimal substructure"
- "First row/column are base cases — only one way to move along an edge"
- "Each cell depends only on its left and top neighbor"
- "Can optimize to O(n) space using a 1D array"

---

### Problem 10: Bank Account (OOP)

**Problem:**

```
Create a Robot/Bank Account class with methods to:
- Add account
- Delete account
- Check balance
- Deposit
- Withdraw
```

**Before You Code — Say This Out Loud:**

> "OOP problem. I'll create a BankSystem class that manages multiple accounts. Each account has an ID, owner, and balance. I'll encapsulate the data and provide clean methods for each operation. I'll also handle error cases like insufficient funds or non-existent accounts."

**Solution:**

```python
class Account:
    """Represents a single bank account."""
  
    def __init__(self, account_id: str, owner: str, initial_balance: float = 0.0):
        self.account_id = account_id
        self.owner = owner
        self._balance = initial_balance   # Private with underscore convention
  
    def deposit(self, amount: float) -> float:
        """Deposit amount into account. Returns new balance."""
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self._balance += amount
        return self._balance
  
    def withdraw(self, amount: float) -> float:
        """Withdraw amount from account. Returns new balance."""
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
        if amount > self._balance:
            raise ValueError(f"Insufficient funds. Balance: {self._balance}")
        self._balance -= amount
        return self._balance
  
    def get_balance(self) -> float:
        """Return current balance."""
        return self._balance
  
    def __repr__(self):
        return f"Account(id={self.account_id}, owner={self.owner}, balance={self._balance})"


class BankSystem:
    """Manages multiple bank accounts."""
  
    def __init__(self):
        self._accounts = {}   # account_id → Account
  
    def add_account(self, account_id: str, owner: str, initial_balance: float = 0.0) -> Account:
        """Create a new account. Raises error if account_id already exists."""
        if account_id in self._accounts:
            raise ValueError(f"Account {account_id} already exists")
        account = Account(account_id, owner, initial_balance)
        self._accounts[account_id] = account
        return account
  
    def delete_account(self, account_id: str) -> bool:
        """Delete an account. Returns True if deleted, False if not found."""
        if account_id not in self._accounts:
            raise ValueError(f"Account {account_id} not found")
        del self._accounts[account_id]
        return True
  
    def check_balance(self, account_id: str) -> float:
        """Check balance of an account."""
        account = self._get_account(account_id)
        return account.get_balance()
  
    def deposit(self, account_id: str, amount: float) -> float:
        """Deposit into an account. Returns new balance."""
        account = self._get_account(account_id)
        return account.deposit(amount)
  
    def withdraw(self, account_id: str, amount: float) -> float:
        """Withdraw from an account. Returns new balance."""
        account = self._get_account(account_id)
        return account.withdraw(amount)
  
    def _get_account(self, account_id: str) -> Account:
        """Private helper — get account or raise error."""
        if account_id not in self._accounts:
            raise ValueError(f"Account {account_id} not found")
        return self._accounts[account_id]
  
    def list_accounts(self) -> list:
        """List all accounts."""
        return list(self._accounts.values())


# Test cases
bank = BankSystem()

# Add accounts
bank.add_account("ACC001", "Krishna", 1000.0)
bank.add_account("ACC002", "Shreekala", 500.0)

# Check balance
print(bank.check_balance("ACC001"))   # 1000.0

# Deposit
print(bank.deposit("ACC001", 500.0))  # 1500.0

# Withdraw
print(bank.withdraw("ACC001", 200.0)) # 1300.0

# Delete account
bank.delete_account("ACC002")

# Error handling
try:
    bank.check_balance("ACC002")       # Raises ValueError
except ValueError as e:
    print(f"Error: {e}")

try:
    bank.withdraw("ACC001", 99999)     # Raises ValueError
except ValueError as e:
    print(f"Error: {e}")
```

**OOP Concepts Demonstrated:**

```
Encapsulation:  _balance is private (underscore convention)
Abstraction:    _get_account is a private helper
Separation:     Account handles one account, BankSystem manages many
Error handling: ValueError for bad operations
```

**Talking Points:**

- "I separated Account (single) and BankSystem (manager) for clean separation of concerns"
- "Underscore prefix on _balance and _accounts signals private — Python convention"
- "Error handling is critical in financial systems — I raise ValueError for invalid ops"
- "Could extend with Transaction history, interest calculation, etc."
- "Could use @property decorator to make balance a property instead of method"

---

### Problem 11: Number of Islands (Graph/BFS/DFS)

**Problem:**

```
Given a 2D grid of '1's (land) and '0's (water),
count the number of islands.

An island is surrounded by water and is formed by connecting
adjacent lands horizontally or vertically.

Input:
grid = [
  ['1','1','0','0','0'],
  ['1','1','0','0','0'],
  ['0','0','1','0','0'],
  ['0','0','0','1','1']
]
Output: 3
```

**Before You Code — Say This Out Loud:**

> "Classic graph traversal. I'll iterate through every cell. When I find a '1', I increment my island count and do a DFS/BFS to mark all connected land cells as visited — I'll change them to '0' so I don't count them again. Time O(m*n), Space O(m*n) for the recursion stack."

**Solution (DFS):**

```python
def num_islands(grid: list) -> int:
    """
    Count number of islands in a 2D grid.
  
    Approach: DFS — for each unvisited '1', increment count and
    mark all connected land as visited.
    Time: O(m * n) — visit each cell at most once
    Space: O(m * n) — recursion stack in worst case
    """
    if not grid or not grid[0]:
        return 0
  
    rows, cols = len(grid), len(grid[0])
    island_count = 0
  
    def dfs(r: int, c: int):
        """Mark all connected land cells as visited."""
        # Base case: out of bounds or water
        if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] == '0':
            return
  
        grid[r][c] = '0'   # Mark as visited (sink the island)
  
        # Explore all 4 directions
        dfs(r + 1, c)  # Down
        dfs(r - 1, c)  # Up
        dfs(r, c + 1)  # Right
        dfs(r, c - 1)  # Left
  
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '1':
                island_count += 1
                dfs(r, c)
  
    return island_count


# Test cases
grid1 = [
    ['1','1','0','0','0'],
    ['1','1','0','0','0'],
    ['0','0','1','0','0'],
    ['0','0','0','1','1']
]
print(num_islands(grid1))   # 3

grid2 = [
    ['1','1','1','1','0'],
    ['1','1','0','1','0'],
    ['1','1','0','0','0'],
    ['0','0','0','0','0']
]
print(num_islands(grid2))   # 1
```

**BFS Alternative:**

```python
from collections import deque

def num_islands_bfs(grid: list) -> int:
    """BFS approach — iterative instead of recursive."""
    if not grid:
        return 0
  
    rows, cols = len(grid), len(grid[0])
    island_count = 0
    directions = [(1,0), (-1,0), (0,1), (0,-1)]
  
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == '1':
                island_count += 1
                queue = deque([(r, c)])
                grid[r][c] = '0'
          
                while queue:
                    row, col = queue.popleft()
                    for dr, dc in directions:
                        nr, nc = row + dr, col + dc
                        if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] == '1':
                            queue.append((nr, nc))
                            grid[nr][nc] = '0'
  
    return island_count
```

**Talking Points:**

- "I'm modifying the grid in-place (sinking islands) to avoid a visited set — saves space"
- "If I can't modify the grid, I'd use a visited set instead"
- "DFS is cleaner, BFS is better for very large grids (avoids stack overflow)"
- "The directions array [(1,0),(-1,0),(0,1),(0,-1)] is a clean way to handle 4-directional movement"
- "Time is O(m*n) — each cell visited at most once"

---

### Problem 12: Robot Class OOP — Confirmed Asked

**What they want:** A `Robot` class with movement or state methods — same OOP pattern as Bank Account: private state, public methods, error handling.

**Say this before coding:**

> "I'll encapsulate position and direction as private attributes. I'll use a class-level `DIRECTIONS` list so rotation is just index math mod 4 — no if/else chain needed."

```python
class Robot:
    DIRECTIONS = ['N', 'E', 'S', 'W']

    def __init__(self, x: int = 0, y: int = 0, direction: str = 'N'):
        self._x = x
        self._y = y
        self._dir = direction
        self._history = [(x, y)]

    def move(self, steps: int = 1) -> None:
        if self._dir == 'N': self._y += steps
        elif self._dir == 'S': self._y -= steps
        elif self._dir == 'E': self._x += steps
        elif self._dir == 'W': self._x -= steps
        self._history.append((self._x, self._y))

    def turn_right(self) -> None:
        idx = self.DIRECTIONS.index(self._dir)
        self._dir = self.DIRECTIONS[(idx + 1) % 4]

    def turn_left(self) -> None:
        idx = self.DIRECTIONS.index(self._dir)
        self._dir = self.DIRECTIONS[(idx - 1) % 4]

    def position(self) -> tuple:
        return (self._x, self._y)

    def get_history(self) -> list:
        return list(self._history)

    def reset(self) -> None:
        self._x, self._y, self._dir = 0, 0, 'N'
        self._history = [(0, 0)]

    def __repr__(self) -> str:
        return f"Robot(pos={self.position()}, dir={self._dir})"


# Test
r = Robot()
r.move(3)           # (0, 3)
r.turn_right()      # now facing E
r.move(2)           # (2, 3)
r.turn_left()       # back to N
print(r.position())     # (2, 3)
print(r.get_history())  # [(0,0), (0,3), (2,3)]
```

**OOP concepts to call out:**

- `_x`, `_y`, `_dir` are private — encapsulation, callers can't corrupt state directly
- `DIRECTIONS` is a class variable — shared across all instances, not per-instance
- `__repr__` — always mention this for debugging

**Follow-ups to have ready:**

| Follow-up               | Answer                                                                  |
| ----------------------- | ----------------------------------------------------------------------- |
| Add boundary check      | `if not (0 <= self._x <= max_x): raise ValueError(...)` in `move()` |
| Add `__eq__`          | `return self.position() == other.position()`                          |
| Track direction history | Append `self._dir` alongside position in `_history`                 |

---

### Problem 13: Dynamic Programming (General Concepts)

**The 3 Most Common DP Patterns at Credit Karma Level:**

---

#### DP Pattern 1: Fibonacci / Linear DP

```python
def fibonacci(n: int) -> int:
    """
    Classic DP: each value depends on previous two.
    Time: O(n), Space: O(1)
    """
    if n <= 1:
        return n
  
    prev2, prev1 = 0, 1
    for _ in range(2, n + 1):
        curr = prev1 + prev2
        prev2, prev1 = prev1, curr
  
    return prev1

print(fibonacci(10))  # 55
```

---

#### DP Pattern 2: 0/1 Knapsack

```python
def knapsack(weights: list, values: list, capacity: int) -> int:
    """
    Classic knapsack: maximize value within weight capacity.
    Time: O(n * capacity), Space: O(n * capacity)
    """
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
  
    for i in range(1, n + 1):
        for w in range(capacity + 1):
            # Don't take item i
            dp[i][w] = dp[i-1][w]
            # Take item i (if it fits)
            if weights[i-1] <= w:
                dp[i][w] = max(dp[i][w], dp[i-1][w - weights[i-1]] + values[i-1])
  
    return dp[n][capacity]

print(knapsack([1,2,3], [1,2,3], 5))  # 5
```

---

#### DP Pattern 3: Longest Common Subsequence (LCS)

```python
def lcs(s1: str, s2: str) -> int:
    """
    Find length of longest common subsequence.
    Time: O(m * n), Space: O(m * n)
    """
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
  
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
  
    return dp[m][n]

print(lcs("abcde", "ace"))  # 3 (a, c, e)
```

---

**DP Decision Framework (Say This Out Loud):**

```
When to use DP:
1. "Find maximum/minimum" → DP
2. "Count number of ways" → DP
3. "Is it possible to..." → DP
4. "Overlapping subproblems" → DP

Steps to solve any DP:
1. Define the state: what does dp[i] represent?
2. Base case: what's the smallest input?
3. Transition: how does dp[i] relate to dp[i-1]?
4. Answer: where is the answer in the dp array?
```

---

---

# 🔴 TIER 2 — THE WEAK SPOT (Lost a Round Over This)

---

## Part 14: Histogram + Log File Processing (What Cost You The Round)

### Why These Feel Hard Under Pressure

Histogram and log processing questions feel ambiguous. There's no single "correct" answer — the interviewer wants to see how you **structure unstructured data**. The fix: always ask clarifying questions first, then follow a template.

---

### Problem: Frequency Histogram (What Was Asked)

**Problem:**

```
Given a list of items (numbers, words, log entries),
print a frequency histogram.

Example Input:
data = [1, 1, 2, 3, 3, 3, 4]

Example Output:
1 | ##
2 | #
3 | ###
4 | #
```

**Before You Code — Say This Out Loud:**

> "Let me clarify — do you want a horizontal or vertical histogram?
> Should I use characters like # or actual counts?
> Is the input already sorted or do I need to sort it?"

**Solution 1: Basic Number Histogram**

```python
from collections import Counter

def histogram(data: list) -> None:
    """
    Print a horizontal frequency histogram.
  
    Approach: Counter for frequencies, sort keys, print bars.
    Time: O(n log n) — sorting
    Space: O(k) where k = unique values
    """
    freq = Counter(data)
  
    for key in sorted(freq.keys()):
        bar = '#' * freq[key]
        print(f"{key:>4} | {bar} ({freq[key]})")


# Test
data = [1, 1, 2, 3, 3, 3, 4]
histogram(data)
# Output:
#    1 | ## (2)
#    2 | # (1)
#    3 | ### (3)
#    4 | # (1)
```

**Solution 2: String/Word Histogram**

```python
def word_histogram(text: str) -> None:
    """
    Print histogram of word frequencies.
    Time: O(n log n)
    Space: O(k)
    """
    words = text.lower().split()
    freq = Counter(words)
    max_count = max(freq.values())
  
    for word, count in sorted(freq.items(), key=lambda x: -x[1]):
        bar = '#' * count
        print(f"{word:>15} | {bar} ({count})")


# Test
text = "the quick brown fox jumps over the lazy dog the fox"
word_histogram(text)
```

**Solution 3: Scaled Histogram (For Large Numbers)**

```python
def scaled_histogram(data: list, max_width: int = 20) -> None:
    """
    Scale bars so they fit in max_width characters.
    Useful when counts are very large.
    """
    freq = Counter(data)
    max_count = max(freq.values())
  
    for key in sorted(freq.keys()):
        count = freq[key]
        # Scale bar proportionally
        bar_len = int((count / max_count) * max_width)
        bar = '#' * bar_len
        print(f"{key:>4} | {bar:<{max_width}} ({count})")


# Test with large counts
data = [1]*100 + [2]*50 + [3]*75 + [4]*25
scaled_histogram(data)
```

---

### Problem: HTTP Log Processing

**This is the real-world version — what Credit Karma actually cares about.**

**Sample HTTP Log:**

```
192.168.1.1 - - [10/May/2026:10:00:01] "GET /api/credit-score HTTP/1.1" 200 1234
192.168.1.2 - - [10/May/2026:10:00:02] "POST /api/login HTTP/1.1" 401 567
192.168.1.1 - - [10/May/2026:10:00:03] "GET /api/credit-score HTTP/1.1" 200 890
192.168.1.3 - - [10/May/2026:10:00:04] "GET /api/offers HTTP/1.1" 500 234
192.168.1.2 - - [10/May/2026:10:00:05] "GET /api/credit-score HTTP/1.1" 200 456
```

**Common Tasks:**

**Task 1: Count requests by status code**

```python
import re
from collections import Counter, defaultdict

def parse_log_line(line: str) -> dict:
    """
    Parse a single HTTP log line into components.
  
    Returns dict with ip, method, endpoint, status, bytes
    """
    pattern = r'(\d+\.\d+\.\d+\.\d+).*"(\w+) (\S+) HTTP.*" (\d+) (\d+)'
    match = re.search(pattern, line)
  
    if not match:
        return None
  
    return {
        'ip':       match.group(1),
        'method':   match.group(2),
        'endpoint': match.group(3),
        'status':   int(match.group(4)),
        'bytes':    int(match.group(5))
    }


def status_code_histogram(log_lines: list) -> None:
    """Count and display requests by status code."""
    status_counts = Counter()
  
    for line in log_lines:
        parsed = parse_log_line(line)
        if parsed:
            status_counts[parsed['status']] += 1
  
    print("Status Code Histogram:")
    for status, count in sorted(status_counts.items()):
        bar = '#' * count
        print(f"  {status} | {bar} ({count})")


# Test
logs = [
    '192.168.1.1 - - [10/May/2026] "GET /api/score HTTP/1.1" 200 1234',
    '192.168.1.2 - - [10/May/2026] "POST /api/login HTTP/1.1" 401 567',
    '192.168.1.1 - - [10/May/2026] "GET /api/score HTTP/1.1" 200 890',
    '192.168.1.3 - - [10/May/2026] "GET /api/offers HTTP/1.1" 500 234',
    '192.168.1.2 - - [10/May/2026] "GET /api/score HTTP/1.1" 200 456',
]

status_code_histogram(logs)
# Output:
# Status Code Histogram:
#   200 | ### (3)
#   401 | # (1)
#   500 | # (1)
```

**Task 2: Top N endpoints by request count**

```python
def top_endpoints(log_lines: list, n: int = 5) -> list:
    """Find top N most requested endpoints."""
    endpoint_counts = Counter()
  
    for line in log_lines:
        parsed = parse_log_line(line)
        if parsed:
            endpoint_counts[parsed['endpoint']] += 1
  
    print(f"\nTop {n} Endpoints:")
    for endpoint, count in endpoint_counts.most_common(n):
        print(f"  {endpoint:30} | {count} requests")
  
    return endpoint_counts.most_common(n)

top_endpoints(logs)
```

**Task 3: Error rate by endpoint**

```python
def error_rate_by_endpoint(log_lines: list) -> None:
    """Calculate error rate (4xx/5xx) per endpoint."""
    total    = defaultdict(int)
    errors   = defaultdict(int)
  
    for line in log_lines:
        parsed = parse_log_line(line)
        if parsed:
            ep = parsed['endpoint']
            total[ep] += 1
            if parsed['status'] >= 400:
                errors[ep] += 1
  
    print("\nError Rate by Endpoint:")
    for ep in sorted(total.keys()):
        rate = (errors[ep] / total[ep]) * 100
        print(f"  {ep:30} | {rate:.1f}% errors ({errors[ep]}/{total[ep]})")

error_rate_by_endpoint(logs)
```

**Task 4: Full Log Analysis Pipeline**

```python
def analyze_logs(log_file_path: str) -> dict:
    """
    Complete log analysis pipeline.
    Reads from file, parses, and returns summary stats.
    """
    results = {
        'total_requests':   0,
        'status_counts':    Counter(),
        'endpoint_counts':  Counter(),
        'error_count':      0,
        'total_bytes':      0
    }
  
    try:
        with open(log_file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
          
                parsed = parse_log_line(line)
                if not parsed:
                    continue
          
                results['total_requests'] += 1
                results['status_counts'][parsed['status']] += 1
                results['endpoint_counts'][parsed['endpoint']] += 1
                results['total_bytes'] += parsed['bytes']
          
                if parsed['status'] >= 400:
                    results['error_count'] += 1
  
    except FileNotFoundError:
        print(f"Log file not found: {log_file_path}")
        return {}
  
    # Add derived metrics
    if results['total_requests'] > 0:
        results['error_rate'] = results['error_count'] / results['total_requests']
  
    return results
```

**Talking Points for Log Questions:**

- "First I'd clarify the log format — is it Apache CLF, JSON, custom?"
- "I'll use regex to parse each line into structured fields"
- "Counter from collections handles frequency counting efficiently"
- "In production I'd use a streaming approach for large files — not load all into memory"
- "Could extend with time-window analysis, percentile response times, etc."

---

---

# 🟡 TIER 3 — NEW PROBLEMS (Two Sum, Anagram, Sliding Window, Sieve)

---

## Part 23: Missing Problems (Common Easy Questions)

These were absent from the document but are standard easy-level Python interview questions. Any could appear at Credit Karma.

---

### Problem 24: Prime to N — Sieve of Eratosthenes

**Problem:**

```
Return all prime numbers up to n.

primes_to_n(10) → [2, 3, 5, 7]
primes_to_n(20) → [2, 3, 5, 7, 11, 13, 17, 19]
```

**Before You Code — Say This Out Loud:**

> "I'll use the Sieve of Eratosthenes. Start with all numbers marked as prime. For each prime p, mark all its multiples as not prime. Time O(n log log n), Space O(n)."

```python
def primes_to_n(n: int) -> list:
    """
    Return all primes up to n using the Sieve of Eratosthenes.
    Time: O(n log log n)
    Space: O(n)
    """
    if n < 2:
        return []

    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False

    for i in range(2, int(n**0.5) + 1):
        if is_prime[i]:
            for j in range(i * i, n + 1, i):  # start at i*i — smaller already marked
                is_prime[j] = False

    return [i for i in range(2, n + 1) if is_prime[i]]


# Test
print(primes_to_n(10))   # [2, 3, 5, 7]
print(primes_to_n(20))   # [2, 3, 5, 7, 11, 13, 17, 19]
print(primes_to_n(1))    # [] (edge: no primes)
print(primes_to_n(2))    # [2] (edge: smallest prime)
```

**Talking Points:**

- "The key optimization is starting inner loop at `i*i` — all smaller multiples already marked"
- "Only need to sieve up to `sqrt(n)` — any composite has a factor ≤ sqrt(n)"
- "Space O(n) for the boolean array"
- "Brute force approach: `all(n % i != 0 for i in range(2, n))` per number — O(n²)"

---

### Problem 25: Two Sum

**Problem:**

```
Given an array and a target, return indices of two numbers that add to target.
Guaranteed exactly one solution.

nums = [2, 7, 11, 15], target = 9 → [0, 1]
nums = [3, 2, 4],      target = 6 → [1, 2]
```

**Before You Code — Say This Out Loud:**

> "Hash map approach. As I scan each number, I check if the complement (target - current) is already in the map. If yes, return both indices. One pass, O(n) time and space."

```python
def two_sum(nums: list, target: int) -> list:
    """
    Find two indices that sum to target.
    Time: O(n), Space: O(n)
    """
    seen = {}   # value → index

    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i

    return []   # guaranteed solution exists, so this won't hit


# Test
print(two_sum([2, 7, 11, 15], 9))   # [0, 1]
print(two_sum([3, 2, 4], 6))        # [1, 2]
print(two_sum([3, 3], 6))           # [0, 1] (edge: duplicate values)
```

**Talking Points:**

- "Brute force is O(n²) — check every pair. Hash map gets it to O(n)"
- "I store value → index so I can look up the complement in O(1)"
- "Key: check complement BEFORE storing current — handles the `[3,3]` edge case correctly"

---

### Problem 26: Valid Anagram

**Problem:**

```
Given two strings, return True if one is an anagram of the other.

is_anagram("anagram", "nagaram") → True
is_anagram("rat", "car")         → False
```

**Before You Code — Say This Out Loud:**

> "Two approaches: Counter comparison (cleanest) or sort both strings. Counter is O(n) time and O(k) space. Sorting is O(n log n) but O(1) extra space. I'll use Counter — more Pythonic."

```python
from collections import Counter

def is_anagram(s: str, t: str) -> bool:
    """
    Check if t is an anagram of s.
    Time: O(n), Space: O(k) where k = unique characters
    """
    if len(s) != len(t):
        return False
    return Counter(s) == Counter(t)


# One-liner alternative:
def is_anagram_sort(s: str, t: str) -> bool:
    """Sort approach — O(n log n) time, O(1) extra space."""
    return sorted(s) == sorted(t)


# Test
print(is_anagram("anagram", "nagaram"))   # True
print(is_anagram("rat", "car"))           # False
print(is_anagram("a", "a"))              # True (edge: single char)
print(is_anagram("ab", "a"))             # False (edge: diff lengths)
```

**Follow-up: Group Anagrams**

```python
from collections import defaultdict

def group_anagrams(strs: list) -> list:
    """
    Group strings that are anagrams of each other.
    Time: O(n * k log k) where k = max string length
    Space: O(n)
    """
    groups = defaultdict(list)
    for word in strs:
        key = tuple(sorted(word))   # anagrams have the same sorted key
        groups[key].append(word)
    return list(groups.values())


# Test
print(group_anagrams(["eat","tea","tan","ate","nat","bat"]))
# [["eat","tea","ate"], ["tan","nat"], ["bat"]]
```

**Talking Points:**

- "Counter comparison is the most Pythonic — reads like English"
- "Length check first saves time on obvious mismatches"
- "For Group Anagrams: sorted tuple as dict key groups all anagrams together"

---

### Problem 27: Longest Substring Without Repeating Characters

**Problem:**

```
Given a string, return the length of the longest substring
with no repeating characters.

"abcabcbb" → 3  ("abc")
"bbbbb"    → 1  ("b")
"pwwkew"   → 3  ("wke")
```

**Before You Code — Say This Out Loud:**

> "Sliding window with a set. Left and right pointers define the window. Expand right; if we see a repeat, shrink from the left until the repeat is removed. Track max window size throughout."

```python
def length_of_longest_substring(s: str) -> int:
    """
    Longest substring without repeating characters.
    Time: O(n), Space: O(min(n, alphabet))
    """
    seen = set()
    left = 0
    max_len = 0

    for right in range(len(s)):
        while s[right] in seen:       # shrink window until no repeat
            seen.remove(s[left])
            left += 1
        seen.add(s[right])
        max_len = max(max_len, right - left + 1)

    return max_len


# Optimized: store index instead of removing one by one
def length_of_longest_substring_opt(s: str) -> int:
    """
    Optimized with index map — jump left pointer directly.
    Time: O(n), Space: O(min(n, alphabet))
    """
    last_seen = {}   # char → last index seen
    left = 0
    max_len = 0

    for right, char in enumerate(s):
        if char in last_seen and last_seen[char] >= left:
            left = last_seen[char] + 1   # jump past the duplicate
        last_seen[char] = right
        max_len = max(max_len, right - left + 1)

    return max_len


# Test
print(length_of_longest_substring("abcabcbb"))   # 3
print(length_of_longest_substring("bbbbb"))      # 1
print(length_of_longest_substring("pwwkew"))     # 3
print(length_of_longest_substring(""))           # 0 (edge)
print(length_of_longest_substring("a"))          # 1 (edge)
```

**Walkthrough:**

```
"abcabcbb"
right=0: a  → window={a},       len=1
right=1: b  → window={a,b},     len=2
right=2: c  → window={a,b,c},   len=3  ← max
right=3: a  → shrink: remove a, left=1. window={b,c,a}, len=3
right=4: b  → shrink: remove b, left=2. window={c,a,b}, len=3
...
```

**Talking Points:**

- "Classic sliding window — two pointers, a set to track what's in the window"
- "The optimized version avoids the while loop by jumping directly to the right position"
- "Edge cases: empty string → 0, all same chars → 1"

---

### Problem 28: Find All Duplicates

**Problem:**

```
Given a list of integers, return all elements that appear more than once.

find_duplicates([1, 2, 3, 2, 4, 3]) → [2, 3]
```

```python
from collections import Counter

def find_duplicates(nums: list) -> list:
    """
    Time: O(n), Space: O(n)
    """
    return [num for num, count in Counter(nums).items() if count > 1]


# Test
print(find_duplicates([1, 2, 3, 2, 4, 3]))   # [2, 3]
print(find_duplicates([1, 2, 3]))             # [] (no duplicates)
print(find_duplicates([1, 1, 1]))             # [1]
```

---

### What These Problems Test

| Problem               | Pattern        | Key Tool                         |
| --------------------- | -------------- | -------------------------------- |
| Sieve of Eratosthenes | Math           | Boolean array + nested loop      |
| Two Sum               | Hash Map       | `seen = {}`, complement lookup |
| Valid Anagram         | Counter        | `Counter(s) == Counter(t)`     |
| Group Anagrams        | Hash Map       | `tuple(sorted(word))` as key   |
| Longest Substring     | Sliding Window | Set + two pointers               |
| Find Duplicates       | Counter        | `Counter(nums).items()`        |

---

---

# 🟡 TIER 4 — CORE PROBLEMS (Medium → Easy)

---

## Part 6: Stack / Dynamic Programming

### Problem 8: Level of Rain Water in 2D Terrain (Medium)

**Problem:**

```
Given an array of heights, calculate total trapped rainwater.

Index:   0  1  2  3  4
Height:  3  0  2  0  4
Water:   0  3  1  3  0
Total:   7

Time: O(n), Space: O(n)
```

**Before You Code — Say This Out Loud:**

> "Water trapped at each position = min(max_left, max_right) - height[i]. I'll precompute max heights from left and right in two passes, then compute water in a third pass. This gives O(n) time and O(n) space."

**Solution:**

```python
def rain_water(terrain_levels: list) -> int:
    """
    Calculate total trapped rainwater.
  
    Approach: Precompute max_left and max_right arrays.
    Time: O(n) — three passes through array
    Space: O(n) — two arrays for max heights
    """
    if not terrain_levels or len(terrain_levels) < 3:
        return 0
  
    n = len(terrain_levels)
  
    # Pass 1: Max height to the LEFT of each position
    max_left = [0] * n
    max_left[0] = terrain_levels[0]
    for i in range(1, n):
        max_left[i] = max(max_left[i-1], terrain_levels[i])
  
    # Pass 2: Max height to the RIGHT of each position
    max_right = [0] * n
    max_right[n-1] = terrain_levels[n-1]
    for i in range(n-2, -1, -1):
        max_right[i] = max(max_right[i+1], terrain_levels[i])
  
    # Pass 3: Calculate trapped water at each position
    total_water = 0
    for i in range(n):
        water_at_i = min(max_left[i], max_right[i]) - terrain_levels[i]
        total_water += max(0, water_at_i)   # Can't be negative
  
    return total_water


# Test cases
print(rain_water([3, 0, 2, 0, 4]))   # 7
print(rain_water([0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]))  # 6
print(rain_water([4, 2, 0, 3, 2, 5]))  # 9
print(rain_water([]))                 # 0 (edge: empty)
print(rain_water([3, 0, 2]))          # 2 (edge: three elements)
```

**Walkthrough with Example:**

```
terrain_levels = [3, 0, 2, 0, 4]

max_left  = [3, 3, 3, 3, 4]   # Running max from left
max_right = [4, 4, 4, 4, 4]   # Running max from right

Position 0: min(3,4) - 3 = 0
Position 1: min(3,4) - 0 = 3  ← 3 units of water
Position 2: min(3,4) - 2 = 1  ← 1 unit of water
Position 3: min(3,4) - 0 = 3  ← 3 units of water
Position 4: min(4,4) - 4 = 0

Total = 0 + 3 + 1 + 3 + 0 = 7 ✅
```

**Talking Points:**

- "The key insight: water at position i is limited by the shorter of the two walls"
- "Three passes: left max, right max, then water calculation"
- "max(0, water_at_i) handles cases where terrain is higher than both sides"
- "Could optimize to O(1) space with two pointers, but O(n) space is the requirement"
- "The two-pointer approach: start from both ends, move the shorter wall inward"

---

## Part 1: Stack Problems

### Problem 1: The Brackets Problem (Easy)

**Problem:**

```
Given a string, verify it is balanced.
Every {, [, ( must have a corresponding }, ], )

is_balanced('(())[]{}')       → True
is_balanced('{([(){}])()}')   → True
is_balanced('{}[]())')        → False
```

**Before You Code — Say This Out Loud:**

> "I'll use a stack. When I see an opening bracket I push it. When I see a closing bracket I check if the top of the stack is the matching opener. If the stack is empty at the end, the string is balanced."

**Solution:**

```python
def is_balanced(string: str) -> bool:
    """
    Check if a string has balanced brackets.
  
    Approach: Stack — push opening brackets, pop on closing.
    Time: O(n)
    Space: O(n)
    """
    stack = []
    pairs = {')': '(', ']': '[', '}': '{'}
  
    for char in string:
        if char in '([{':                    # Opening bracket
            stack.append(char)
        elif char in ')]}':                  # Closing bracket
            if not stack or stack[-1] != pairs[char]:
                return False
            stack.pop()
  
    return len(stack) == 0                   # Empty stack = balanced

# Test cases
print(is_balanced('(())[]{}'))       # True
print(is_balanced('{([(){}])()}'))   # True
print(is_balanced('{}[]())'))        # False
print(is_balanced(''))               # True (edge case: empty string)
print(is_balanced('('))              # False (edge case: unclosed)
```

**Talking Points:**

- "The key insight is using a stack — it naturally handles nesting"
- "I'm storing openers and checking closers against them"
- "Edge cases: empty string (valid), single opener (invalid), non-bracket chars (skip)"
- "Time O(n) — one pass through the string"
- "Space O(n) — worst case all openers, e.g., ((((("

---

### Problem 2: Check Matching Parentheses (Medium)

**Problem:**

```
Given a list of strings, return a list of booleans
stating whether each string's parentheses are balanced.

Input:
list_of_strings = [
    'f(x) + g(x)',        → True
    'sin(exp(x)}',        → False
    '((())just some string)', → True
    '(4,{(3,4):x**2)']   → False
```

**Before You Code — Say This Out Loud:**

> "This is an extension of Problem 1. I'll reuse the is_balanced function and apply it to each string. The key difference is that non-bracket characters should be ignored."

**Solution:**

```python
def string_parser(list_of_strings: list) -> list:
    """
    Parse a list of strings and check if each has balanced brackets.
  
    Approach: Reuse is_balanced on each string.
    Time: O(n * m) where n = number of strings, m = avg string length
    Space: O(m) for the stack
    """
    def is_balanced(string: str) -> bool:
        stack = []
        pairs = {')': '(', ']': '[', '}': '{'}
  
        for char in string:
            if char in '([{':
                stack.append(char)
            elif char in ')]}':
                if not stack or stack[-1] != pairs[char]:
                    return False
                stack.pop()
  
        return len(stack) == 0
  
    return [is_balanced(s) for s in list_of_strings]


# Test cases
list_of_strings = [
    'f(x) + g(x)',
    'sin(exp(x)}',
    '((())just some string)',
    '(4,{(3,4):x**2)'
]

print(string_parser(list_of_strings))  # [True, False, True, False]
```

**Talking Points:**

- "I'm reusing the is_balanced logic — DRY principle"
- "Non-bracket characters are naturally skipped since I only handle ( [ { ) ] }"
- "List comprehension makes the final step clean and readable"
- "Could optimize with early exit if you don't need all results"

---

## Part 2: Two Pointers

### Problem 3: Merge Sorted Lists (Easy)

**Problem:**

```
Given two sorted lists, merge them into one sorted list.

Input:
list1 = [1, 2, 5]
list2 = [2, 4, 6]

Output: [1, 2, 2, 4, 5, 6]

Bonus: Time complexity?
```

**Before You Code — Say This Out Loud:**

> "Classic two pointer problem. I maintain a pointer for each list and always pick the smaller element. When one list is exhausted, I append the rest of the other list."

**Solution:**

```python
def merge_sorted(list1: list, list2: list) -> list:
    """
    Merge two sorted lists into one sorted list.
  
    Approach: Two pointers — compare heads, take the smaller.
    Time: O(n + m) where n = len(list1), m = len(list2)
    Space: O(n + m) for the result list
    """
    merged = []
    i, j = 0, 0
  
    # Compare elements from both lists
    while i < len(list1) and j < len(list2):
        if list1[i] <= list2[j]:
            merged.append(list1[i])
            i += 1
        else:
            merged.append(list2[j])
            j += 1
  
    # Append remaining elements
    merged.extend(list1[i:])
    merged.extend(list2[j:])
  
    return merged


# Test cases
print(merge_sorted([1, 2, 5], [2, 4, 6]))   # [1, 2, 2, 4, 5, 6]
print(merge_sorted([], [1, 2, 3]))           # [1, 2, 3] (edge: empty list)
print(merge_sorted([1], [2]))                # [1, 2] (edge: single elements)
print(merge_sorted([1, 2, 3], []))           # [1, 2, 3] (edge: empty list)
```

**Talking Points:**

- "Time complexity: O(n + m) — we visit each element exactly once"
- "Space complexity: O(n + m) — the merged result"
- "The extend at the end is O(k) where k is remaining elements — very efficient"
- "Could also do this with heapq.merge() in Python but that's a library call"
- "If asked to do in-place: would need a different approach"

---

### Problem 12: Even/Odd Ordering (Array/Two Pointers)

**Problem:**

```
Given a list of numbers, order them so that
even numbers come first, odd numbers last.

Input:  [1, 2, 3, 4, 5, 6]
Output: [2, 4, 6, 1, 3, 5]  (or any even/odd ordering)
```

**Before You Code — Say This Out Loud:**

> "Two approaches: Simple filter or in-place two pointers. Filter is cleaner but uses O(n) extra space. Two pointers can do it in-place O(1) space. I'll ask which is preferred, then show both."

**Solution 1: Filter (Simple, Readable)**

```python
def even_odd_order(nums: list) -> list:
    """
    Order list so evens come before odds.
  
    Approach: Filter evens and odds separately, concatenate.
    Time: O(n)
    Space: O(n)
    """
    evens = [n for n in nums if n % 2 == 0]
    odds  = [n for n in nums if n % 2 != 0]
    return evens + odds


# Test cases
print(even_odd_order([1, 2, 3, 4, 5, 6]))   # [2, 4, 6, 1, 3, 5]
print(even_odd_order([1, 3, 5]))             # [1, 3, 5] (edge: all odds)
print(even_odd_order([2, 4, 6]))             # [2, 4, 6] (edge: all evens)
print(even_odd_order([]))                    # [] (edge: empty)
```

**Solution 2: Two Pointers In-Place (Optimal Space)**

```python
def even_odd_order_inplace(nums: list) -> list:
    """
    In-place ordering — evens first, odds last.
  
    Approach: Two pointers — left seeks odd, right seeks even, swap.
    Time: O(n)
    Space: O(1)
    """
    left, right = 0, len(nums) - 1
  
    while left < right:
        while left < right and nums[left] % 2 == 0:
            left += 1              # Skip evens on left
        while left < right and nums[right] % 2 != 0:
            right -= 1             # Skip odds on right
  
        if left < right:
            nums[left], nums[right] = nums[right], nums[left]
            left += 1
            right -= 1
  
    return nums


# Test cases
print(even_odd_order_inplace([1, 2, 3, 4, 5, 6]))  # [6, 2, 4, 3, 5, 1]
```

**Talking Points:**

- "Filter approach is more readable, two-pointer is more space efficient"
- "For a coding round I'd start with filter (cleaner), then optimize if asked"
- "In-place version doesn't preserve original order of evens/odds"
- "% 2 == 0 checks for even — works for negatives too (-4 % 2 == 0)"

---

## Part 3: Math / Hash Map

### Problem 4: Find the Missing Number (Easy)

**Problem:**

```
Array of integers, nums of length n spanning 0 to n with one missing.
Return the missing number.

Constraint: O(n) time required.

Input: [3, 0, 1]
Output: 2
```

**Before You Code — Say This Out Loud:**

> "Two approaches: Math or Hash Set. Math is O(n) time and O(1) space — sum of 0 to n is n*(n+1)/2, subtract actual sum. Hash Set is O(n) time but O(n) space. I'll use math since it's more elegant."

**Solution (Math — Optimal):**

```python
def missing_number(nums: list) -> int:
    """
    Find the missing number in range 0 to n.
  
    Approach: Math — expected sum minus actual sum.
    Time: O(n)
    Space: O(1)
    """
    n = len(nums)
    expected_sum = n * (n + 1) // 2   # Sum of 0 to n
    actual_sum = sum(nums)             # Sum of actual array
    return expected_sum - actual_sum


# Test cases
print(missing_number([3, 0, 1]))          # 2
print(missing_number([0, 1]))             # 2 (edge: missing last)
print(missing_number([1]))               # 0 (edge: missing first)
print(missing_number([0]))               # 1 (edge: single element)
```

**Alternative Solution (Hash Set):**

```python
def missing_number_hash(nums: list) -> int:
    """
    Approach: Hash Set
    Time: O(n)
    Space: O(n)
    """
    num_set = set(nums)
    for i in range(len(nums) + 1):
        if i not in num_set:
            return i
```

**Talking Points:**

- "Math approach is O(n) time AND O(1) space — strictly better"
- "The formula n*(n+1)/2 is Gauss's sum formula"
- "Integer division // avoids floating point issues"
- "Hash set approach is also valid but uses O(n) space"
- "XOR approach also works: XOR all indices with all nums, remaining = missing"

---

## Part 4: Intervals / Math

### Problem 5: Rectangle Overlap (Easy)

**Problem:**

```
Given two rectangles a and b defined by 4 corner points,
determine if they overlap.

Note: Bordering or sharing a corner counts as overlapping.
Note: Points are in no particular order.

a = [(-3,5), (-3,2), (0,5), (0,2)]
b = [(-1,4), (3,4), (3,1), (-1,1)]
```

**Before You Code — Say This Out Loud:**

> "Two rectangles DON'T overlap if one is completely to the left, right, above, or below the other. So I'll find the bounding box of each rectangle — min/max x and y — then check the overlap condition."

**Solution:**

```python
def rectangle_overlap(a: list, b: list) -> bool:
    """
    Check if two rectangles overlap.
    Points can be in any order.
  
    Approach: Find bounding boxes, check overlap condition.
    Time: O(1) — fixed 4 points each
    Space: O(1)
    """
    # Find bounding box of rectangle a
    a_min_x = min(p[0] for p in a)
    a_max_x = max(p[0] for p in a)
    a_min_y = min(p[1] for p in a)
    a_max_y = max(p[1] for p in a)
  
    # Find bounding box of rectangle b
    b_min_x = min(p[0] for p in b)
    b_max_x = max(p[0] for p in b)
    b_min_y = min(p[1] for p in b)
    b_max_y = max(p[1] for p in b)
  
    # Rectangles DO NOT overlap if:
    # a is completely left of b: a_max_x < b_min_x
    # a is completely right of b: a_min_x > b_max_x
    # a is completely below b: a_max_y < b_min_y
    # a is completely above b: a_min_y > b_max_y
    no_overlap = (
        a_max_x < b_min_x or
        a_min_x > b_max_x or
        a_max_y < b_min_y or
        a_min_y > b_max_y
    )
  
    return not no_overlap


# Test cases
a = [(-3,5), (-3,2), (0,5), (0,2)]
b = [(-1,4), (3,4), (3,1), (-1,1)]
print(rectangle_overlap(a, b))  # True (they overlap)

# Edge: touching border
c = [(0,2), (0,0), (2,2), (2,0)]
d = [(2,2), (2,0), (4,2), (4,0)]
print(rectangle_overlap(c, d))  # True (share border)

# Edge: no overlap
e = [(0,0), (0,1), (1,0), (1,1)]
f = [(2,2), (2,3), (3,2), (3,3)]
print(rectangle_overlap(e, f))  # False
```

**Talking Points:**

- "I'm using the complement — it's easier to check when they DON'T overlap"
- "Four conditions for no overlap: left, right, above, below"
- "The problem says borders count as overlap — so I use < not <= in no_overlap conditions"
- "Points in any order: min/max handles this naturally"
- "Time O(1) — always 4 points each, constant work"

---

## Part 5: Hash Map + String

### Problem 6: String Mapping (Easy)

**Problem:**

```
Given two strings, determine if there's a one-to-one (bijection)
mapping between characters at the same position.

string1 = 'qwe', string2 = 'asd' → True  (q→a, w→s, e→d)
string1 = 'donut', string2 = 'fatty' → ?
```

**Before You Code — Say This Out Loud:**

> "I need to check two things: first, each character in string1 always maps to the same character in string2. Second, it's a bijection — so two different chars in string1 can't map to the same char in string2. I'll use two dictionaries — one for each direction."

**Solution:**

```python
def str_map(string1: str, string2: str) -> bool:
    """
    Check if there's a bijection between characters of two strings.
  
    Approach: Two hash maps — one for each direction.
    Time: O(n)
    Space: O(k) where k = unique characters
    """
    if len(string1) != len(string2):
        return False
  
    s1_to_s2 = {}   # string1 char → string2 char
    s2_to_s1 = {}   # string2 char → string1 char (bijection check)
  
    for c1, c2 in zip(string1, string2):
        # Check string1 → string2 mapping
        if c1 in s1_to_s2:
            if s1_to_s2[c1] != c2:
                return False         # Same c1 maps to different c2
        else:
            s1_to_s2[c1] = c2
  
        # Check string2 → string1 mapping (bijection)
        if c2 in s2_to_s1:
            if s2_to_s1[c2] != c1:
                return False         # Different c1s map to same c2
        else:
            s2_to_s1[c2] = c1
  
    return True


# Test cases
print(str_map('qwe', 'asd'))    # True  (q→a, w→s, e→d)
print(str_map('donut', 'fatty'))# False (d→f, o→a, n→t, u→t conflict)
print(str_map('aa', 'bb'))      # True  (a→b, a→b)
print(str_map('ab', 'aa'))      # False (a→a, b→a: two chars map to same)
print(str_map('abc', 'ab'))     # False (length mismatch)
```

**Talking Points:**

- "Bijection requires checking both directions — this is the key insight"
- "Without reverse check: 'ab' → 'aa' would incorrectly return True"
- "zip() naturally handles same-position pairing"
- "Two dicts: s1_to_s2 checks consistency, s2_to_s1 checks injectivity"
- "Could use a set of seen pairs as a cleaner approach"

---

### Problem 7: Append Frequency (Medium)

**Problem:**

```
Given a sentence, return the same string with each character
followed by its occurrence count. Skip spaces and discard_list chars.

sentence = "Interview Query"
discard_list = ['I', 'e']

inject_frequency(sentence, discard_list) → "In1t1er2v1i1ew1 Q1u1er2y1"
```

**Before You Code — Say This Out Loud:**

> "Two steps: first count frequencies of all valid characters (not spaces, not in discard_list). Then rebuild the string, appending the count after each character — but only if it's not in the discard_list and not a space."

**Solution:**

```python
from collections import Counter

def inject_frequency(sentence: str, discard_list: list) -> str:
    """
    Append frequency of each character to the string.
    Skip spaces and characters in discard_list.
  
    Approach: Counter for frequencies, then rebuild string.
    Time: O(n)
    Space: O(k) where k = unique characters
    """
    discard_set = set(discard_list)   # O(1) lookup
  
    # Count frequencies of all non-space characters
    freq = Counter(c for c in sentence if c != ' ')
  
    # Rebuild string with frequency appended
    result = []
    for char in sentence:
        if char == ' ':
            result.append(char)           # Keep spaces as-is
        elif char in discard_set:
            result.append(char)           # Keep discarded chars, no count
        else:
            result.append(char + str(freq[char]))  # Append frequency
  
    return ''.join(result)


# Test cases
sentence = "Interview Query"
discard_list = ['I', 'e']
print(inject_frequency(sentence, discard_list))
# "In1t1er2v1i1ew1 Q1u1er2y1"

# Edge: all chars discarded
print(inject_frequency("abc", ['a', 'b', 'c']))
# "abc"

# Edge: empty string
print(inject_frequency("", []))
# ""
```

**Talking Points:**

- "Counter gives me all frequencies in one pass"
- "discard_set for O(1) lookup instead of O(n) list search"
- "Three cases: space (keep), discarded (keep without count), normal (append count)"
- "join() at end is more efficient than string concatenation in a loop"
- "Case sensitivity matters — 'I' and 'i' are different characters"

---

---

# 🟢 TIER 5 — STRINGS, LINKED LISTS, TREES, GRAPHS, HEAP

---

## Part 15: Strings & Arrays

### Problem 14: Add Two Numbers as Strings

**Problem:**

```
Given two non-negative integers represented as strings,
return their sum as a string. (No int() conversion allowed)

add_strings("123", "456") → "579"
add_strings("99", "1")    → "100"
```

**Solution:**

```python
def add_strings(num1: str, num2: str) -> str:
    """
    Add two numbers represented as strings.
  
    Approach: Simulate grade-school addition from right to left.
    Time: O(max(n, m))
    Space: O(max(n, m))
    """
    i, j = len(num1) - 1, len(num2) - 1
    carry = 0
    result = []
  
    while i >= 0 or j >= 0 or carry:
        digit1 = ord(num1[i]) - ord('0') if i >= 0 else 0
        digit2 = ord(num2[j]) - ord('0') if j >= 0 else 0
  
        total = digit1 + digit2 + carry
        carry = total // 10
        result.append(str(total % 10))
  
        i -= 1
        j -= 1
  
    return ''.join(reversed(result))


# Test
print(add_strings("123", "456"))   # "579"
print(add_strings("99", "1"))      # "100"
print(add_strings("0", "0"))       # "0"
print(add_strings("999", "1"))     # "1000"
```

---

### Problem 15: Reverse String / Palindrome

**Reverse String:**

```python
def reverse_string(s: str) -> str:
    """Reverse a string. Time O(n), Space O(n)"""
    return s[::-1]


def reverse_string_inplace(s: list) -> None:
    """Reverse list of chars in-place. Time O(n), Space O(1)"""
    left, right = 0, len(s) - 1
    while left < right:
        s[left], s[right] = s[right], s[left]
        left += 1
        right -= 1
```

**Palindrome Check:**

```python
def is_palindrome(s: str) -> bool:
    """
    Check if string is a palindrome.
    Ignores non-alphanumeric, case-insensitive.
  
    Time: O(n), Space: O(1)
    """
    left, right = 0, len(s) - 1
  
    while left < right:
        # Skip non-alphanumeric
        while left < right and not s[left].isalnum():
            left += 1
        while left < right and not s[right].isalnum():
            right -= 1
  
        if s[left].lower() != s[right].lower():
            return False
  
        left += 1
        right -= 1
  
    return True


# Test
print(is_palindrome("racecar"))              # True
print(is_palindrome("A man a plan a canal Panama"))  # True
print(is_palindrome("hello"))               # False
print(is_palindrome(""))                    # True (edge)
```

---

### Problem 16: FizzBuzz — CreditKarma Variant

**Problem:**

```
For numbers 1 to n:
- Print "CreditKarma" for multiples of both 5 and 7
- Print "Credit" for multiples of 5
- Print "Karma" for multiples of 7
- Otherwise print the number
```

**Solution:**

```python
def credit_karma_fizzbuzz(n: int) -> list:
    """
    FizzBuzz variant with Credit Karma branding.
    Time: O(n), Space: O(n)
    """
    result = []
  
    for i in range(1, n + 1):
        if i % 5 == 0 and i % 7 == 0:
            result.append("CreditKarma")
        elif i % 5 == 0:
            result.append("Credit")
        elif i % 7 == 0:
            result.append("Karma")
        else:
            result.append(str(i))
  
    return result


# Test
print(credit_karma_fizzbuzz(35))
# 35 is divisible by both 5 and 7 → "CreditKarma"
# 5 → "Credit", 10 → "Credit", 15 → "Credit"
# 7 → "Karma", 14 → "Karma", 21 → "Karma"
```

---

## Part 16: Linked Lists

### Linked List Node (Use This Every Time)

```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

# Helper to build list from array
def build_list(arr: list) -> ListNode:
    if not arr:
        return None
    head = ListNode(arr[0])
    curr = head
    for val in arr[1:]:
        curr.next = ListNode(val)
        curr = curr.next
    return head

# Helper to print list
def print_list(head: ListNode) -> list:
    result = []
    while head:
        result.append(head.val)
        head = head.next
    return result
```

---

### Problem 17: Reverse Linked List

**Solution:**

```python
def reverse_linked_list(head: ListNode) -> ListNode:
    """
    Reverse a linked list in-place.
  
    Approach: Three pointers — prev, curr, next
    Time: O(n), Space: O(1)
    """
    prev = None
    curr = head
  
    while curr:
        next_node = curr.next   # Save next
        curr.next = prev        # Reverse pointer
        prev = curr             # Move prev forward
        curr = next_node        # Move curr forward
  
    return prev  # prev is new head


# Test
head = build_list([1, 2, 3, 4, 5])
reversed_head = reverse_linked_list(head)
print(print_list(reversed_head))   # [5, 4, 3, 2, 1]
```

**Walkthrough:**

```
Initial: 1 → 2 → 3 → None
Step 1:  None ← 1   2 → 3
Step 2:  None ← 1 ← 2   3
Step 3:  None ← 1 ← 2 ← 3
Return:  3 → 2 → 1 → None
```

---

### Problem 18: Add Two Numbers (Linked List)

**Problem:**

```
Two numbers stored in linked lists in REVERSE order.
Add them and return the sum as a linked list.

Input:  l1 = 2→4→3 (represents 342)
        l2 = 5→6→4 (represents 465)
Output: 7→0→8       (represents 807)
```

**Solution:**

```python
def add_two_numbers(l1: ListNode, l2: ListNode) -> ListNode:
    """
    Add two numbers represented as reversed linked lists.
  
    Approach: Simulate addition with carry.
    Time: O(max(n, m)), Space: O(max(n, m))
    """
    dummy = ListNode(0)   # Dummy head for clean code
    curr = dummy
    carry = 0
  
    while l1 or l2 or carry:
        val1 = l1.val if l1 else 0
        val2 = l2.val if l2 else 0
  
        total = val1 + val2 + carry
        carry = total // 10
        curr.next = ListNode(total % 10)
        curr = curr.next
  
        if l1: l1 = l1.next
        if l2: l2 = l2.next
  
    return dummy.next


# Test
l1 = build_list([2, 4, 3])   # 342
l2 = build_list([5, 6, 4])   # 465
result = add_two_numbers(l1, l2)
print(print_list(result))     # [7, 0, 8] → 807
```

---

## Part 17: Trees

### Tree Node (Use This Every Time)

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

# Helper to build tree from list (level order)
def build_tree(arr: list) -> TreeNode:
    if not arr:
        return None
    root = TreeNode(arr[0])
    queue = [root]
    i = 1
    while queue and i < len(arr):
        node = queue.pop(0)
        if i < len(arr) and arr[i] is not None:
            node.left = TreeNode(arr[i])
            queue.append(node.left)
        i += 1
        if i < len(arr) and arr[i] is not None:
            node.right = TreeNode(arr[i])
            queue.append(node.right)
        i += 1
    return root
```

---

### Problem 19: Validate Binary Search Tree

**Problem:**

```
Given a binary tree, determine if it is a valid BST.

Valid BST rules:
- Left subtree values < node value
- Right subtree values > node value
- Both subtrees are also valid BSTs
```

**Solution:**

```python
def is_valid_bst(root: TreeNode) -> bool:
    """
    Validate a Binary Search Tree.
  
    Approach: DFS with min/max bounds.
    Time: O(n), Space: O(h) where h = tree height
    """
    def validate(node, min_val, max_val):
        if not node:
            return True   # Empty tree is valid
  
        if node.val <= min_val or node.val >= max_val:
            return False  # Violates BST property
  
        return (
            validate(node.left, min_val, node.val) and
            validate(node.right, node.val, max_val)
        )
  
    return validate(root, float('-inf'), float('inf'))


# Test
#     5
#    / \
#   3   7
#  / \
# 2   4
root = build_tree([5, 3, 7, 2, 4])
print(is_valid_bst(root))   # True

#     5
#    / \
#   3   7
#  / \
# 2   6   ← 6 > 5, violates BST
root2 = build_tree([5, 3, 7, 2, 6])
print(is_valid_bst(root2))  # False
```

**Talking Points:**

- "The naive approach of just checking left < root < right is WRONG"
- "Counter-example: right child could be 4 when root is 5 — looks valid locally but isn't"
- "Key insight: every node has a valid range (min_val, max_val)"
- "Going left: max shrinks to current node value"
- "Going right: min expands to current node value"

---

### Problem 20: Maximum Depth of Binary Tree

**Solution:**

```python
def max_depth(root: TreeNode) -> int:
    """
    Find maximum depth of a binary tree.
  
    Approach: DFS — depth = 1 + max(left_depth, right_depth)
    Time: O(n), Space: O(h)
    """
    if not root:
        return 0
  
    left_depth  = max_depth(root.left)
    right_depth = max_depth(root.right)
  
    return 1 + max(left_depth, right_depth)


# Test
root = build_tree([3, 9, 20, None, None, 15, 7])
print(max_depth(root))   # 3

# BFS (iterative) approach
from collections import deque

def max_depth_bfs(root: TreeNode) -> int:
    """BFS level-by-level counting."""
    if not root:
        return 0
  
    queue = deque([root])
    depth = 0
  
    while queue:
        depth += 1
        for _ in range(len(queue)):
            node = queue.popleft()
            if node.left:  queue.append(node.left)
            if node.right: queue.append(node.right)
  
    return depth
```

---

## Part 18: Graphs

### Problem 21: Clone Undirected Graph

**Problem:**

```
Given a reference to a node in a connected undirected graph,
return a deep copy (clone) of the graph.

Each node has a value and a list of neighbors.
```

**Solution:**

```python
class GraphNode:
    def __init__(self, val=0, neighbors=None):
        self.val = val
        self.neighbors = neighbors if neighbors is not None else []


def clone_graph(node: GraphNode) -> GraphNode:
    """
    Deep copy an undirected graph.
  
    Approach: BFS + hash map to track cloned nodes.
    Time: O(V + E), Space: O(V)
    """
    if not node:
        return None
  
    cloned = {}   # original node → cloned node
  
    queue = deque([node])
    cloned[node] = GraphNode(node.val)
  
    while queue:
        curr = queue.popleft()
  
        for neighbor in curr.neighbors:
            if neighbor not in cloned:
                cloned[neighbor] = GraphNode(neighbor.val)
                queue.append(neighbor)
      
            cloned[curr].neighbors.append(cloned[neighbor])
  
    return cloned[node]
```

**Talking Points:**

- "Hash map is critical — maps original to clone, prevents infinite loops in cycles"
- "BFS processes level by level — DFS also works"
- "We clone the node BEFORE adding to queue to avoid duplicates"
- "Time O(V+E) — visit every vertex and edge once"

---

## Part 19: Top K & Intervals

### Problem 22: Top K Frequent Elements

**Problem:**

```
Given an array, return the k most frequent elements.

Input:  nums = [1,1,1,2,2,3], k = 2
Output: [1, 2]
```

**Solution:**

```python
import heapq
from collections import Counter

def top_k_frequent(nums: list, k: int) -> list:
    """
    Return k most frequent elements.
  
    Approach: Counter + heap
    Time: O(n log k), Space: O(n)
    """
    freq = Counter(nums)
  
    # heapq.nlargest picks top k by frequency
    return heapq.nlargest(k, freq.keys(), key=freq.get)


# Test
print(top_k_frequent([1,1,1,2,2,3], 2))   # [1, 2]
print(top_k_frequent([1], 1))              # [1]


# Bucket Sort approach (O(n) — optimal)
def top_k_frequent_bucket(nums: list, k: int) -> list:
    """
    Bucket sort — O(n) time.
    Bucket index = frequency.
    """
    freq = Counter(nums)
    buckets = [[] for _ in range(len(nums) + 1)]
  
    for num, count in freq.items():
        buckets[count].append(num)
  
    result = []
    for i in range(len(buckets) - 1, 0, -1):
        result.extend(buckets[i])
        if len(result) >= k:
            return result[:k]
  
    return result
```

---

### Problem 23: Merge Intervals

**Problem:**

```
Given an array of intervals, merge overlapping ones.

Input:  [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
```

**Solution:**

```python
def merge_intervals(intervals: list) -> list:
    """
    Merge overlapping intervals.
  
    Approach: Sort by start, merge if overlap.
    Time: O(n log n) — sorting
    Space: O(n)
    """
    if not intervals:
        return []
  
    # Sort by start time
    intervals.sort(key=lambda x: x[0])
    merged = [intervals[0]]
  
    for start, end in intervals[1:]:
        last_end = merged[-1][1]
  
        if start <= last_end:          # Overlapping
            merged[-1][1] = max(last_end, end)
        else:                          # No overlap
            merged.append([start, end])
  
    return merged


# Test
print(merge_intervals([[1,3],[2,6],[8,10],[15,18]]))  # [[1,6],[8,10],[15,18]]
print(merge_intervals([[1,4],[4,5]]))                 # [[1,5]] (touching = merge)
print(merge_intervals([[1,4]]))                       # [[1,4]] (single interval)
```

---

---

# 📖 REFERENCE — Read Day Before (May 26 Afternoon)

---

## Part 20: Pressure Management (The Real Fix)

### The 60-Second Rule — Use This For Every Problem

**No matter what the problem is, say this in the first 60 seconds:**

```
1. RESTATE (10 sec):
   "So I need to [restate problem in your own words], is that right?"

2. CLARIFY (15 sec):
   "A few quick questions:
   - What's the input format? [list, string, file?]
   - What should I return? [list, string, bool?]
   - Any edge cases I should handle? [empty, None, duplicates?]"

3. APPROACH (20 sec):
   "My approach is to use [pattern] because [reason].
   The time complexity would be O(...).
   Does that sound reasonable before I start coding?"

4. CODE:
   Start coding. Talk while you type.

5. TEST (15 sec):
   "Let me trace through the example:
   Input [X] → Step 1 gives me [Y] → Step 2 gives me [Z] → Output [result] ✓"
```

---

### If You Blank — Say This

```python
# If you don't know where to start:
"Let me think through this out loud for a moment..."
"The brute force approach would be [X]. Let me see if I can optimize..."
"I'm thinking about using a [hash map / stack / two pointers] here..."

# If you're stuck mid-code:
"I know what I want to achieve here — let me pseudocode it first..."
"Can I take 30 seconds to think through this edge case?"

# If you make a mistake:
"Let me revisit this — I think there's an issue with [X]..."
"Actually, I realize [mistake]. Let me fix that..."
```

---

### What Cost You The Round (And The Fix)

**What likely happened:**

- Histogram felt ambiguous — no single obvious pattern
- Froze because you weren't sure what they wanted
- Silence grew → more pressure → harder to think

**The fix:**

- **Clarify immediately** — "Is this a number histogram or log-based histogram?"
- **Start with brute force** — even a bad solution is better than silence
- **Narrate** — "I'm not sure about the optimal approach yet, but let me start with..."
- **Counter + sorted keys** is the histogram template — memorize it cold

**The histogram template to memorize:**

```python
from collections import Counter

def histogram(data):
    freq = Counter(data)
    for key in sorted(freq.keys()):
        print(f"{key} | {'#' * freq[key]}")
```

**That's it. 4 lines. Know these 4 lines cold.**

---

## Part 21: CoderPad Specific Prep (May 27, 2:00 PM)

### What CoderPad Told You (Read This Carefully)

```
"Questions are basic"               - Easy LeetCode level, don't overthink
"One coding question + design"      - Code AND design combined in one question
"Software Engineering Fundamentals" - The entire theme of the round
"Walk the engineer through process" - Talk out loud always
"Any language"                      - Use Python
"Be mindful of time"                - CoderPad may be timed, move with purpose
"Ask questions"                     - Clarify before coding
```

---

### What "Software Engineering Fundamentals" Means

They will look for:

```
1. Clean readable code       - meaningful names, no magic numbers
2. Modular code              - small focused functions, single responsibility
3. Error handling            - validate inputs, try/except, edge cases
4. OOP basics                - classes, encapsulation, clean interface
5. Time/space complexity     - know your Big O, mention it after solving
6. Testing mindset           - mention test cases, cover normal + edge cases
7. Comments/docstrings       - brief docstring, inline comments on non-obvious logic
```

---

### The Design Element - What to Expect

**Type 1: Class Design**

```
"Design a class that does X"
Example: Design a Rate Limiter, LRU Cache, Task Queue

Approach:
1. Ask what operations do we need?
2. Define class interface first (method signatures)
3. Implement each method
4. Discuss tradeoffs
```

**Type 2: Extend Your Solution**

```
"Now add X functionality to what you built"
Example: You built a pipeline, now add error handling and logging

Approach:
1. Don't rewrite everything
2. Add new functionality cleanly
3. Show you understand extensibility
```

**Type 3: System Design Lite**

```
"How would you design X at scale?"
Example: Design a data pipeline for credit score updates

Approach:
1. Clarify requirements (scale, latency, consistency)
2. High-level components
3. Data flow
4. Tradeoffs
```

---

### Most Likely Design for Credit Karma Context

```python
class CreditScoreTracker:
    """
    Tracks credit scores per user over time.
    Supports updates, history retrieval, and drop detection.
  
    Time: O(1) for update/get, O(n) for history/drop check
    Space: O(n) total entries stored
    """
  
    def __init__(self, drop_threshold: int = 50):
        self._scores = {}               # user_id -> list of (date, score)
        self._threshold = drop_threshold
  
    def update_score(self, user_id: str, score: int, date: str) -> None:
        """Add a new credit score entry for a user."""
        if user_id not in self._scores:
            self._scores[user_id] = []
        self._scores[user_id].append((date, score))
  
    def get_current_score(self, user_id: str) -> int:
        """Return the most recent credit score."""
        if user_id not in self._scores:
            raise ValueError(f"User {user_id} not found")
        return self._scores[user_id][-1][1]
  
    def get_history(self, user_id: str) -> list:
        """Return full score history as list of (date, score) tuples."""
        if user_id not in self._scores:
            raise ValueError(f"User {user_id} not found")
        return self._scores[user_id]
  
    def has_significant_drop(self, user_id: str) -> bool:
        """Check if score dropped by threshold between any two consecutive entries."""
        history = self.get_history(user_id)
        if len(history) < 2:
            return False
        for i in range(1, len(history)):
            if history[i-1][1] - history[i][1] >= self._threshold:
                return True
        return False


# Test
tracker = CreditScoreTracker()
tracker.update_score("user1", 750, "2026-01-01")
tracker.update_score("user1", 680, "2026-02-01")
tracker.update_score("user1", 620, "2026-03-01")

print(tracker.get_current_score("user1"))     # 620
print(tracker.has_significant_drop("user1"))  # True (750-680=70 >= 50)
```

---

### Software Engineering Fundamentals Template

Use this structure for EVERY problem on CoderPad:

```python
class Solution:
    def solve(self, input_data):
        """
        Brief description of approach.
        Time: O(n)
        Space: O(n)
        """
        # Step 1: Validate input
        if not input_data:
            return []
  
        # Step 2: Core logic
        result = self._process(input_data)
  
        # Step 3: Return
        return result
  
    def _process(self, data):
        """Private helper - single responsibility."""
        pass
```

---

### CoderPad Environment Tips

```
1. Interviewer sees everything you type in real time
   - No hiding, no silent restart
   - Type comments before code to show thinking

2. Run your code early and often
   - Don't wait until the end
   - Fix errors out loud: "Let me fix that syntax..."

3. Don't delete and restart
   - Comment out old approach
   - Iterate on what you have

4. Time awareness
   - Note time after clarifying
   - If stuck 5+ minutes say: "Let me try a different approach"

5. Comments as you think
   # Step 1: count frequencies
   # Step 2: find top k
   Shows thought process even before code works
```

---

### What "Basic" Actually Means

Credit Karma said the questions are basic. Expect:

```
Most likely:
- String manipulation (reverse, palindrome, anagram)
- Array/list operations (find duplicates, sort, filter)
- Hash map counting (frequency, pairs)
- Simple OOP (design a class with 3-4 methods)
- Maybe: basic recursion, simple tree

Unlikely:
- Advanced graph algorithms
- Complex DP
- Bit manipulation
- Segment trees
```

The histogram that caught you last time IS basic by their definition.
The fix is not harder prep, it is better structure and communication.

---

### 60-Second Rule for CoderPad

```
READ (30 sec):     Read fully before saying anything
CLARIFY (30 sec):  Input/output format? Edge cases? Constraints?
APPROACH (1 min):  State pattern + complexity, ask "does that sound good?"
CODE (5-10 min):   Write docstring first, talk while typing
TEST (2 min):      Run it, trace through example, test one edge case
DESIGN (2-3 min):  "In production I would also add...", "The tradeoff here is..."
```

---

### Day Before (May 26)

- [ ] Read Part 20 (Pressure Management)
- [ ] Read this Part 21 (CoderPad specific)
- [ ] Practice 60-second rule out loud on one problem
- [ ] Review OOP Bank Account problem
- [ ] Review histogram 4-line template cold
- [ ] Sleep well

### Day Of (May 27)

- [ ] Read Part 21 one more time in the morning
- [ ] Join CoderPad 2 minutes early
- [ ] Have water nearby
- [ ] Breathe, smile, talk out loud

---

**The questions are basic. The differentiator is HOW you communicate while solving.**
**Structure + clarity + clean code = strong signal.**

**Go crush it.**

---

## Part 7: Collaborative Interview Framework

### How to Structure Every Problem

**Step 1: Clarify (30 seconds)**

```
"Before I start, let me make sure I understand the problem..."
- Restate the problem in your own words
- Ask about edge cases: empty input? negative numbers? duplicates?
- Confirm expected output format
```

**Step 2: Approach (1-2 minutes)**

```
"My approach would be..."
- State the pattern you'll use (stack, hash map, two pointers)
- Explain WHY this pattern fits
- Mention time/space complexity upfront
- Ask if they want a different approach
```

**Step 3: Code (5-10 minutes)**

```
While coding:
- Name variables meaningfully
- Add comments for non-obvious logic
- Talk through what each section does
- "I'm using a stack here because..."
- "This handles the edge case where..."
```

**Step 4: Test (2-3 minutes)**

```
After coding:
- Walk through the example manually
- Test edge cases: empty, single element, all same values
- "Let me trace through with the given example..."
```

**Step 5: Discuss (1-2 minutes)**

```
After testing:
- Confirm time and space complexity
- Mention alternative approaches
- "One optimization would be..."
- "If the input were sorted, we could..."
```

---

## Part 8: Pattern Cheat Sheet

### Stack Pattern

```python
stack = []
stack.append(item)    # Push
stack.pop()           # Pop (removes and returns top)
stack[-1]             # Peek (top without removing)
not stack             # Check if empty
```

### Hash Map Pattern

```python
from collections import Counter, defaultdict

# Counter
freq = Counter(arr)
freq.most_common(k)   # Top k items

# defaultdict
d = defaultdict(int)  # Default value 0
d[key] += 1

# Regular dict
d = {}
d.get(key, default)   # Safe get
```

### Two Pointers Pattern

```python
left, right = 0, len(arr) - 1
while left < right:
    if condition:
        left += 1
    else:
        right -= 1
```

### String Operations

```python
''.join(list)         # Build string from list
Counter(s)            # Char frequencies
zip(s1, s2)           # Pair characters
s.lower()             # Lowercase
```

---

## Part 9: Edge Cases to Always Check

For EVERY problem, mention these:

```python
# 1. Empty input
if not nums:
    return []

# 2. Single element
if len(nums) == 1:
    return nums[0]

# 3. All same elements
[1, 1, 1, 1]

# 4. Already sorted / reverse sorted
[1, 2, 3] or [3, 2, 1]

# 5. Negative numbers
[-1, -2, 0, 1]

# 6. None / null
if nums is None:
    return None
```

---

## Part 10: Key Phrases for Collaborative Round

**Starting a problem:**

> "Let me make sure I understand — the input is X and I need to return Y, is that right?"

**Before coding:**

> "My approach is to use a [stack/hash map/two pointers] because [reason]. The time complexity would be O(n). Does that sound good before I start coding?"

**While coding:**

> "I'm using a dictionary here for O(1) lookup..."
> "This handles the edge case where the input is empty..."
> "I'm going to add a comment here to make this clearer..."

**After coding:**

> "Let me trace through the example to verify..."
> "Time complexity is O(n), space complexity is O(n)..."
> "One optimization would be [X] but I kept it readable for now..."

**If stuck:**

> "Let me think through this out loud..."
> "I'm considering two approaches: [A] and [B]. [A] is simpler but [B] is more efficient..."
> "Could you give me a hint about whether I should focus on time or space optimization?"

---

## Part 11: Study Schedule (May 25–26)

> Full battle plan with checkboxes is in `_Claude.Credit_Karma_Tracking.md`. This is a quick reference summary.

**NIGHT 1 — Monday May 25 (All-Nighter):**

| Phase | Topic                   | What                                                                                                     |
| ----- | ----------------------- | -------------------------------------------------------------------------------------------------------- |
| 1     | Python Fundamentals     | Part 0 — decorators, OOP, lambda, comprehensions, error handling                                        |
| 2     | Tier 1: Confirmed Asked | Bank Account, Robot class (Part 10b), Number of Islands, Robot Grid, DP patterns                         |
| 3     | Tier 2: Weak Spot       | Histogram 4-line template (write from memory), HTTP Log parsing                                          |
| 4     | Tier 3: New Problems    | Two Sum, Valid Anagram + Group Anagrams, Sliding Window, Sieve, Find Duplicates                          |
| 5     | Tier 4: Core            | Rain Water, Brackets, Merge Sorted, Missing Number, Rectangle, String Mapping, Append Freq, Even/Odd     |
| 6     | Tier 5: Rapid Scan      | Add Two Numbers, Reverse String, FizzBuzz, Reverse LL, Validate BST, Clone Graph, Top K, Merge Intervals |

**NIGHT 2 — Tuesday May 26 from 5 PM (All-Nighter):**

| Block    | Action                                                                                                 |
| -------- | ------------------------------------------------------------------------------------------------------ |
| 5–7 PM  | Redo anything blanked on from Night 1. Re-read Histogram + Bank Account + Robot class                  |
| 7–9 PM  | 3 mock problems out loud with 15-min timer each                                                        |
| 9–11 PM | Read Part 20 (Pressure Management), Part 21 (CoderPad Tips), Part 10 (Key Phrases), Part 7 (Framework) |
| 11 PM+   | Skim `_Claude.Credit_Karma_Python_cheat_sheet.md`, tick off Final Checklist, no new problems         |

**INTERVIEW DAY — Wednesday May 27:**

- Read cheat sheet once (15 min max)
- Read Part 10 Key Phrases + Part 20 Pressure Management
- Do one warm-up problem out loud (Balanced Brackets)
- Join CoderPad 2 min early

---

## Part 12: Resume Talking Points (If Asked About Experience)

**Data Engineering + Python:**

> "At Susquehanna I've built production Python pipelines for years — 800+ automated processes, config-driven PySpark frameworks, CDC-to-Kafka streaming. Python is my primary language for data engineering."

**Problem Solving:**

> "Working in a quantitative trading environment, correctness and performance both matter. I'm used to debugging complex data issues under time pressure."

**Scale:**

> "My pipelines process millions of financial transactions daily — I'm comfortable reasoning about time and space complexity in production contexts."

---

---

## Part 22: Real Interview Reports (Internet)

### Report 1 — Charlotte, NC (via recruiter, form screening first)

> "Create a robot class object with methods"

**What they want:** A `Robot` class with movement or state methods — OOP fundamentals. Same pattern as Bank Account: private state, public methods, clean interface.

**Likely follow-ups:** Add boundaries, track history, reset state.

> Full implementation with code + follow-up answers is in **Part 10b (Tier 1)** above — Problem 12: Robot Class OOP.

---

### Report 2 — Nov 2025 (via recruiter, technical interview)

> "OOP question to add, delete accounts and check balance. Follow-ups were easy too."

**This is exactly Problem 10 (Bank Account) — already solved in Part 8.**

Key things to say out loud before coding:

> "I'll create two classes — `Account` for a single account and `BankSystem` to manage multiple. I'll encapsulate balance as private, validate all inputs, and raise clear errors for bad operations."

**Follow-up answers to have ready:**

| Follow-up                   | Answer                                                                        |
| --------------------------- | ----------------------------------------------------------------------------- |
| Add transaction history     | Add `self._transactions = []`, append on deposit/withdraw                   |
| Interest calculation        | `@classmethod` or scheduled method on `Account`                           |
| Concurrent access           | "In production I'd use locks or a DB transaction — for now, single-threaded" |
| Persist to disk             | `json.dump(self._accounts)` or a DB layer                                   |
| What if account_id is None? | Add `if not account_id: raise ValueError(...)` to `add_account`           |

**What the follow-ups test:** Can you extend your own code without breaking it? Can you reason about edge cases you didn't originally handle?

---

### Takeaways from These Reports

1. **Robot class and Bank Account are confirmed repeats** — know both cold
2. **The pattern is always the same:** class with private state + public methods + error handling
3. **Follow-ups test extensibility** — write your class so adding a method is easy
4. **Form screening first** is possible — prepare a written summary of your approach too
