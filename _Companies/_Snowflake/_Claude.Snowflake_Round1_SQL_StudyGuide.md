# SQL INTERVIEW GUIDE

## Complete Reference for Data Engineer Interviews

---

## Table of Contents

1. [Window Functions (Analytical Functions)](#1-window-functions-analytical-functions)
2. [String, Date, and Number Functions](#2-string-date-and-number-functions)
3. [Conditional Logic (CASE, DECODE)](#3-conditional-logic)
4. [NULL Handling](#4-null-handling)
5. [Recursive CTEs](#5-recursive-ctes)
6. [Query Optimization &amp; Performance](#6-query-optimization--performance)
7. [Stored Procedures &amp; Functions](#7-stored-procedures--functions)
8. [Common Interview Questions](#8-common-interview-questions)
   - [8.1 Find Duplicates](#81-find-duplicates)
   - [8.2 Delete Duplicates](#82-delete-duplicates)
   - [8.3 Second Highest Salary](#83-second-highest-salary)
   - [8.4 Running Total](#84-running-total)
   - [8.5 Moving Average](#85-moving-average)
   - [8.6 Month-over-Month Change](#86-month-over-month-change)
   - [8.7 Pivot and Unpivot](#87-pivot-and-unpivot-basic)
   - [8.8 Pivot with Aggregation and Total Column](#88-pivot-with-aggregation-and-total-column)
   - [8.9 Gap and Island — Consecutive Date Ranges](#89-gap-and-island--consecutive-date-ranges)
   - [8.10 Longest Consecutive Streak](#810-longest-consecutive-streak-of-score-increases)
   - [8.11 Self-Join Pattern](#811-self-join-pattern)
   - [8.12 Generate a Number Sequence](#812-generate-a-number-sequence)
   - [8.13 Generate a Date Series](#813-generate-a-date-series)
   - [8.14 Traverse an Organizational Hierarchy](#814-traverse-an-organizational-hierarchy)
   - [8.15 Fibonacci Sequence](#815-fibonacci-sequence)
   - [8.16 Friends of Friends (Graph Traversal)](#816-friends-of-friends-graph-traversal)
   - [8.17 Top N per Group](#817-top-n-per-group)
   - [8.18 String Aggregation (LISTAGG)](#818-string-aggregation-listagg)
   - [8.19 Subtotals with ROLLUP and CUBE](#819-subtotals-with-rollup-and-cube)
   - [8.20 Records in One Table but Not Another](#820-records-in-one-table-but-not-another)
   - [8.21 Median and Percentile](#821-median-and-percentile)
   - [8.22 CONNECT BY — Oracle Hierarchical Queries](#822-connect-by--oracle-hierarchical-queries)
   - [8.23 MERGE (Upsert)](#823-merge-upsert)
   - [8.24 Sessionization — Detect User Sessions](#824-sessionization--detect-user-sessions)
9. [Trick Questions &amp; SQL Gotchas](#9-trick-questions--sql-gotchas)
   - [9.1 NULL Traps](#91-null-traps)
   - [9.2 JOIN Traps](#92-join-traps)
   - [9.3 Filtering &amp; Ordering Traps](#93-filtering--ordering-traps)
   - [9.4 Aggregation Traps](#94-aggregation-traps)
   - [9.5 Set Operation Traps](#95-set-operation-traps)
   - [9.6 Type &amp; Conversion Traps](#96-type--conversion-traps)

---

# 1. Window Functions (Analytical Functions)

## Overview

Window functions perform calculations across a set of rows related to the current row without collapsing the result set like GROUP BY.

**Reference:** [Oracle Analytical Functions](https://oracle-base.com/articles/misc/analytic-functions)

## 1.1 Basic Syntax

```sql
function_name([arguments]) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
    [frame_clause]
)
```

## 1.2 Aggregate Window Functions

### AVG() with Window Functions

**Simple partition average:**

```sql
SELECT 
    employee_id,
    name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary
FROM employees;
```

**Running average (cumulative):**

```sql
SELECT 
    employee_id,
    name,
    salary,
    AVG(salary) OVER (
        PARTITION BY department 
        ORDER BY salary
    ) AS avg_salary_sofar
FROM employees;
```

**Difference between RANGE and ROWS:**

```sql
-- RANGE: Groups by value (default behavior)
SELECT 
    employee_id,
    salary,
    AVG(salary) OVER (
        PARTITION BY department 
        ORDER BY salary 
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS range_avg
FROM employees;

-- ROWS: Processes row by row
SELECT 
    employee_id,
    salary,
    AVG(salary) OVER (
        PARTITION BY department 
        ORDER BY salary 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS rows_avg
FROM employees;
```

**💡 Interview Tip:**

- **RANGE** treats rows with the same ORDER BY value as a single group
- **ROWS** processes each row individually
- If multiple rows have salary = 50000, RANGE includes all of them, ROWS processes one at a time

## 1.3 FIRST_VALUE and LAST_VALUE

### Getting first and last values in partition

```sql
-- First value (ignore nulls)
SELECT 
    department,
    employee_id,
    salary,
    FIRST_VALUE(salary IGNORE NULLS) OVER (
        PARTITION BY department 
        ORDER BY salary ASC NULLS LAST
    ) AS lowest_dept_salary
FROM employees;

-- Previous and next row values
SELECT 
    employee_id,
    salary,
    FIRST_VALUE(salary) OVER (
        ORDER BY salary 
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS previous_salary,
    LAST_VALUE(salary) OVER (
        ORDER BY salary 
        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ) AS next_salary
FROM employees;
```

**💡 Interview Tip:** Always specify frame clause with LAST_VALUE, otherwise it defaults to `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, which won't give you the expected last value.

## 1.4 Ranking Functions

### RANK vs DENSE_RANK vs ROW_NUMBER

```sql
SELECT 
    employee_id,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department 
        ORDER BY salary DESC
    ) AS rank_with_gaps,
    DENSE_RANK() OVER (
        PARTITION BY department 
        ORDER BY salary DESC
    ) AS rank_consecutive,
    ROW_NUMBER() OVER (
        PARTITION BY department 
        ORDER BY salary DESC
    ) AS unique_row_number
FROM employees;
```

**Example Output:**

```
EMPLOYEE  DEPT  SALARY  RANK  DENSE_RANK  ROW_NUMBER
-------------------------------------------------------
101       IT    90000    1        1           1
102       IT    90000    1        1           2
103       IT    85000    3        2           3
104       IT    80000    4        3           4
```

**💡 Interview Tip:**

- **RANK()**: Leaves gaps after ties (1, 1, 3, 4)
- **DENSE_RANK()**: No gaps (1, 1, 2, 3)
- **ROW_NUMBER()**: Always unique (1, 2, 3, 4)

### Aggregate Ranking Functions

```sql
-- Find rank of specific value within the dataset
SELECT 
    RANK(2000) WITHIN GROUP (ORDER BY salary) AS salary_rank,
    DENSE_RANK(2000) WITHIN GROUP (ORDER BY salary) AS salary_dense_rank
FROM employees;
```

## 1.5 Distribution Functions

### PERCENT_RANK and NTILE

```sql
SELECT 
    employee_id,
    salary,
    -- Percentile rank (0 to 1)
    PERCENT_RANK() OVER (ORDER BY salary) AS percentile,
    -- Divide into N equal buckets
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile,
    NTILE(10) OVER (ORDER BY salary) AS salary_decile
FROM employees;
```

**💡 Interview Tip:**

- `PERCENT_RANK()` returns 0 for the first row and 1 for the last row
- `NTILE(N)` divides results into N roughly equal groups
- Useful for quartile/decile analysis in data distribution

## 1.6 LAG and LEAD Functions

### Access previous and next rows

```sql
SELECT 
    order_date,
    revenue,
    -- Previous row (default offset = 1)
    LAG(revenue) OVER (ORDER BY order_date) AS prev_day_revenue,
    -- Next row
    LEAD(revenue) OVER (ORDER BY order_date) AS next_day_revenue,
    -- With default value for NULLs
    LAG(revenue, 1, 0) OVER (ORDER BY order_date) AS prev_revenue_with_default,
    -- Calculate day-over-day change
    revenue - LAG(revenue) OVER (ORDER BY order_date) AS daily_change,
    -- Calculate percentage change
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY order_date)) * 100.0 / 
        LAG(revenue) OVER (ORDER BY order_date), 
        2
    ) AS pct_change
FROM daily_sales
ORDER BY order_date;
```

**💡 Common Interview Question:** Calculate year-over-year growth

```sql
SELECT 
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS prev_year_revenue,
    revenue - LAG(revenue) OVER (ORDER BY year) AS yoy_growth,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year)) * 100.0 / 
        NULLIF(LAG(revenue) OVER (ORDER BY year), 0),
        2
    ) AS yoy_growth_pct
FROM annual_revenue
ORDER BY year;
```

## 1.7 ROWNUM (Oracle-specific)

```sql
-- Get top 5 rows
SELECT * 
FROM (
    SELECT employee_id, salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 5;

-- Modern alternative (SQL Standard)
SELECT employee_id, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
or
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY; 	-- Skip first 10, then fetch next 5 (pagination)
or
FETCH FIRST 10 PERCENT ROWS ONLY;	-- Top 10% by row count
or
FETCH FIRST 5 ROWS WITH TIES;		-- Include ties at the boundary (returns 5 OR MORE rows if there's a tie at row 5)
```

**💡 Interview Tip:** ROWNUM is assigned before ORDER BY, so always use a subquery when combining them.

---

# 2. String, Date, and Number Functions

## 2.1 ROUND Function

### For Numbers

```sql
-- Round to nearest integer
SELECT ROUND(123.456) FROM dual;          -- Result: 123

-- Round to 2 decimal places
SELECT ROUND(123.456, 2) FROM dual;       -- Result: 123.46

-- Round to nearest hundred
SELECT ROUND(12345.67, -2) FROM dual;     -- Result: 12300

-- Banker's rounding (rounds to even)
SELECT ROUND(2.5) FROM dual;              -- Result: 3
SELECT ROUND(3.5) FROM dual;              -- Result: 4
```

### For Dates

```sql
-- Round to nearest month
SELECT ROUND(DATE '2024-02-20', 'MONTH') FROM dual;  
-- Result: 01-MAR-2024 (20th is past the 15th midpoint)

SELECT ROUND(DATE '2024-02-10', 'MONTH') FROM dual;  
-- Result: 01-FEB-2024 (10th is before the 15th midpoint)

-- Round to nearest day (time component)
SELECT ROUND(TIMESTAMP '2024-02-05 14:30:00') FROM dual; 
-- Result: 06-FEB-2024 (rounds up after noon)

-- Round to nearest year
SELECT ROUND(DATE '2024-08-15', 'YEAR') FROM dual;
-- Result: 01-JAN-2025
```

**💡 Interview Tip:** Date rounding uses midpoint logic:

- Month: 15th is the midpoint
- Day: Noon is the midpoint
- Year: June 30th is the midpoint

## 2.2 TRUNC Function

### Truncate without rounding

```sql
-- Numbers
SELECT TRUNC(123.789, 2) FROM dual;       -- Result: 123.78
SELECT TRUNC(123.789) FROM dual;          -- Result: 123
SELECT TRUNC(12345.67, -2) FROM dual;     -- Result: 12300

-- Dates (set to beginning of period)
SELECT TRUNC(DATE '2024-02-20', 'MONTH') FROM dual;  
-- Result: 01-FEB-2024 (first day of month)

SELECT TRUNC(SYSDATE, 'YEAR') FROM dual;
-- Result: 01-JAN-2024 (first day of year)

SELECT TRUNC(TIMESTAMP '2024-02-05 14:30:00') FROM dual;
-- Result: 05-FEB-2024 00:00:00 (midnight)
```

**💡 Common Use Case:** Generate date ranges for reports

```sql
-- Get all transactions from current month
SELECT *
FROM transactions
WHERE transaction_date >= TRUNC(SYSDATE, 'MONTH')
  AND transaction_date < TRUNC(ADD_MONTHS(SYSDATE, 1), 'MONTH');
```

## 2.3 TRIM Functions

### TRIM, LTRIM, RTRIM

```sql
-- Basic trim (removes spaces from both ends)
SELECT TRIM('  Hello World  ') FROM dual;    -- Result: 'Hello World'

-- Trim leading zeros
SELECT TRIM(LEADING '0' FROM '00012345') FROM dual;   -- Result: '12345'

-- Trim trailing characters
SELECT TRIM(TRAILING 'x' FROM 'Testxx') FROM dual;    -- Result: 'Test'

-- Trim both ends
SELECT TRIM(BOTH 'a' FROM 'abracadabra') FROM dual;   -- Result: 'bracadabr'

-- Default is BOTH
SELECT TRIM('a' FROM 'abracadabra') FROM dual;        -- Result: 'bracadabr'

-- LTRIM - left trim
SELECT LTRIM('  hello  ') FROM dual;                  -- Result: 'hello  '
SELECT LTRIM('xyxyhello', 'xy') FROM dual;            -- Result: 'hello'

-- RTRIM - right trim
SELECT RTRIM('  hello  ') FROM dual;                  -- Result: '  hello'
SELECT RTRIM('helloxyxy', 'xy') FROM dual;            -- Result: 'hello'
```

**💡 Interview Tip:** Use TRIM to clean dirty data before joins or comparisons.

## 2.4 Type Conversion Functions

### TO_NUMBER

```sql
-- Basic conversion
SELECT TO_NUMBER('12345') FROM dual;                  -- Result: 12345

-- With formatting
SELECT TO_NUMBER('$1,234.56', '$999,999.99') FROM dual;  -- Result: 1234.56

-- Clean and convert
SELECT TO_NUMBER(TRIM(TO_CHAR(AVG(amount), '999D99'))) 
FROM transactions;
```

### TO_CHAR

```sql
-- Number to string with formatting
SELECT TO_CHAR(1234.56, '999D99') FROM dual;         -- Result: '1234.56'
SELECT TO_CHAR(1234.56, '$9,999.99') FROM dual;      -- Result: '$1,234.56'
SELECT TO_CHAR(0.85, '0.99') FROM dual;              -- Result: '0.85'

-- Date to string
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual;     -- Result: '2024-02-15'
SELECT TO_CHAR(SYSDATE, 'Day, Month DD, YYYY') FROM dual;  
-- Result: 'Thursday, February 15, 2024'

SELECT TO_CHAR(visit_date, 'YYYY-MM-DD') AS visit_date 
FROM appointments;
```

**Common Format Masks:**

```
Numbers:
  9 - digit position (suppress leading zeros)
  0 - digit position (show leading zeros)
  $ - dollar sign
  , - comma
  . - decimal point
  
Dates:
  YYYY - 4-digit year
  MM - 2-digit month
  DD - 2-digit day
  HH24 - 24-hour format
  MI - minutes
  SS - seconds
  Day - full day name
  Month - full month name
```

### TO_DATE

```sql
-- String to date
SELECT TO_DATE('2024-02-15', 'YYYY-MM-DD') FROM dual;
SELECT TO_DATE('15/02/2024', 'DD/MM/YYYY') FROM dual;
SELECT TO_DATE('Feb 15, 2024', 'Mon DD, YYYY') FROM dual;
```

**💡 Interview Tip:** Always specify format mask to avoid ambiguity and locale issues.

## 2.5 SUBSTR Function

### Extract substrings

```sql
-- SUBSTR(string, start_position, length)

-- From position 6, length 2
SELECT SUBSTR('This is a test', 6, 2) FROM dual;      -- Result: 'is'

-- Negative position (from end)
SELECT SUBSTR('TechOnTheNet', -5, 3) FROM dual;       -- Result: 'heN'

-- From position 3 to end
SELECT SUBSTR('TechOnTheNet', 3) FROM dual;           -- Result: 'chOnTheNet'

-- Last 3 characters
SELECT SUBSTR('TechOnTheNet', -3) FROM dual;          -- Result: 'Net'
```

**💡 Common Interview Question:** Extract domain from email

```sql
SELECT 
    email,
    SUBSTR(email, INSTR(email, '@') + 1) AS domain
FROM users;
```

## 2.6 TRANSLATE and REPLACE

### REPLACE - Simple substitution

```sql
-- Replace substring
SELECT REPLACE('Hello World', 'World', 'SQL') FROM dual;  
-- Result: 'Hello SQL'

-- Remove substring (replace with empty)
SELECT REPLACE('Hello World', ' ', '') FROM dual;   
-- Result: 'HelloWorld'

-- Case-sensitive
SELECT REPLACE('HELLO WORLD', 'hello', 'hi') FROM dual;  
-- Result: 'HELLO WORLD' (no change)
```

### TRANSLATE - Character-by-character substitution

```sql
-- Translate vowels to 'a'
SELECT TRANSLATE('Hello World', 'eo', 'aa') FROM dual; 
-- Result: 'Halla Warld'

-- Remove vowels (translate to 'a' then remove 'a')
SELECT REPLACE(
    TRANSLATE('Hello World', 'AEIOUaeiou', 'aaaaaaaaaa'),
    'a', 
    ''
) FROM dual;
-- Result: 'Hll Wrld'
```

**💡 Interview Tip:**

- **REPLACE**: Substitutes entire string
- **TRANSLATE**: Character-by-character mapping

## 2.7 INSTR Function

### Find position of substring

```sql
-- INSTR(string, substring [, start_position [, occurrence]])

-- Find 'is' (first occurrence)
SELECT INSTR('String', 'is') FROM dual;               -- Result: 4

-- Find 'is' (second occurrence)
SELECT INSTR('String', 'is', 1, 2) FROM dual;         -- Result: 0 (not found)

-- Search from end (last occurrence)
SELECT INSTR('Mississippi', 'is', -1, 1) FROM dual;   -- Result: 5

-- Use in WHERE clause
SELECT * 
FROM customers
WHERE INSTR(email, '@gmail.com') > 0;
```

**💡 Common Pattern:** Check if substring exists

```sql
-- Find emails from specific domain
SELECT email
FROM users
WHERE INSTR(LOWER(email), '@company.com') > 0;
```

## 2.8 LPAD and RPAD

### Pad strings to fixed length

```sql
-- LPAD(string, length, pad_string)

-- Left pad with zeros
SELECT LPAD('123', 6, '0') FROM dual;                 -- Result: '000123'

-- Right pad with asterisks
SELECT RPAD('Test', 10, '*') FROM dual;               -- Result: 'Test******'

-- Format account numbers
SELECT 
    account_id,
    LPAD(account_id, 10, '0') AS formatted_account
FROM accounts;

-- Create visual indicators
SELECT 
    product_name,
    rating,
    RPAD('*', rating, '*') AS star_rating
FROM products;
```

**💡 Common Use Case:** Format report columns

```sql
SELECT 
    RPAD(department, 20, ' ') AS dept,
    LPAD(TO_CHAR(budget), 12, ' ') AS budget
FROM departments;
```

---

# 3. Conditional Logic

## 3.1 DECODE Function (Oracle-specific)

### Simple value mapping

```sql
-- Basic syntax: DECODE(expression, search1, result1, search2, result2, ..., default)

SELECT 
    supplier_id,
    DECODE(supplier_id,
        10000, 'IBM',
        10001, 'Microsoft',
        10002, 'Hewlett Packard',
        'Gateway'                    -- default value
    ) AS supplier_name
FROM suppliers;
```

### Complex logic with DECODE

```sql
-- Find greater date
SELECT DECODE(
    (date1 - date2) - ABS(date1 - date2),  -- Clever trick
    0, date1,                               -- date1 >= date2
    date2                                   -- date2 > date1
) AS greater_date
FROM table_name;

-- Conditional aggregation
SELECT 
    department,
    SUM(DECODE(status, 'ACTIVE', 1, 0)) AS active_count,
    SUM(DECODE(status, 'INACTIVE', 1, 0)) AS inactive_count
FROM employees
GROUP BY department;
```

**💡 Interview Tip:** DECODE is Oracle-specific. Use CASE for standard SQL.

## 3.2 CASE Expressions

### Simple CASE

```sql
-- Simple CASE (equality check only)
SELECT 
    product_id,
    category_id,
    list_price,
    CASE category_id
        WHEN 1 THEN ROUND(list_price * 0.05, 2)  -- CPU: 5% discount
        WHEN 2 THEN ROUND(list_price * 0.10, 2)  -- Video Card: 10% discount
        ELSE ROUND(list_price * 0.08, 2)         -- Others: 8% discount
    END AS discount
FROM products;
```

### Searched CASE (more flexible)

```sql
-- Searched CASE (any boolean expression)
SELECT 
    trip_id,
    status,
    CASE 
        WHEN status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1
        WHEN status = 'completed' THEN 0
        ELSE NULL
    END AS is_cancelled
FROM trips;

-- Multiple conditions
SELECT 
    employee_id,
    salary,
    CASE 
        WHEN salary >= 100000 THEN 'Executive'
        WHEN salary >= 70000 THEN 'Senior'
        WHEN salary >= 50000 THEN 'Mid-level'
        WHEN salary >= 30000 THEN 'Junior'
        ELSE 'Entry-level'
    END AS salary_band
FROM employees;
```

### CASE in aggregations

```sql
-- Pivot-like aggregation
SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN hire_date >= DATE '2023-01-01' THEN 1 ELSE 0 END) AS recent_hires
FROM employees
GROUP BY department;
```

**💡 Common Interview Pattern:** Conditional aggregation without GROUP BY

```sql
-- Calculate metrics with different filters in one query
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) AS completed_revenue,
    SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) AS pending_revenue,
    AVG(CASE WHEN status = 'completed' THEN amount END) AS avg_completed_amount
FROM orders;
```

---

# 4. NULL Handling

## 4.1 COALESCE vs NVL

### COALESCE (SQL Standard)

```sql
-- Returns first non-null value
SELECT 
    employee_id,
    COALESCE(phone_mobile, phone_home, phone_work, 'No phone') AS contact_number
FROM employees;

-- All arguments must be same datatype
SELECT COALESCE(NULL, NULL, 123, 456) FROM dual;     -- Result: 123
```

### NVL (Oracle-specific)

```sql
-- NVL(expression, replacement_value)
SELECT 
    employee_id,
    NVL(commission, 0) AS commission
FROM employees;

-- NVL can have different datatypes (implicit conversion)
SELECT NVL(NULL, 'default') FROM dual;
```

### NVL2 (Oracle-specific)

```sql
-- NVL2(expression, value_if_not_null, value_if_null)
SELECT 
    employee_id,
    NVL2(commission, 'Has Commission', 'No Commission') AS commission_status
FROM employees;
```

**💡 Interview Tip:** COALESCE is SQL standard and more flexible (takes multiple arguments), but all arguments must have compatible datatypes.

## 4.2 NULL Handling in JOINs

```sql
-- Problem: NULLs don't match in joins
SELECT a.id, a.value, b.value
FROM table_a a
LEFT JOIN table_b b ON NVL(a.category, 'UNKNOWN') = NVL(b.category, 'UNKNOWN');

-- Alternative using COALESCE
SELECT a.id, a.value, b.value
FROM table_a a
LEFT JOIN table_b b ON COALESCE(a.category, 'UNKNOWN') = COALESCE(b.category, 'UNKNOWN');
```

## 4.3 NULLIF

```sql
-- NULLIF(expr1, expr2) - returns NULL if expr1 = expr2, else returns expr1

-- Avoid division by zero
SELECT 
    total_sales / NULLIF(total_orders, 0) AS avg_order_value
FROM sales_summary;

-- Convert specific value to NULL
SELECT 
    employee_id,
    NULLIF(status, 'UNKNOWN') AS status
FROM employees;
```

---

# 5. Recursive CTEs

## 5.1 Basic Recursive CTE Structure

```sql
WITH cte_name (columns) AS (
    -- Anchor member (non-recursive part)
    SELECT ...
    FROM base_table
    WHERE initial_condition
  
    UNION ALL
  
    -- Recursive member
    SELECT ...
    FROM base_table
    INNER JOIN cte_name ON join_condition
    WHERE termination_condition
)
SELECT * FROM cte_name;
```

## 5.2 Number Sequence Generation

```sql
-- Generate numbers 1 to 10
WITH number_sequence (n) AS (
    -- Anchor: Start with 1
    SELECT 1 FROM dual
  
    UNION ALL
  
    -- Recursive: Add 1 until we reach 10
    SELECT n + 1
    FROM number_sequence
    WHERE n < 10
)
SELECT n FROM number_sequence;
```

**💡 Common Use Case:** Generate date series

```sql
-- Generate all dates in a month
WITH date_series AS (
    SELECT DATE '2024-02-01' AS dt
    FROM dual
  
    UNION ALL
  
    SELECT dt + 1
    FROM date_series
    WHERE dt < DATE '2024-02-29'
)
SELECT dt FROM date_series;
```

## 5.3 Organizational Hierarchy

```sql
-- Employee hierarchy with path tracking
WITH employee_hierarchy (
    employee_id, 
    employee_name, 
    manager_id, 
    level_num, 
    path
) AS (
    -- Anchor: Start with CEO (no manager)
    SELECT 
        employee_id,
        employee_name,
        manager_id,
        1 AS level_num,
        employee_name AS path
    FROM employees
    WHERE manager_id IS NULL
  
    UNION ALL
  
    -- Recursive: Find direct reports
    SELECT 
        e.employee_id,
        e.employee_name,
        e.manager_id,
        eh.level_num + 1,
        eh.path || ' > ' || e.employee_name
    FROM employees e
    INNER JOIN employee_hierarchy eh 
        ON e.manager_id = eh.employee_id
)
SELECT 
    LPAD(' ', (level_num - 1) * 2, ' ') || employee_name AS org_chart,
    level_num,
    path
FROM employee_hierarchy
ORDER BY path;
```

**💡 Interview Tip:** Always include a termination condition to prevent infinite recursion.

## 5.4 Fibonacci Sequence

```sql
-- Generate Fibonacci numbers
WITH fibonacci (n, fib_curr, fib_next) AS (
    -- Anchor: F(0)=0, F(1)=1
    SELECT 
        1 AS n,
        0 AS fib_curr,
        1 AS fib_next
    FROM dual
  
    UNION ALL
  
    -- Recursive: F(n) = F(n-1) + F(n-2)
    SELECT 
        n + 1,
        fib_next,
        fib_curr + fib_next
    FROM fibonacci
    WHERE n < 10
)
SELECT 
    n,
    fib_curr AS fibonacci_number
FROM fibonacci;
```

**Result:**

```
N   FIBONACCI_NUMBER
-------------------
1   0
2   1
3   1
4   2
5   3
6   5
7   8
8   13
9   21
10  34
```

## 5.5 Graph Traversal

```sql
-- Find all connections (friends of friends)
WITH connections (user_id, friend_id, degree, path) AS (
    -- Anchor: Direct friends (degree 1)
    SELECT 
        user_id,
        friend_id,
        1 AS degree,
        CAST(user_id || '->' || friend_id AS VARCHAR2(1000)) AS path
    FROM friendships
    WHERE user_id = 123  -- Starting user
  
    UNION ALL
  
    -- Recursive: Friends of friends
    SELECT 
        c.user_id,
        f.friend_id,
        c.degree + 1,
        c.path || '->' || f.friend_id
    FROM connections c
    INNER JOIN friendships f ON c.friend_id = f.user_id
    WHERE c.degree < 3  -- Limit to 3 degrees of separation
      AND INSTR(c.path, f.friend_id) = 0  -- Avoid cycles
)
SELECT DISTINCT friend_id, MIN(degree) AS closest_degree
FROM connections
GROUP BY friend_id
ORDER BY closest_degree, friend_id;
```

---

# 6. Query Optimization & Performance

## 6.1 Execution Plan Analysis

### Key Metrics to Examine

**1. Row Estimates vs Actual Rows**

```sql
-- Check if optimizer estimates are accurate
EXPLAIN PLAN FOR
SELECT * FROM employees WHERE department_id = 10;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

**Things to look for:**

- Large discrepancy between estimated and actual rows
- Indicates stale statistics or poor cardinality estimation

**2. I/O Reads**

- Physical reads from disk (slow)
- Logical reads from memory (fast)
- Goal: Minimize physical reads

**3. Access Methods**

- Full Table Scan: Reads entire table
- Index Range Scan: Uses index efficiently
- Index Full Scan: Reads entire index
- Index Unique Scan: Single row via unique index

**4. Step Duration**

- Identify which step takes longest
- Focus optimization efforts there

## 6.2 Using EXPLAIN PLAN

### Basic Usage

```sql
-- Generate explain plan
EXPLAIN PLAN FOR
SELECT e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 50000;

-- View the plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- More detailed plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, NULL, 'ALL'));
```

### Reading the Plan

```
Plan hash value: 1234567890

-----------------------------------------------------------------------
| Id  | Operation           | Name       | Rows | Bytes | Cost (%CPU)|
-----------------------------------------------------------------------
|   0 | SELECT STATEMENT    |            |  100 |  5000 |    10  (10)|
|   1 |  NESTED LOOPS       |            |  100 |  5000 |    10  (10)|
|*  2 |   TABLE ACCESS FULL | EMPLOYEES  |  100 |  4000 |     5  (20)|
|*  3 |   INDEX UNIQUE SCAN | DEPT_PK    |    1 |    10 |     1   (0)|
-----------------------------------------------------------------------
```

**💡 Interview Tips:**

- Read from bottom to top and inside out
- Look for expensive operations (high cost)
- Check for full table scans on large tables
- Verify indexes are being used

## 6.3 Common Performance Issues

### Issue 1: Missing Statistics

```sql
-- Gather table statistics
ANALYZE TABLE employees COMPUTE STATISTICS;

-- For better accuracy
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCHEMA_NAME', 'EMPLOYEES');

-- Check when statistics were last gathered
SELECT table_name, last_analyzed 
FROM user_tables
WHERE table_name = 'EMPLOYEES';
```

### Issue 2: Function on Indexed Column

```sql
-- Bad: Function prevents index usage
SELECT * FROM employees
WHERE UPPER(last_name) = 'SMITH';

-- Good: Use function-based index or rewrite
SELECT * FROM employees
WHERE last_name = 'SMITH';  -- Assumes consistent case

-- Or create function-based index
CREATE INDEX emp_upper_name_idx ON employees(UPPER(last_name));
```

### Issue 3: Implicit Type Conversion

```sql
-- Bad: employee_id is NUMBER, but comparing to string
SELECT * FROM employees
WHERE employee_id = '12345';

-- Good: Explicit conversion
SELECT * FROM employees
WHERE employee_id = 12345;
```

### Issue 4: SELECT *

```sql
-- Bad: Retrieves unnecessary columns
SELECT * FROM employees
WHERE department_id = 10;

-- Good: Select only needed columns
SELECT employee_id, employee_name, salary
FROM employees
WHERE department_id = 10;
```

## 6.4 Index Usage Tips

**When to use indexes:**

- High-cardinality columns (many unique values)
- Columns frequently used in WHERE, JOIN, ORDER BY
- Columns with low update frequency

**When NOT to use indexes:**

- Small tables (< 1000 rows)
- Columns with high update frequency
- Low-cardinality columns (few unique values)
- Queries returning >15-20% of table rows

**💡 Interview Tip:** Too many indexes slow down DML operations (INSERT, UPDATE, DELETE).

---

# 7. Stored Procedures & Functions

## 7.1 Basic Structure

### PL/SQL Block Structure

```sql
DECLARE
    -- Variable declarations
    variable_name datatype;
    constant_name CONSTANT datatype := value;
BEGIN
    -- Executable statements
    NULL;  -- Placeholder
EXCEPTION
    -- Exception handling
    WHEN exception_name THEN
        -- Handle exception
END;
/
```

## 7.2 Variables and Constants

```sql
DECLARE
    -- Variables
    v_employee_name VARCHAR2(100);
    v_salary NUMBER(10,2);
    v_hire_date DATE := SYSDATE;
  
    -- Constants
    c_tax_rate CONSTANT NUMBER := 0.15;
    c_company_name CONSTANT VARCHAR2(50) := 'ACME Corp';
  
    -- NOT NULL constraint
    v_department_id NUMBER NOT NULL := 10;
BEGIN
    -- Use variables
    v_employee_name := 'John Doe';
    v_salary := 75000 * (1 - c_tax_rate);
  
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_employee_name);
    DBMS_OUTPUT.PUT_LINE('Net Salary: ' || v_salary);
END;
/
```

## 7.3 Control Structures

### IF-THEN-ELSIF-ELSE

```sql
DECLARE
    v_score NUMBER := 85;
    v_grade VARCHAR2(1);
BEGIN
    IF v_score >= 90 THEN
        v_grade := 'A';
    ELSIF v_score >= 80 THEN
        v_grade := 'B';
    ELSIF v_score >= 70 THEN
        v_grade := 'C';
    ELSIF v_score >= 60 THEN
        v_grade := 'D';
    ELSE
        v_grade := 'F';
    END IF;
  
    DBMS_OUTPUT.PUT_LINE('Grade: ' || v_grade);
END;
/
```

### CASE Statement

```sql
DECLARE
    v_department_id NUMBER := 10;
    v_department_name VARCHAR2(50);
BEGIN
    CASE v_department_id
        WHEN 10 THEN v_department_name := 'Sales';
        WHEN 20 THEN v_department_name := 'IT';
        WHEN 30 THEN v_department_name := 'HR';
        ELSE v_department_name := 'Unknown';
    END CASE;
  
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_department_name);
END;
/
```

### WHILE Loop

```sql
DECLARE
    v_counter NUMBER := 1;
    v_sum NUMBER := 0;
BEGIN
    WHILE v_counter <= 10 LOOP
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
    END LOOP;
  
    DBMS_OUTPUT.PUT_LINE('Sum of 1 to 10: ' || v_sum);
END;
/
```

### FOR Loop

```sql
DECLARE
    v_factorial NUMBER := 1;
BEGIN
    -- Forward loop
    FOR i IN 1..5 LOOP
        v_factorial := v_factorial * i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('5! = ' || v_factorial);
  
    -- Reverse loop
    FOR i IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('Countdown: ' || i);
    END LOOP;
END;
/
```

### Loop Control: EXIT and CONTINUE

```sql
DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        -- Skip even numbers
        IF MOD(v_counter, 2) = 0 THEN
            v_counter := v_counter + 1;
            CONTINUE;  -- Skip to next iteration
        END IF;
  
        DBMS_OUTPUT.PUT_LINE('Odd number: ' || v_counter);
        v_counter := v_counter + 1;
  
        -- Exit condition
        EXIT WHEN v_counter > 10;
    END LOOP;
END;
/
```

## 7.4 Labels and GOTO

```sql
DECLARE
    v_num NUMBER := 5;
BEGIN
    <<check_number>>
    IF v_num > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Positive number');
    ELSIF v_num < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Negative number');
        GOTO end_program;  -- Skip zero check
    ELSE
        DBMS_OUTPUT.PUT_LINE('Zero');
    END IF;
  
    <<end_program>>
    DBMS_OUTPUT.PUT_LINE('Program ended');
END;
/
```

**💡 Interview Tip:** Avoid GOTO - it makes code harder to maintain. Use structured programming instead.

## 7.5 Stored Procedures

### Creating a Procedure

```sql
CREATE OR REPLACE PROCEDURE update_employee_salary (
    p_employee_id IN NUMBER,
    p_raise_pct IN NUMBER,
    p_new_salary OUT NUMBER
) 
IS
    v_current_salary NUMBER;
BEGIN
    -- Get current salary
    SELECT salary INTO v_current_salary
    FROM employees
    WHERE employee_id = p_employee_id;
  
    -- Calculate and update
    p_new_salary := v_current_salary * (1 + p_raise_pct / 100);
  
    UPDATE employees
    SET salary = p_new_salary
    WHERE employee_id = p_employee_id;
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('Salary updated from ' || v_current_salary || 
                        ' to ' || p_new_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END update_employee_salary;
/
```

### Calling a Procedure

```sql
-- Method 1: EXEC
EXEC update_employee_salary(101, 10, :new_salary);

-- Method 2: Anonymous block
DECLARE
    v_new_salary NUMBER;
BEGIN
    update_employee_salary(101, 10, v_new_salary);
    DBMS_OUTPUT.PUT_LINE('New salary: ' || v_new_salary);
END;
/
```

## 7.6 Functions

### Creating a Function

```sql
CREATE OR REPLACE FUNCTION calculate_bonus (
    p_employee_id IN NUMBER,
    p_bonus_pct IN NUMBER DEFAULT 10
) 
RETURN NUMBER
IS
    v_salary NUMBER;
    v_bonus NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = p_employee_id;
  
    v_bonus := v_salary * (p_bonus_pct / 100);
  
    RETURN v_bonus;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN -1;
END calculate_bonus;
/
```

### Using a Function

```sql
-- In SELECT statement
SELECT 
    employee_id,
    employee_name,
    salary,
    calculate_bonus(employee_id, 15) AS bonus
FROM employees
WHERE department_id = 10;

-- In PL/SQL
DECLARE
    v_bonus NUMBER;
BEGIN
    v_bonus := calculate_bonus(101, 20);
    DBMS_OUTPUT.PUT_LINE('Bonus: $' || v_bonus);
END;
/
```

**💡 Interview Tip:**

- **Procedures**: Can have OUT parameters, used for DML operations
- **Functions**: Must return a value, can be used in SQL statements, should be deterministic

---

# 8. Common Interview Questions

---

### Duplicates

## 8.1 Find Duplicates

```sql
-- Find duplicate records
SELECT email, COUNT(*) as count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Get all duplicate rows with details
SELECT *
FROM customers c
WHERE email IN (
    SELECT email
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email;

-- Using window function
SELECT *
FROM (
    SELECT 
        c.*,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) as rn
    FROM customers c
)
WHERE rn > 1;
```

## 8.2 Delete Duplicates

```sql
-- Keep first occurrence, delete rest
DELETE FROM customers
WHERE ROWID NOT IN (
    SELECT MIN(ROWID)
    FROM customers
    GROUP BY email
);

-- Using window function (Oracle)
DELETE FROM customers
WHERE ROWID IN (
    SELECT rid FROM (
        SELECT 
            ROWID as rid,
            ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) as rn
        FROM customers
    )
    WHERE rn > 1
);
```

---

### Ranking & Top-N

## 8.3 Second Highest Salary

```sql
-- Using subquery
SELECT MAX(salary) as second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Using DENSE_RANK
SELECT salary
FROM (
    SELECT 
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) as rank
    FROM employees
)
WHERE rank = 2;

-- Using FETCH FIRST (Oracle 12c+)
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
OFFSET 1 ROW FETCH NEXT 1 ROW ONLY;
```

---

### Window Functions — Running Aggregates

## 8.4 Running Total

```sql
SELECT 
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY order_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM daily_sales
ORDER BY order_date;
```

## 8.5 Moving Average

```sql
-- 7-day moving average
SELECT 
    order_date,
    revenue,
    AVG(revenue) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7day
FROM daily_sales
ORDER BY order_date;
```

---

### Window Functions — LAG / LEAD

## 8.6 Month-over-Month Change

**Table: credit_score_history**

| user_id | score_month | credit_score |
| ------- | ----------- | ------------ |
| 1       | 2024-01     | 620          |
| 1       | 2024-02     | 635          |
| 1       | 2024-03     | 630          |
| 1       | 2024-04     | 650          |
| 2       | 2024-01     | 700          |
| 2       | 2024-02     | 710          |
| 2       | 2024-03     | 725          |
| 3       | 2024-01     | 580          |
| 3       | 2024-02     | 570          |
| 3       | 2024-03     | 560          |

For each user show: current score, previous month's score, change, and a trend label ('Increased' / 'Decreased' / 'No Change'). Only include rows where a previous month exists.

**Expected output:**

| user_id | score_month | credit_score | prev_score | change | trend     |
| ------- | ----------- | ------------ | ---------- | ------ | --------- |
| 1       | 2024-02     | 635          | 620        | +15    | Increased |
| 1       | 2024-03     | 630          | 635        | -5     | Decreased |
| 1       | 2024-04     | 650          | 630        | +20    | Increased |
| 2       | 2024-02     | 710          | 700        | +10    | Increased |
| 2       | 2024-03     | 725          | 710        | +15    | Increased |
| 3       | 2024-02     | 570          | 580        | -10    | Decreased |
| 3       | 2024-03     | 560          | 570        | -10    | Decreased |

```sql
WITH cte AS (
    SELECT 
        user_id,
        score_month,
        credit_score,
        LAG(credit_score, 1) OVER (PARTITION BY user_id ORDER BY score_month) AS prev_score
    FROM credit_score_history
)
SELECT 
    user_id,
    score_month,
    credit_score,
    prev_score,
    (credit_score - prev_score) AS change,
    CASE
        WHEN credit_score > prev_score THEN 'Increased'
        WHEN credit_score < prev_score THEN 'Decreased'
        ELSE 'No Change'
    END AS trend
FROM cte
WHERE prev_score IS NOT NULL;
```

**Key points:**

- `LAG(credit_score, 1)` fetches the previous row's value within each user's partition
- `WHERE prev_score IS NOT NULL` drops the first row per user which has no prior month
- Every `CASE` column needs a comma separating it from the column before it

---

### Pivot

## 8.7 Pivot and Unpivot (basic)

```sql
-- Native PIVOT syntax (Oracle / SQL Server)
SELECT *
FROM (
    SELECT department, gender
    FROM employees
)
PIVOT (
    COUNT(*)
    FOR gender IN ('M' AS male, 'F' AS female)
);

-- Manual pivot using CASE (works everywhere)
SELECT 
    department,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM employees
GROUP BY department;
```

## 8.8 Pivot with Aggregation and Total Column

**Table: sales** (multiple transactions per product per month)

| sale_id | product | month | revenue |
| ------- | ------- | ----- | ------- |
| 1       | Apple   | Jan   | 60      |
| 2       | Apple   | Jan   | 40      |
| 3       | Apple   | Feb   | 150     |
| 4       | Apple   | Mar   | 200     |
| 5       | Mango   | Jan   | 80      |
| 6       | Mango   | Feb   | 50      |
| 7       | Mango   | Feb   | 40      |
| 8       | Mango   | Mar   | 110     |
| 9       | Banana  | Feb   | 70      |
| 10      | Banana  | Mar   | 90      |

Pivot revenue by month, show 0 (not NULL) for missing months, add a total column, order by total descending.

**Expected output:**

| product | Jan | Feb | Mar | total |
| ------- | --- | --- | --- | ----- |
| Apple   | 100 | 150 | 200 | 450   |
| Mango   | 80  | 90  | 110 | 280   |
| Banana  | 0   | 70  | 90  | 160   |

```sql
SELECT
    product,
    SUM(CASE WHEN month = 'Jan' THEN revenue ELSE 0 END) AS Jan,
    SUM(CASE WHEN month = 'Feb' THEN revenue ELSE 0 END) AS Feb,
    SUM(CASE WHEN month = 'Mar' THEN revenue ELSE 0 END) AS Mar,
    SUM(revenue)                                          AS total
FROM sales
GROUP BY product
ORDER BY total DESC;

or 

SELECT *
FROM sales
PIVOT (
    SUM(revenue)
    FOR month IN ('Jan', 'Feb', 'Mar')
)
ORDER BY total DESC;
```

**Key points:**

- `CASE WHEN ... ELSE 0` ensures missing months show 0 instead of NULL
- `SUM(revenue)` for the total column needs no CASE — it aggregates all rows for that product
- Everything is driven by a single `GROUP BY product`

---

### Gaps & Islands

## 8.9 Gap and Island — Consecutive Date Ranges

```sql
WITH numbered_dates AS (
    SELECT 
        visit_date,
        ROW_NUMBER() OVER (ORDER BY visit_date) as rn,
        visit_date - ROW_NUMBER() OVER (ORDER BY visit_date) as grp
    FROM visits
)
SELECT 
    MIN(visit_date) as start_date,
    MAX(visit_date) as end_date,
    COUNT(*) as consecutive_days
FROM numbered_dates
GROUP BY grp
ORDER BY start_date;
```

## 8.10 Longest Consecutive Streak of Score Increases

**Same table: credit_score_history**

Find, for each user, the longest streak of consecutive months where their credit score increased.

**Example (user 1):**

| score_month | credit_score | Increased?   |
| ----------- | ------------ | ------------ |
| 2024-01     | 620          | — (no prev) |
| 2024-02     | 635          | Yes (+15)    |
| 2024-03     | 640          | Yes (+5)     |
| 2024-04     | 630          | No (-10)     |
| 2024-05     | 645          | Yes (+15)    |
| 2024-06     | 660          | Yes (+15)    |
| 2024-07     | 675          | Yes (+15)    |

Streaks: Feb–Mar = 2, May–Jul = 3 → longest = **3**

**The island detection trick — why `rn_all - rn_inc` works:**

```
All rows (rn_all):       1  2  3  4  5  6  7
is_increase:             0  1  1  0  1  1  1
                            ↓  ↓     ↓  ↓  ↓
Filtered rows (rn_inc):    1  2     3  4  5

island_id = rn_all - rn_inc:
                           2-1 3-2   5-3 6-4 7-5
                           = 1  = 1  = 2  = 2  = 2  ← constant within each streak
```

Both counters advance together during a streak. When a non-increase row is skipped, `rn_inc` falls behind, shifting the island_id to a new value.

```sql
WITH step1 AS (
    SELECT
        user_id,
        score_month,
        credit_score,
        CASE
            WHEN credit_score > LAG(credit_score) OVER (PARTITION BY user_id ORDER BY score_month)
            THEN 1 ELSE 0
        END AS is_increase,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY score_month) AS rn_all
    FROM credit_score_history
),
step2 AS (
    SELECT
        user_id,
        score_month,
        rn_all,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY score_month) AS rn_inc
    FROM step1
    WHERE is_increase = 1
),
step3 AS (
    SELECT
        user_id,
        (rn_all - rn_inc) AS island_id
    FROM step2
)
SELECT
    user_id,
    MAX(streak_length) AS longest_streak
FROM (
    SELECT
        user_id,
        island_id,
        COUNT(*) AS streak_length
    FROM step3
    GROUP BY user_id, island_id
) streaks
GROUP BY user_id;
```

**Key points:**

- `rn_all` counts all rows per user; `rn_inc` counts only "increased" rows — their difference is the island key
- Inner subquery counts rows per `(user_id, island_id)` to get each streak's length; outer takes the max
- `PARTITION BY user_id` on every window function is required — without it, row numbers span all users

---

### Joins

## 8.11 Self-Join Pattern

```sql
-- Find employees earning more than their manager
SELECT 
    e.employee_name,
    e.salary as employee_salary,
    m.employee_name as manager_name,
    m.salary as manager_salary
FROM employees e
INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
```

---

### Recursive CTEs

## 8.12 Generate a Number Sequence

Write a query to generate all integers from 1 to N (e.g., 1 to 10).

```sql
WITH number_sequence (n) AS (
    SELECT 1 FROM dual

    UNION ALL

    SELECT n + 1
    FROM number_sequence
    WHERE n < 10
)
SELECT n FROM number_sequence;
```

**Key points:**

- The anchor (`SELECT 1 FROM dual`) seeds the recursion
- The recursive branch adds 1 each step; the `WHERE` clause is the termination condition — without it you get an infinite loop
- Oracle does not use the `RECURSIVE` keyword; `WITH` alone is sufficient

---

## 8.13 Generate a Date Series

Write a query that produces every date in February 2024 (2024-02-01 through 2024-02-29).

```sql
WITH date_series AS (
    SELECT DATE '2024-02-01' AS dt
    FROM dual

    UNION ALL

    SELECT dt + 1
    FROM date_series
    WHERE dt < DATE '2024-02-29'
)
SELECT dt FROM date_series;
```

**Key points:**

- Adding an integer to a DATE in Oracle advances it by that many days
- Useful for filling gaps — LEFT JOIN this series against a fact table to surface missing dates
- Change the anchor and stop condition to cover any arbitrary range

---

## 8.14 Traverse an Organizational Hierarchy

Given an `employees` table with `employee_id`, `employee_name`, and `manager_id` (NULL for the root), produce the full org chart showing each employee's level and reporting path.

```sql
WITH employee_hierarchy (
    employee_id,
    employee_name,
    manager_id,
    level_num,
    path
) AS (
    -- Anchor: root node (CEO has no manager)
    SELECT
        employee_id,
        employee_name,
        manager_id,
        1 AS level_num,
        employee_name AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: direct reports of each node already in the CTE
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        eh.level_num + 1,
        eh.path || ' > ' || e.employee_name
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT
    LPAD(' ', (level_num - 1) * 2, ' ') || employee_name AS org_chart,
    level_num,
    path
FROM employee_hierarchy
ORDER BY path;
```

**Key points:**

- `manager_id IS NULL` identifies the single root; adjust if your data has multiple roots
- `path` concatenation lets you detect cycles and audit the full chain
- `LPAD` indentation is a quick visual aid — level 1 = no indent, level 2 = 2 spaces, etc.
- Always include a termination condition (`WHERE` in recursive branch or a depth limit) to prevent infinite recursion on cyclic data

---

## 8.15 Fibonacci Sequence

Generate the first 10 Fibonacci numbers using a recursive CTE.

```sql
WITH fibonacci (n, fib_curr, fib_next) AS (
    -- Anchor: F(0)=0, F(1)=1
    SELECT
        1         AS n,
        0         AS fib_curr,
        1         AS fib_next
    FROM dual

    UNION ALL

    -- Recursive: shift the window forward by one
    SELECT
        n + 1,
        fib_next,
        fib_curr + fib_next
    FROM fibonacci
    WHERE n < 10
)
SELECT n, fib_curr AS fibonacci_number
FROM fibonacci;
```

**Expected output:**

```
N   FIBONACCI_NUMBER
-------------------
1   0
2   1
3   1
4   2
5   3
6   5
7   8
8   13
9   21
10  34
```

**Key points:**

- Carry two columns (`fib_curr`, `fib_next`) so each row has everything it needs to produce the next
- The recursive branch does `fib_curr = fib_next`, `fib_next = fib_curr + fib_next` — a sliding window of two consecutive values
- `WHERE n < 10` is the termination condition; change to control how many terms to generate

---

## 8.16 Friends of Friends (Graph Traversal)

Given a `friendships` table with `user_id` and `friend_id`, find all users reachable from user 123 within 3 degrees of separation, and return the closest degree for each.

```sql
WITH connections (user_id, friend_id, degree, path) AS (
    -- Anchor: direct friends (degree 1)
    SELECT
        user_id,
        friend_id,
        1 AS degree,
        CAST(user_id || '->' || friend_id AS VARCHAR2(1000)) AS path
    FROM friendships
    WHERE user_id = 123

    UNION ALL

    -- Recursive: friends of friends
    SELECT
        c.user_id,
        f.friend_id,
        c.degree + 1,
        c.path || '->' || f.friend_id
    FROM connections c
    INNER JOIN friendships f ON c.friend_id = f.user_id
    WHERE c.degree < 3
      AND INSTR(c.path, f.friend_id) = 0  -- prevent revisiting nodes
)
SELECT DISTINCT
    friend_id,
    MIN(degree) AS closest_degree
FROM connections
GROUP BY friend_id
ORDER BY closest_degree, friend_id;
```

**Key points:**

- The `path` string doubles as a visited-node guard — `INSTR(c.path, f.friend_id) = 0` stops cycles
- `MIN(degree)` in the outer query collapses duplicate paths to the shortest one
- `WHERE c.degree < 3` caps traversal depth; increase for wider searches
- `VARCHAR2(1000)` — use Oracle's native string type, not `VARCHAR`

---

### Aggregation

## 8.17 Top N per Group

Find the top 3 highest-paid employees within each department.

```sql
SELECT *
FROM (
    SELECT
        employee_id,
        employee_name,
        department,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
WHERE rnk <= 3;
```

**Key points:**

- Use `ROW_NUMBER` when you want exactly N rows even if there are ties — arbitrary tiebreaking
- Use `RANK` when ties should all be included — can return more than N rows
- Use `DENSE_RANK` when you want exactly rank ≤ N with no gaps — same tie behavior as RANK but consecutive numbers
- The subquery is required because window functions cannot appear directly in a `WHERE` clause

---

## 8.18 String Aggregation (LISTAGG)

Concatenate all employee names within each department into one comma-separated string.

```sql
SELECT
    department,
    LISTAGG(employee_name, ', ') WITHIN GROUP (ORDER BY employee_name) AS employee_list
FROM employees
GROUP BY department;
```

With distinct values (Oracle 19c+):

```sql
SELECT
    department,
    LISTAGG(DISTINCT employee_name, ', ') WITHIN GROUP (ORDER BY employee_name) AS employee_list
FROM employees
GROUP BY department;
```

Handle overflow beyond 4000 bytes:

```sql
SELECT
    department,
    LISTAGG(employee_name, ', ' ON OVERFLOW TRUNCATE '...' WITH COUNT)
        WITHIN GROUP (ORDER BY employee_name) AS employee_list
FROM employees
GROUP BY department;
```

**Key points:**

- `WITHIN GROUP (ORDER BY ...)` controls the order of values in the concatenated result
- Default result type is `VARCHAR2(4000)` — use `ON OVERFLOW TRUNCATE` or switch to `XMLAGG` for unlimited length
- `LISTAGG` is Oracle-specific; standard SQL equivalents are `STRING_AGG` (PostgreSQL/SQL Server) and `GROUP_CONCAT` (MySQL)

---

## 8.19 Subtotals with ROLLUP and CUBE

Get revenue totals by region and product, including subtotals and a grand total, in a single query.

**ROLLUP** — hierarchical subtotals (region → grand total):

```sql
SELECT
    CASE WHEN GROUPING(region)  = 1 THEN 'ALL REGIONS'  ELSE region  END AS region,
    CASE WHEN GROUPING(product) = 1 THEN 'ALL PRODUCTS' ELSE product END AS product,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY ROLLUP (region, product)
ORDER BY region NULLS LAST, product NULLS LAST;
```

**CUBE** — every combination (region, product, region+product, grand total):

```sql
SELECT
    CASE WHEN GROUPING(region)  = 1 THEN 'ALL REGIONS'  ELSE region  END AS region,
    CASE WHEN GROUPING(product) = 1 THEN 'ALL PRODUCTS' ELSE product END AS product,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY CUBE (region, product)
ORDER BY region NULLS LAST, product NULLS LAST;
```

**GROUPING SETS** — pick exactly which groupings you need:

```sql
SELECT region, product, SUM(revenue) AS total_revenue
FROM sales
GROUP BY GROUPING SETS (
    (region, product),   -- detail rows
    (region),            -- region subtotals only
    ()                   -- grand total only
);
```

**Key points:**

- `ROLLUP(A, B)` produces `(A,B)`, `(A)`, `()` — one fewer grouping than CUBE
- `CUBE(A, B)` produces all 4 combinations: `(A,B)`, `(A)`, `(B)`, `()`
- Subtotal rows have `NULL` in the rolled-up columns — `GROUPING(col) = 1` tells you it's a subtotal NULL, not a real NULL in the data
- `GROUPING SETS` is the most precise — use it when you want specific combinations without the full ROLLUP/CUBE set

---

## 8.20 Records in One Table but Not Another

Find customers who have never placed an order (three equivalent approaches).

**NOT EXISTS** — best performance in Oracle; short-circuits on first match:

```sql
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

**MINUS** — set difference, removes duplicates automatically:

```sql
SELECT customer_id FROM customers
MINUS
SELECT customer_id FROM orders;
```

**LEFT JOIN with NULL check:**

```sql
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

**Key points:**

- `NOT EXISTS` is the preferred Oracle pattern — the optimizer rewrites it as an anti-join and it handles NULLs correctly
- `MINUS` is clean but returns only the selected columns; join back to `customers` if you need more columns
- `LEFT JOIN ... WHERE IS NULL` can produce duplicate customer rows when `orders` has multiple rows per customer — add `DISTINCT` or use one of the other two forms
- `NOT IN` with a subquery is dangerous when the subquery can return NULLs — a single NULL makes the entire `NOT IN` return no rows

---

## 8.21 Median and Percentile

Find the median salary and the 90th-percentile salary across all employees.

```sql
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary_disc,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY salary) AS p90_salary
FROM employees;
```

As a window function — median per department alongside each row:

```sql
SELECT
    employee_id,
    department,
    salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary)
        OVER (PARTITION BY department) AS dept_median_salary
FROM employees;
```

**Key points:**

- `PERCENTILE_CONT` interpolates between adjacent values — always returns a number even if no exact row has that value
- `PERCENTILE_DISC` returns the first actual data value at or above the percentile — always a value that exists in the dataset
- Fraction: `0` = minimum, `0.5` = median, `1` = maximum
- Both work as aggregate functions (`WITHIN GROUP`) or as analytic functions (`OVER (PARTITION BY ...)`)

---

### Hierarchical (Oracle-specific)

## 8.22 CONNECT BY — Oracle Hierarchical Queries

Oracle's native syntax for traversing parent-child hierarchies — an alternative to recursive CTEs.

**Full org chart:**

```sql
SELECT
    LPAD(' ', (LEVEL - 1) * 2, ' ') || employee_name AS org_chart,
    LEVEL                                             AS level_num,
    SYS_CONNECT_BY_PATH(employee_name, ' > ')         AS path,
    CONNECT_BY_ISLEAF                                 AS is_leaf
FROM employees
START WITH  manager_id IS NULL                    -- root node(s)
CONNECT BY PRIOR employee_id = manager_id         -- parent → child direction
ORDER SIBLINGS BY employee_name;                  -- sort children without breaking hierarchy
```

**Start from a specific node (subtree only):**

```sql
SELECT employee_id, employee_name, LEVEL
FROM employees
START WITH  employee_id = 101
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY employee_name;
```

**Key points:**

- `START WITH` = anchor condition (equivalent to the non-recursive part of a CTE)
- `CONNECT BY PRIOR parent_col = child_col` — `PRIOR` refers to the parent row in the current path
- `LEVEL` pseudo-column: 1 = root, 2 = first-level children, etc.
- `SYS_CONNECT_BY_PATH(col, sep)` builds the full path string from root to current row
- `CONNECT_BY_ISLEAF = 1` identifies leaf nodes (no children); use in `WHERE` to return only leaves
- `ORDER SIBLINGS BY` sorts children at each level without disrupting the hierarchical structure
- Prefer CONNECT BY for simple hierarchy navigation; prefer recursive CTEs for complex multi-step logic

---

### DML Patterns

## 8.23 MERGE (Upsert)

Update an employee's salary if they already exist; insert them if they do not.

```sql
MERGE INTO employees tgt
USING employee_updates src
    ON (tgt.employee_id = src.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        tgt.salary    = src.salary,
        tgt.job_title = src.job_title
WHEN NOT MATCHED THEN
    INSERT (employee_id, employee_name, salary, job_title)
    VALUES (src.employee_id, src.employee_name, src.salary, src.job_title);
```

With Oracle's `DELETE` extension — remove stale records in the same pass:

```sql
MERGE INTO employees tgt
USING employee_updates src
    ON (tgt.employee_id = src.employee_id)
WHEN MATCHED THEN
    UPDATE SET tgt.salary = src.salary
    DELETE WHERE src.active_flag = 'N'    -- delete matched rows that are now inactive
WHEN NOT MATCHED THEN
    INSERT (employee_id, employee_name, salary)
    VALUES (src.employee_id, src.employee_name, src.salary);
```

**Key points:**

- The `ON` clause is the match key — use the natural or surrogate key, not mutable columns
- Both `WHEN MATCHED` and `WHEN NOT MATCHED` are optional — omit either for insert-only or update-only
- Oracle's `DELETE WHERE` clause removes matched rows that meet a condition in the same atomic statement
- A single `MERGE` is far more efficient than a separate `UPDATE` followed by `INSERT`; the source table is scanned once

---

### Advanced Patterns

## 8.24 Sessionization — Detect User Sessions

Given a `page_events` table (`user_id`, `event_time`), group page views into sessions where a new session begins after 30 minutes of inactivity.

```sql
WITH gaps AS (
    SELECT
        user_id,
        event_time,
        LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) AS prev_time
    FROM page_events
),
session_flags AS (
    SELECT
        user_id,
        event_time,
        CASE
            WHEN prev_time IS NULL
              OR (event_time - prev_time) * 24 * 60 > 30   -- gap > 30 minutes
            THEN 1
            ELSE 0
        END AS is_session_start
    FROM gaps
),
session_ids AS (
    SELECT
        user_id,
        event_time,
        SUM(is_session_start) OVER (
            PARTITION BY user_id
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_id
    FROM session_flags
)
SELECT
    user_id,
    session_id,
    MIN(event_time) AS session_start,
    MAX(event_time) AS session_end,
    COUNT(*)        AS event_count
FROM session_ids
GROUP BY user_id, session_id
ORDER BY user_id, session_id;
```

**Key points:**

- `(event_time - prev_time) * 24 * 60` converts Oracle DATE subtraction (fractional days) to minutes; use `EXTRACT` or interval arithmetic with TIMESTAMP columns
- `is_session_start = 1` marks the boundary of each new session; a running `SUM` over that flag produces a monotonically increasing session counter per user
- The first event per user always starts a new session (`prev_time IS NULL`)
- Change the 30-minute threshold to match your product's definition of a session
- This pattern generalizes to any "group by gap" problem — device restarts, order batching, trade windows, etc.

---

## Quick Reference Card

### Must-Know Functions

```sql
-- Ranking
ROW_NUMBER(), RANK(), DENSE_RANK()

-- Analytics
LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()

-- Aggregates
SUM() OVER, AVG() OVER, COUNT() OVER

-- String
SUBSTR(), INSTR(), TRIM(), REPLACE(), TRANSLATE()

-- Date
TRUNC(), ROUND(), TO_DATE(), TO_CHAR()

-- Null Handling
COALESCE(), NVL(), NULLIF()

-- Conditional
CASE, DECODE()
```

### Performance Checklist

- [ ] Statistics up to date?
- [ ] Indexes on join/filter columns?
- [ ] Avoid functions on indexed columns
- [ ] Select only needed columns
- [ ] Check execution plan
- [ ] Use appropriate join type
- [ ] Consider partitioning for large tables

### Common Patterns to Remember

1. **Running totals**: SUM() OVER (ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
2. **Ranking**: DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)
3. **Previous/Next row**: LAG()/LEAD() OVER (ORDER BY ...)
4. **Conditional aggregation**: SUM(CASE WHEN ... THEN 1 ELSE 0 END)
5. **Deduplication**: ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)

---

**Good luck with your SQL interview! 🚀**

---

# 9. Trick Questions & SQL Gotchas

These are semantics traps that interviewers use to test whether you *understand* SQL, not just write it. Each entry shows the broken query, why it fails, and the correct fix.

---

## 9.1 NULL Traps

### Trap 1 — NULL = NULL is never TRUE

```sql
-- WRONG: returns 0 rows even when nulls exist
SELECT * FROM employees WHERE manager_id = NULL;

-- CORRECT
SELECT * FROM employees WHERE manager_id IS NULL;
SELECT * FROM employees WHERE manager_id IS NOT NULL;
```

SQL uses three-valued logic: TRUE, FALSE, and **UNKNOWN**. Any comparison with NULL yields UNKNOWN, which WHERE treats the same as FALSE.

---

### Trap 2 — Joining on a NULL column silently drops rows

```sql
-- Both tables have rows where category IS NULL
-- Those rows will NOT match — NULLs never equal anything, including each other
SELECT a.id, b.value
FROM table_a a
JOIN table_b b ON a.category = b.category;  -- NULL rows silently excluded

-- Fix: substitute a sentinel before joining
SELECT a.id, b.value
FROM table_a a
JOIN table_b b ON NVL(a.category, 'UNKNOWN') = NVL(b.category, 'UNKNOWN');
```

**Interview question:** *"Why does my JOIN return fewer rows than expected?"* — almost always a NULL in the join key.

---

### Trap 3 — NOT IN with a subquery that contains a NULL

```sql
-- If ANY row in orders has customer_id = NULL, this returns ZERO rows
SELECT customer_id
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

-- Fix: filter NULLs out of the subquery
SELECT customer_id
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders WHERE customer_id IS NOT NULL
);

-- Or use NOT EXISTS (handles NULLs correctly by design)
SELECT c.customer_id
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);
```

**Why it breaks:** `x NOT IN (1, 2, NULL)` expands to `x != 1 AND x != 2 AND x != NULL`. The last condition is UNKNOWN, making the whole expression UNKNOWN — no rows pass.

---

### Trap 4 — COUNT(column) vs COUNT(*)

```sql
-- Returns 10 (counts every row)
SELECT COUNT(*) FROM employees;

-- Returns 7 (ignores NULLs in commission column)
SELECT COUNT(commission) FROM employees;

-- AVG also silently ignores NULLs — can be misleading
SELECT AVG(commission) FROM employees;
-- This is the average of non-NULL commissions only, not all employees
-- To include non-commission employees as 0:
SELECT AVG(NVL(commission, 0)) FROM employees;
```

---

### Trap 5 — NULL in CASE WHEN

```sql
-- WRONG: WHEN NULL never matches because NULL = NULL is UNKNOWN
SELECT CASE status WHEN NULL THEN 'Missing' ELSE status END FROM orders;

-- CORRECT: use IS NULL
SELECT CASE WHEN status IS NULL THEN 'Missing' ELSE status END FROM orders;
```

---

### Trap 6 — Concatenating NULL collapses the whole string

```sql
-- In Oracle, NULL || 'anything' = NULL
SELECT first_name || ' ' || last_name AS full_name FROM employees;
-- If last_name is NULL → full_name is NULL, not 'John '

-- Fix
SELECT first_name || ' ' || NVL(last_name, '') AS full_name FROM employees;
-- Or
SELECT TRIM(first_name || ' ' || last_name) AS full_name FROM employees;
-- (TRIM of NULL is NULL — still need NVL if either part can be NULL)
```

---

## 9.2 JOIN Traps

### Trap 7 — Missing ON clause produces a CROSS JOIN

```sql
-- WRONG: forgot the ON clause — every row in A matched to every row in B
SELECT e.name, d.department_name
FROM employees e, departments d;           -- old-style implicit cross join

-- Also wrong with explicit syntax (missing WHERE/ON):
SELECT e.name, d.department_name
FROM employees e CROSS JOIN departments d; -- intentional cross join syntax

-- CORRECT
SELECT e.name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```

100 employees × 10 departments = 1,000 rows returned instead of 100. A classic silent blowup.

---

### Trap 8 — LEFT JOIN result turned into INNER JOIN by WHERE on right table

```sql
-- WRONG: the WHERE kills the outer join — becomes an inner join
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.location = 'New York';  -- employees with no dept (d.* = NULL) fail this filter

-- CORRECT: move the filter into the ON clause
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
                       AND d.location = 'New York';
```

The ON filter is applied before the outer join, so unmatched left rows still appear (with NULL for `department_name`). The WHERE filter is applied after — NULLs fail the condition and the row disappears.

---

### Trap 9 — Duplicates from a one-to-many JOIN

```sql
-- orders has multiple rows per customer
-- This doubles/triples customer rows — a surprise if you only wanted one row per customer
SELECT c.customer_id, c.name, o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- If you only need the latest order per customer, use a subquery or window function
SELECT c.customer_id, c.name, o.order_date
FROM customers c
JOIN (
    SELECT customer_id, MAX(order_date) AS order_date
    FROM orders
    GROUP BY customer_id
) o ON c.customer_id = o.customer_id;
```

---

## 9.3 Filtering & Ordering Traps

### Trap 10 — ROWNUM is assigned before ORDER BY

```sql
-- WRONG: ROWNUM is applied first, then the result is sorted — top 5 is random
SELECT employee_id, salary
FROM employees
WHERE ROWNUM <= 5
ORDER BY salary DESC;

-- CORRECT: sort first in a subquery, then filter ROWNUM
SELECT employee_id, salary
FROM (
    SELECT employee_id, salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 5;

-- Modern Oracle alternative (12c+)
SELECT employee_id, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
```

---

### Trap 11 — WHERE vs HAVING

```sql
-- WRONG: aggregates cannot appear in WHERE
SELECT department, AVG(salary)
FROM employees
WHERE AVG(salary) > 60000      -- ORA-00934: group function not allowed here
GROUP BY department;

-- CORRECT: filter on aggregates with HAVING
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;
```

Execution order: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY`. WHERE runs before grouping, so aggregates don't exist yet.

---

### Trap 12 — NULLs sort position depends on direction

```sql
-- Oracle default: NULLs sort LAST for ASC, FIRST for DESC
SELECT employee_id, salary
FROM employees
ORDER BY salary ASC;   -- NULLs appear at the bottom

SELECT employee_id, salary
FROM employees
ORDER BY salary DESC;  -- NULLs appear at the top

-- Control it explicitly
SELECT employee_id, salary
FROM employees
ORDER BY salary ASC NULLS FIRST;   -- push NULLs to top regardless

SELECT employee_id, salary
FROM employees
ORDER BY salary DESC NULLS LAST;   -- push NULLs to bottom regardless
```

**Interview gotcha:** "Sort employees by salary descending, NULLs last." The default DESC puts NULLs first — you must add `NULLS LAST`.

---

### Trap 13 — BETWEEN is inclusive on both ends

```sql
-- Returns rows where salary = 50000 AND salary = 100000 too
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 100000;
-- Equivalent to: salary >= 50000 AND salary <= 100000

-- Date trap: BETWEEN '2024-01-01' AND '2024-01-31' includes all of Jan 31
-- but a TIMESTAMP of '2024-01-31 14:30:00' also matches
-- Safe date range pattern:
SELECT * FROM orders
WHERE order_date >= DATE '2024-01-01'
  AND order_date <  DATE '2024-02-01';  -- excludes Feb 1 entirely
```

---

## 9.4 Aggregation Traps

### Trap 14 — Non-aggregated column not in GROUP BY (Oracle error)

```sql
-- WRONG: employee_name not in GROUP BY and not aggregated
SELECT department, employee_name, AVG(salary)
FROM employees
GROUP BY department;   -- ORA-00979: not a GROUP BY expression

-- CORRECT option A: add to GROUP BY
SELECT department, employee_name, AVG(salary)
FROM employees
GROUP BY department, employee_name;

-- CORRECT option B: use a window function if you want both detail and aggregate
SELECT department, employee_name, salary,
       AVG(salary) OVER (PARTITION BY department) AS dept_avg
FROM employees;
```

---

### Trap 15 — DISTINCT vs GROUP BY subtle difference

```sql
-- Both return unique department values — equivalent here
SELECT DISTINCT department FROM employees;
SELECT department FROM employees GROUP BY department;

-- But GROUP BY lets you add aggregates; DISTINCT does not
SELECT DISTINCT department, COUNT(*) FROM employees;  -- ORA-00937 error

-- GROUP BY is required when mixing detail and aggregate
SELECT department, COUNT(*) FROM employees GROUP BY department;
```

---

### Trap 16 — SUM / AVG on mixed NULL and zero

```sql
-- Table: scores(student_id, score)  -- some scores are NULL (absent), some are 0 (failed)
SELECT AVG(score) FROM scores;
-- AVG ignores NULLs — absent students don't lower the average
-- A student who scored 0 DOES lower the average

-- If absent should count as 0:
SELECT AVG(NVL(score, 0)) FROM scores;

-- Spot the difference:
SELECT COUNT(*), COUNT(score), SUM(score), AVG(score), AVG(NVL(score,0))
FROM scores;
```

---

## 9.5 Set Operation Traps

### Trap 17 — UNION silently removes duplicates

```sql
-- UNION removes duplicates — can hide data problems
SELECT customer_id FROM table_a
UNION
SELECT customer_id FROM table_b;

-- UNION ALL keeps all rows including duplicates — almost always what you want for combining datasets
SELECT customer_id FROM table_a
UNION ALL
SELECT customer_id FROM table_b;
```

UNION does an implicit `DISTINCT` — it deduplicates the combined result. This is slower (requires a sort) and hides legitimate duplicate values.

---

### Trap 18 — Column count and datatype must match in set operations

```sql
-- WRONG: column count mismatch
SELECT customer_id, name FROM customers
UNION
SELECT order_id FROM orders;   -- ORA-01789: query block has incorrect number of result columns

-- WRONG: datatype mismatch (no implicit conversion in some cases)
SELECT customer_id FROM customers   -- NUMBER
UNION
SELECT order_date FROM orders;      -- DATE — ORA-01790 error

-- Fix: use NULL placeholders with explicit casts to align columns
SELECT customer_id, name, NULL AS order_date FROM customers
UNION ALL
SELECT NULL, NULL, order_date FROM orders;
```

---

### Trap 19 — ORDER BY only allowed once, at the end of set operations

```sql
-- WRONG: can't ORDER BY inside a UNION member
SELECT salary FROM employees ORDER BY salary
UNION ALL
SELECT salary FROM contractors;    -- ORA-00933: SQL command not properly ended

-- CORRECT: one ORDER BY at the very end
SELECT salary FROM employees
UNION ALL
SELECT salary FROM contractors
ORDER BY salary;
```

---

## 9.6 Type & Conversion Traps

### Trap 20 — Implicit type conversion disables index

```sql
-- employee_id is defined as NUMBER
-- WRONG: Oracle implicitly converts employee_id to VARCHAR2 for the comparison
-- This prevents index usage — full table scan
SELECT * FROM employees WHERE employee_id = '12345';

-- CORRECT: compare with the right type — index is used
SELECT * FROM employees WHERE employee_id = 12345;
```

**Interview follow-up:** *"Your query suddenly got slow — nothing changed except someone passed the ID as a string. How?"* — implicit conversion.

---

### Trap 21 — CHAR pads with spaces; VARCHAR2 does not

```sql
-- status column defined as CHAR(10)
-- 'ACTIVE' is stored as 'ACTIVE    ' (padded to 10)
SELECT * FROM orders WHERE status = 'ACTIVE';     -- works (Oracle pads the literal too)
SELECT * FROM orders WHERE status = 'ACTIVE    '; -- also works

-- Trap: trimming a CHAR column before comparing
SELECT * FROM orders WHERE TRIM(status) = 'ACTIVE';  -- disables index

-- Safe pattern: define status as VARCHAR2, not CHAR, unless you need fixed-width storage
```

---

### Trap 22 — DATE arithmetic returns fractional days, not seconds or minutes

```sql
-- DATE subtraction in Oracle returns a NUMBER of days (can be fractional)
SELECT order_date - ship_date AS days_diff FROM orders;   -- e.g. 1.5 = 36 hours

-- WRONG: comparing difference to minutes directly
SELECT * FROM orders WHERE (ship_date - order_date) > 60;  -- 60 days, NOT 60 minutes

-- Convert to minutes
SELECT * FROM orders WHERE (ship_date - order_date) * 24 * 60 > 60;  -- more than 60 minutes

-- With TIMESTAMP columns use EXTRACT for clarity
SELECT EXTRACT(DAY    FROM (ship_ts - order_ts)) AS days,
       EXTRACT(HOUR   FROM (ship_ts - order_ts)) AS hours,
       EXTRACT(MINUTE FROM (ship_ts - order_ts)) AS minutes
FROM orders;
```

---

### Trap 23 — String comparison is case-sensitive by default

```sql
-- 'Smith' ≠ 'smith' ≠ 'SMITH'
SELECT * FROM employees WHERE last_name = 'smith';   -- misses 'Smith'

-- Fix: normalize case
SELECT * FROM employees WHERE LOWER(last_name) = 'smith';

-- Trap: LOWER() on the column prevents index usage unless a function-based index exists
CREATE INDEX emp_lower_name_idx ON employees(LOWER(last_name));
-- Now the function-based index is used
SELECT * FROM employees WHERE LOWER(last_name) = 'smith';
```

---

# 8.25 Snowflake Interview Hard Problems (Tier 1 Priority)

These 6 problems are specifically from the Snowflake Senior DE interview. Solve these first — they cover high-value patterns and will show up in Round 2.

## 8.25.1 Subscription Overlap (Hard)

**Problem:** For each user with a completed subscription (end_date not null), return whether their subscription range overlaps with any **other** completed subscription. Output: `user_id, overlap` (1 or 0).

**Sample data:**

```
user_id  start_date    end_date
1        2019-01-01    2019-01-31
2        2019-01-15    2019-01-17
3        2019-01-29    2019-02-04
4        2019-02-05    2019-02-10

→ users 1, 2, 3 overlap (1↔2, 1↔3); user 4 does not.
```

**Key insight:** Canonical interval overlap: `a.start <= b.end AND b.start <= a.end`. Self-join, exclude self-pairs.

**Solution:**

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

---

## 8.25.2 Flight Records → Flight Routes (Hard)

**Problem:** Create unique location pairs. Treat (Dallas → Seattle) and (Seattle → Dallas) as the same route.

**Solution:**

```sql
SELECT DISTINCT
    LEAST(origin, destination) AS location1,
    GREATEST(origin, destination) AS location2
FROM flights
ORDER BY location1, location2;
```

**Key insight:** LEAST/GREATEST normalizes pairs regardless of input order.

---

## 8.25.3 Paired Products (Hard)

**Problem:** Find top 5 product pairs purchased together by users. Ensure p1 < p2 alphabetically.

**Solution:**

```sql
SELECT
    p1.product_name AS p1,
    p2.product_name AS p2,
    COUNT(*) AS count
FROM transactions p1
INNER JOIN transactions p2
    ON p1.user_id = p2.user_id
    AND p1.product_name < p2.product_name
GROUP BY p1.product_name, p2.product_name
ORDER BY count DESC
LIMIT 5;
```

**Key insight:** `<` enforces ordering and avoids (A,B) and (B,A) duplicates.

---

## 8.25.4 First Touch Attribution (Hard)

**Problem:** For each converted user, return the channel from their **first session ever**.

**Solution:**

```sql
WITH first_session AS (
    SELECT 
        user_id,
        session_date AS first_date,
        channel,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY session_date ASC
        ) AS rn
    FROM sessions
),
first_touch AS (
    SELECT 
        user_id,
        first_date,
        channel
    FROM first_session
    WHERE rn = 1
),
conversions AS (
    SELECT 
        user_id,
        MAX(CASE WHEN converted = 1 THEN session_date END) AS converted_date
    FROM sessions
    GROUP BY user_id
    HAVING MAX(CASE WHEN converted = 1 THEN session_date END) IS NOT NULL
)
SELECT
    c.user_id,
    f.channel   AS first_channel,
    f.first_date,
    c.converted_date
FROM conversions c
JOIN first_touch f ON c.user_id = f.user_id
ORDER BY c.user_id;
```

---

## 8.25.5 Rolling Bank Transactions (Hard)

**Problem:** Compute 3-day rolling average of transaction amounts.

**Solution:**

```sql
SELECT
    TO_CHAR(dt, 'YYYY-MM-DD') AS dt,
    AVG(amount) OVER (
        ORDER BY dt
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_three_day
FROM transactions
ORDER BY dt;
```

**Key insight:** ROWS (positional) vs RANGE (value-based). Use ROWS for "last N days."

---

## 8.25.6 Department Top 3 Salaries (Hard)

**Problem:** For each department, return top 3 distinct salaries with employee count.

**Solution:**

```sql
WITH ranked_salaries AS (
    SELECT
        department,
        salary,
        COUNT(*) AS count,
        DENSE_RANK() OVER (
            PARTITION BY department 
            ORDER BY salary DESC
        ) AS rnk          -- avoid reserved word "rank"
    FROM employees
    GROUP BY department, salary
)
SELECT department, salary, count
FROM ranked_salaries
WHERE rnk <= 3
ORDER BY department, salary DESC;
```

**Key insight:** DENSE_RANK (not ROW_NUMBER) handles ties correctly.
