# SQL INTERVIEW GUIDE

---

## Cheat Sheet

**1. Analytical Functions**

```sql
    - https://oracle-base.com/articles/misc/analytic-functions
    - AVG(sal) OVER (PARTITION BY deptno) AS avg_dept_sal
    - AVG(sal) OVER (PARTITION BY deptno ORDER BY sal) AS avg_dept_sal_sofar
    - AVG(sal) OVER (PARTITION BY deptno ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS range_avg  		-- Same as above, generate average by the value
    - AVG(sal) OVER (PARTITION BY deptno ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rows_avg		-- It will generate avg by row
    - FIRST_VALUE(sal IGNORE NULLS) OVER (PARTITION BY deptno ORDER BY sal ASC NULLS LAST) AS first_val_in_dept
    - FIRST_VALUE(sal) OVER (ORDER BY sal ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_sal,
    - LAST_VALUE(sal) OVER (ORDER BY sal ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS next_sal
	- CURRENT ROW				-- 3 options
	- 1 / UNBOUNDED PRECEDING
	- 1 / UNBOUNDED FOLLOWING
    - rank() over (partition by deptno order by sal) as myrank
    - dense_rank() over (partition by deptno order by sal) as myrank 	- consecutive ranks
    - rank(2000) within group (order by sal) as row_rank		-- Aggregator function
    - dense_rank(2000) within group (order by sal) as row_rank	-- Aggregator function
    - ROW_NUMBER() OVER (ORDER BY val DESC) AS val_row_number
    - PERCENT_RANK() OVER (ORDER BY val) AS val_percent_rank
    - NTILE(3) OVER (ORDER BY val) AS val_ntile
    - LAG(sal, 1, 0) OVER (ORDER BY sal) AS sal_prev
    - LEAD(sal, 1, 0) OVER (ORDER BY sal) AS sal_next,
	- WHERE  rownum <= 5
```

**2. Decode**

```sql
	- DECODE(supplier_id,
					10000, 'IBM',
                    10001, 'Microsoft',
                    10002, 'Hewlett Packard',
                    'Gateway') result
	- DECODE((date1 - date2) - ABS(date1 - date2), 0, date1, date2) - date1 is greater
```

**3. Case**

```sql
	- CASE
		WHEN t.status in ('cancelled_by_driver','cancelled_by_client')
			THEN 1
			ELSE 0
	  END
	- CASE category_id
    	WHEN 1 THEN ROUND(list_price * 0.05,2) 	-- CPU
    	WHEN 2 THEN ROUND(List_price * 0.1,2)  	-- Video Card
    	ELSE ROUND(list_price * 0.08,2) 		-- other categories
  	  END discount
```

**4. String / Date / Number**

```sql
	- ROUND(number, decimal_places) and ROUND(date [, format])
		- SELECT ROUND(123.456) FROM dual;		-- 123
		- SELECT ROUND(123.456, 2) FROM dual;		-- 123.46
		- SELECT ROUND(12345.67, -2) FROM dual;		-- 12300
		- SELECT ROUND(2.5) FROM dual;			-- Result: 3
		- SELECT ROUND(DATE '2024-02-20', 'MONTH') FROM dual;  -- Result: 01-MAR-2024 (20th is past the 15th midpoint)
		- SELECT ROUND(TIMESTAMP '2024-02-05 14:30:00') FROM dual; 	-- Result: 05-FEB-2024 (rounds up after noon)
	- trunc() -- (no rounding)
		- SELECT TRUNC(123.789, 2) FROM dual; 	-- Result: 123.78
		- SELECT TRUNC(DATE '2024-02-20', 'MONTH') FROM dual;	-- Result: 01-FEB-2024
	- trim() LTRIM() RTRIM()
		- SELECT TRIM('  Hello World  ') FROM DUAL;
		- SELECT TRIM(LEADING '0' FROM '00012345') FROM DUAL;
		- SELECT TRIM(TRAILING 'x' FROM 'Testxx') FROM DUAL;
		- SELECT TRIM(BOTH 'a' FROM 'abracadabra') FROM DUAL;
		- SELECT TRIM('a' FROM 'abracadabra') FROM DUAL;
		- SELECT LTRIM('  hello  ') FROM dual;
		- SELECT LTRIM('xyxyhello', 'xy') FROM dual;
		- SELECT RTRIM('  hello  ') FROM dual;
		- SELECT RTRIM('helloxyxy', 'xy') FROM dual;
	- to_number()
		- select to_number(trim(to_char(avg(c3.amount),'999D99'))) from dual
	- to_char() - '999D99', 'yyyy-mm-dd'
		- select to_char(visit_date,'yyyy-mm-dd') visit_date from dual
	- to_date()
	- substr()
		- SUBSTR('This is a test', 6, 2)
		- SUBSTR('TechOnTheNet', -5, 3)
		- SUBSTR('TechOnTheNet', 3)
		- SUBSTR('TechOnTheNet', -3)
	- TRANSLATE and REPLACE
		- select replace(translate(name,'AEIOUeiou','aaaaaaaaa'),a,'')
	- instr()
		- INSTR( 'String', 'is', 1, 2 ) second_occurrence
		- INSTR( 'String', 'is', -1, 1 ) last_occurrence
		- INSTR( string, substring [, start_position [, th_appearance ] ] )
	- lpad()
		- LPAD(amount, 12, '*'), RPAD(amount, 12, '*')
	- LEAST() / GREATEST() -- across columns (not rows); ignores NULLs if any arg is NULL
		- LEAST(10, 20, 5)				-- 5
		- GREATEST(10, 20, 5)				-- 20
		- LEAST(salary, bonus, commission)		-- smallest of the three columns for each row
		- GREATEST(start_date, end_date)		-- later of two dates
		-- vs MIN()/MAX(): those aggregate across rows; LEAST/GREATEST compare across columns within a row
	- POWER(base, exponent) -- base^exponent
		- SELECT POWER(2, 10)  FROM dual;		-- 1024    (2¹⁰)
		- SELECT POWER(3, 3)   FROM dual;		-- 27      (3³)
		- SELECT POWER(9, 0.5) FROM dual;		-- 3       (9^0.5 = √9)
	- SQRT(n) -- √n, equivalent to POWER(n, 0.5)
		- SELECT SQRT(25)  FROM dual;			-- 5       (√25)
		- SELECT SQRT(2)   FROM dual;			-- 1.414...  (√2)
		- SELECT SQRT(144) FROM dual;			-- 12      (√144)
	- ABS(n) -- |n|, absolute value
		- SELECT ABS(-42) FROM dual;			-- 42
		- SELECT ABS(salary - bonus) FROM dual;		-- distance between two values
	- MOD(dividend, divisor) -- remainder (dividend mod divisor)
		- SELECT MOD(10, 3) FROM dual;			-- 1       (10 mod 3)
		- SELECT MOD(15, 5) FROM dual;			-- 0       (exact multiple)
		-- useful: even/odd check → MOD(n, 2) = 0
	- CEIL(n) / FLOOR(n) -- ⌈n⌉ ceiling, ⌊n⌋ floor
		- SELECT CEIL(4.1)   FROM dual;			-- 5       (⌈4.1⌉)
		- SELECT CEIL(-4.1)  FROM dual;			-- -4      (⌈-4.1⌉)
		- SELECT FLOOR(4.9)  FROM dual;			-- 4       (⌊4.9⌋)
		- SELECT FLOOR(-4.9) FROM dual;			-- -5      (⌊-4.9⌋)
	- EXP(n) -- eⁿ (Euler's number raised to the power n)
		- SELECT EXP(1) FROM dual;			-- 2.718...  (e¹)
		- SELECT EXP(2) FROM dual;			-- 7.389...  (e²)
	- LN(n) / LOG(base, n) -- natural log ln(n), logarithm log_base(n)
		- SELECT LN(EXP(1))   FROM dual;		-- 1       (ln(e) = 1)
		- SELECT LN(100)      FROM dual;		-- 4.605...
		- SELECT LOG(10, 100) FROM dual;		-- 2       (log₁₀(100) = 2)
		- SELECT LOG(2, 1024) FROM dual;		-- 10      (log₂(1024) = 10)
		-- identity: LOG(b, n) = LN(n) / LN(b)
```

**5. Null Handling**

```sql
	- COALESCE(a, b, c)              -- first non-null; all args must be same type
	- NVL(expr, replacement)         -- Oracle only; allows mixed types
	- NVL2(expr, if_not_null, if_null)
	- NULLIF(expr1, expr2)           -- returns NULL if equal, else expr1
	- NULLs never match in JOINs     -- use NVL/COALESCE on join key to match NULLs
	- NOT IN (subquery) is unsafe    -- if subquery returns NULL, NOT IN returns no rows; use NOT EXISTS
	- COUNT(*) vs COUNT(col)         -- COUNT(col) skips NULLs; COUNT(*) does not
	- AVG(col) skips NULLs           -- use AVG(NVL(col, 0)) to treat NULL as zero
```

**6. Recursive CTE**

```sql
1.	WITH number_sequence (n) AS (
   		SELECT 1 FROM dual
    	UNION ALL
    	SELECT n + 1
    	FROM number_sequence
    	WHERE n < 10
	)

2.	WITH employee_hierarchy (employee_id, employee_name, manager_id, level_num, path) AS (
    -- Anchor: Start with CEO (no manager)
    SELECT
        employee_id,
        employee_name,
        manager_id,
        1 as level_num,
        employee_name as path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: Find employees of current level
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        eh.level_num + 1,
        eh.path || ' > ' || e.employee_name
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
	)

3.	WITH fibonacci (n, fib_curr, fib_next) AS (
    -- Anchor: F(0)=0, F(1)=1
    SELECT
        1 as n,
        0 as fib_curr,
        1 as fib_next
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
	-- Call
	SELECT
		n,
		fib_curr as fibonacci_number
	FROM fibonacci;
```

**7. Misc**

```sql
	- select rownum id from all_objects where rownum <=20
	- Row limiting
		- WHERE rownum <= 5
		- FETCH FIRST 5 ROWS ONLY;
		- OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;	-- Skip first 10, then fetch next 5 (pagination)
		- FETCH FIRST 10 PERCENT ROWS ONLY;		-- Top 10% by row count
		- FETCH FIRST 5 ROWS WITH TIES;			-- Include ties at boundary (may return >5 rows)
```

**8. Query Tuning**

```sql
	Execution Plan
	- Row Estimates
	- I/O reads
	- Access Methods
	- Step Duration
	Explain Plan
	- DBMS_XPlan
```

**9. Stored Procedure**

```sql
	DECLARE
	BEGIN
		EXCEPTION
	END;
	/

	-- Variable				: 	variable_name [CONSTANT] datatype [NOT NULL] [:= | DEFAULT initial_value]
	-- Constant and Literal	:	constant_name CONSTANT datatype := VALUE;

	IF condition1
	THEN
		//Block of statements1
	ELSIF condition2
		//Block of statements2
	ELSE
		//Block of statements3
	END IF;

	CASE [expression]
		WHEN condition1 THEN Block of statements1
		WHEN condition2 THEN Block of statements2
		...
		WHEN conditionn THEN Block of statementsn
		ELSE Block of statements
	END CASE;

	WHILE condition
	LOOP
	//block of statements;
	END LOOP;

	FOR loop_counter IN [REVERSE] start_value .. end_value
	LOOP
	//block of statements.
	END LOOP;

	continue and EXIT

	<< label >>

	GOTO label_name;
	//Other statements
	<<label_name>>
	Statement;

	-- Stored Procedure
	CREATE [OR REPLACE] PROCEDURE proc_name [list of parameters]
	IS | AS
	//Declaration block
	BEGIN
	//Execution block
	EXCEPTION
	//Exception block
	END;

	EXEC procedure_name();
	or
	BEGIN
	procedure_name;
	END;
	/

	CREATE [OR REPLACE] FUNCTION function_name [parameters]
	RETURN return_datatype;
	IS|AS
		//Declaration block
	BEGIN
		//Execution_block
		Return return_variable;
	EXCEPTION
		//Exception block
		Return return_variable;
	END;
	/
```

**10. Aggregation — LISTAGG / ROLLUP / CUBE / Percentile**

```sql
	- LISTAGG(col, ', ') WITHIN GROUP (ORDER BY col)              -- string agg
	- LISTAGG(DISTINCT col, ', ') WITHIN GROUP (ORDER BY col)     -- Oracle 19c+
	- GROUP BY ROLLUP (region, product)   -- (region,product), (region), ()
	- GROUP BY CUBE (region, product)     -- all 4 combos including () and (product)
	- GROUP BY GROUPING SETS ((region,product),(region),())
	- GROUPING(col) = 1                   -- identifies subtotal NULLs vs real NULLs
	- PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary)         -- median (interpolated)
	- PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY salary)         -- median (actual row value)
```

**11. MERGE (Upsert)**

```sql
	MERGE INTO target t
	USING source s ON (t.id = s.id)
	WHEN MATCHED THEN
	    UPDATE SET t.col = s.col
	    DELETE WHERE s.active = 'N'       -- Oracle extension: delete inactive matched rows
	WHEN NOT MATCHED THEN
	    INSERT (id, col) VALUES (s.id, s.col);
```

**12. CONNECT BY (Oracle hierarchy)**

```sql
	SELECT LPAD(' ', (LEVEL-1)*2, ' ') || name AS chart,
	       LEVEL,
	       SYS_CONNECT_BY_PATH(name, ' > ') AS path,
	       CONNECT_BY_ISLEAF AS is_leaf
	FROM employees
	START WITH manager_id IS NULL          -- anchor (root)
	CONNECT BY PRIOR employee_id = manager_id
	ORDER SIBLINGS BY name;               -- sorts within each level without breaking hierarchy
```

---

# 1. Window Functions (Analytical Functions)

Window functions perform calculations across a set of rows related to the current row without collapsing the result set like GROUP BY. **Reference:** [Oracle Analytical Functions](https://oracle-base.com/articles/misc/analytic-functions)

**Basic syntax:**

```sql
function_name([arguments]) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
    [frame_clause]
)
```

## 1.1 Aggregate Window Functions (AVG, RANGE vs ROWS)

```sql
-- Simple partition average
SELECT employee_id, name, department, salary,
    AVG(salary) OVER (PARTITION BY department) AS avg_dept_salary
FROM employees;

-- Running average (cumulative)
SELECT employee_id, name, salary,
    AVG(salary) OVER (PARTITION BY department ORDER BY salary) AS avg_salary_sofar
FROM employees;

-- RANGE: groups by value (default behavior)
SELECT employee_id, salary,
    AVG(salary) OVER (
        PARTITION BY department ORDER BY salary
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS range_avg
FROM employees;

-- ROWS: processes row by row
SELECT employee_id, salary,
    AVG(salary) OVER (
        PARTITION BY department ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS rows_avg
FROM employees;
```

**💡 Tip:** **RANGE** treats rows with the same ORDER BY value as a single group; **ROWS** processes each row individually. If multiple rows have salary = 50000, RANGE includes all of them, ROWS processes one at a time.

## 1.2 FIRST_VALUE and LAST_VALUE

```sql
-- First value (ignore nulls)
SELECT department, employee_id, salary,
    FIRST_VALUE(salary IGNORE NULLS) OVER (
        PARTITION BY department ORDER BY salary ASC NULLS LAST
    ) AS lowest_dept_salary
FROM employees;

-- Previous and next row values
SELECT employee_id, salary,
    FIRST_VALUE(salary) OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_salary,
    LAST_VALUE(salary)  OVER (ORDER BY salary ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS next_salary
FROM employees;
```

**💡 Tip:** Always specify a frame clause with LAST_VALUE, otherwise it defaults to `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, which won't give you the expected last value.

## 1.3 Ranking Functions (RANK, DENSE_RANK, ROW_NUMBER)

```sql
SELECT employee_id, department, salary,
    RANK()       OVER (PARTITION BY department ORDER BY salary DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_consecutive,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS unique_row_number
FROM employees;

-- Aggregate ranking: find rank of a specific value within the dataset
SELECT RANK(2000)       WITHIN GROUP (ORDER BY salary) AS salary_rank,
       DENSE_RANK(2000) WITHIN GROUP (ORDER BY salary) AS salary_dense_rank
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

**💡 Tip:** **RANK()** leaves gaps after ties (1, 1, 3, 4); **DENSE_RANK()** has no gaps (1, 1, 2, 3); **ROW_NUMBER()** is always unique (1, 2, 3, 4).

## 1.4 Distribution Functions (PERCENT_RANK, NTILE)

```sql
SELECT employee_id, salary,
    PERCENT_RANK() OVER (ORDER BY salary) AS percentile,       -- 0 to 1
    NTILE(4)  OVER (ORDER BY salary) AS salary_quartile,       -- 4 equal buckets
    NTILE(10) OVER (ORDER BY salary) AS salary_decile
FROM employees;
```

**💡 Tip:** `PERCENT_RANK()` returns 0 for the first row and 1 for the last row. `NTILE(N)` divides results into N roughly equal groups — useful for quartile/decile analysis.

## 1.5 LAG and LEAD Functions

```sql
SELECT order_date, revenue,
    LAG(revenue)  OVER (ORDER BY order_date) AS prev_day_revenue,
    LEAD(revenue) OVER (ORDER BY order_date) AS next_day_revenue,
    LAG(revenue, 1, 0) OVER (ORDER BY order_date) AS prev_revenue_with_default,  -- default for NULLs
    revenue - LAG(revenue) OVER (ORDER BY order_date) AS daily_change,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY order_date)) * 100.0 /
          LAG(revenue) OVER (ORDER BY order_date), 2) AS pct_change
FROM daily_sales
ORDER BY order_date;

-- Common question: year-over-year growth
SELECT year, revenue,
    LAG(revenue) OVER (ORDER BY year) AS prev_year_revenue,
    revenue - LAG(revenue) OVER (ORDER BY year) AS yoy_growth,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY year)) * 100.0 /
          NULLIF(LAG(revenue) OVER (ORDER BY year), 0), 2) AS yoy_growth_pct
FROM annual_revenue
ORDER BY year;
```

## 1.6 ROWNUM (Oracle-specific)

```sql
-- Get top 5 rows (subquery required — see Tip)
SELECT *
FROM (SELECT employee_id, salary FROM employees ORDER BY salary DESC)
WHERE ROWNUM <= 5;

-- Modern alternative (SQL Standard)
SELECT employee_id, salary FROM employees ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
-- or
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY; 	-- Skip first 10, then fetch next 5 (pagination)
-- or
FETCH FIRST 10 PERCENT ROWS ONLY;	-- Top 10% by row count
-- or
FETCH FIRST 5 ROWS WITH TIES;		-- Include ties at the boundary (returns 5 OR MORE rows if there's a tie at row 5)
```

**💡 Tip:** ROWNUM is assigned before ORDER BY, so always use a subquery when combining them.

---

# 2. String, Date, and Number Functions

## 2.1 ROUND and TRUNC

```sql
-- ROUND numbers
SELECT ROUND(123.456)     FROM dual;   -- 123
SELECT ROUND(123.456, 2)  FROM dual;   -- 123.46
SELECT ROUND(12345.67, -2) FROM dual;  -- 12300
SELECT ROUND(2.5) FROM dual;           -- 3   (banker's rounding to even)
SELECT ROUND(3.5) FROM dual;           -- 4

-- ROUND dates (midpoint logic: Month=15th, Day=noon, Year=June 30th)
SELECT ROUND(DATE '2024-02-20', 'MONTH') FROM dual;        -- 01-MAR-2024 (past 15th midpoint)
SELECT ROUND(DATE '2024-02-10', 'MONTH') FROM dual;        -- 01-FEB-2024 (before 15th midpoint)
SELECT ROUND(TIMESTAMP '2024-02-05 14:30:00') FROM dual;   -- 06-FEB-2024 (rounds up after noon)
SELECT ROUND(DATE '2024-08-15', 'YEAR') FROM dual;         -- 01-JAN-2025

-- TRUNC (no rounding)
SELECT TRUNC(123.789, 2)  FROM dual;   -- 123.78
SELECT TRUNC(123.789)     FROM dual;   -- 123
SELECT TRUNC(12345.67, -2) FROM dual;  -- 12300
SELECT TRUNC(DATE '2024-02-20', 'MONTH') FROM dual;        -- 01-FEB-2024 (first day of month)
SELECT TRUNC(SYSDATE, 'YEAR') FROM dual;                   -- 01-JAN-2024 (first day of year)
SELECT TRUNC(TIMESTAMP '2024-02-05 14:30:00') FROM dual;   -- 05-FEB-2024 00:00:00 (midnight)
```

**💡 Common use case** — date ranges for reports:

```sql
SELECT * FROM transactions
WHERE transaction_date >= TRUNC(SYSDATE, 'MONTH')
  AND transaction_date <  TRUNC(ADD_MONTHS(SYSDATE, 1), 'MONTH');
```

## 2.2 TRIM, LTRIM, RTRIM

```sql
SELECT TRIM('  Hello World  ') FROM dual;             -- 'Hello World'
SELECT TRIM(LEADING '0' FROM '00012345') FROM dual;   -- '12345'
SELECT TRIM(TRAILING 'x' FROM 'Testxx') FROM dual;    -- 'Test'
SELECT TRIM(BOTH 'a' FROM 'abracadabra') FROM dual;   -- 'bracadabr'
SELECT TRIM('a' FROM 'abracadabra') FROM dual;        -- 'bracadabr' (default is BOTH)
SELECT LTRIM('  hello  ') FROM dual;                  -- 'hello  '
SELECT LTRIM('xyxyhello', 'xy') FROM dual;            -- 'hello'
SELECT RTRIM('  hello  ') FROM dual;                  -- '  hello'
SELECT RTRIM('helloxyxy', 'xy') FROM dual;            -- 'hello'
```

**💡 Tip:** Use TRIM to clean dirty data before joins or comparisons.

## 2.3 Type Conversion (TO_NUMBER, TO_CHAR, TO_DATE)

```sql
-- TO_NUMBER
SELECT TO_NUMBER('12345') FROM dual;                      -- 12345
SELECT TO_NUMBER('$1,234.56', '$999,999.99') FROM dual;   -- 1234.56
SELECT TO_NUMBER(TRIM(TO_CHAR(AVG(amount), '999D99'))) FROM transactions;

-- TO_CHAR (numbers)
SELECT TO_CHAR(1234.56, '999D99') FROM dual;     -- '1234.56'
SELECT TO_CHAR(1234.56, '$9,999.99') FROM dual;  -- '$1,234.56'
SELECT TO_CHAR(0.85, '0.99') FROM dual;          -- '0.85'

-- TO_CHAR (dates)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM dual;            -- '2024-02-15'
SELECT TO_CHAR(SYSDATE, 'Day, Month DD, YYYY') FROM dual;   -- 'Thursday, February 15, 2024'

-- TO_DATE (always specify format mask to avoid ambiguity/locale issues)
SELECT TO_DATE('2024-02-15', 'YYYY-MM-DD') FROM dual;
SELECT TO_DATE('15/02/2024', 'DD/MM/YYYY') FROM dual;
SELECT TO_DATE('Feb 15, 2024', 'Mon DD, YYYY') FROM dual;
```

**Common Format Masks:**

```
Numbers:  9 digit (suppress leading zeros) | 0 digit (show leading zeros) | $ dollar | , comma | . decimal
Dates:    YYYY year | MM month | DD day | HH24 24-hour | MI minutes | SS seconds | Day full day name | Month full month name
```

## 2.4 SUBSTR and INSTR

```sql
-- SUBSTR(string, start_position, length)
SELECT SUBSTR('This is a test', 6, 2) FROM dual;   -- 'is'
SELECT SUBSTR('TechOnTheNet', -5, 3) FROM dual;    -- 'heN'  (negative = from end)
SELECT SUBSTR('TechOnTheNet', 3) FROM dual;        -- 'chOnTheNet'
SELECT SUBSTR('TechOnTheNet', -3) FROM dual;       -- 'Net'  (last 3 chars)

-- INSTR(string, substring [, start_position [, occurrence]])
SELECT INSTR('String', 'is') FROM dual;            -- 4
SELECT INSTR('String', 'is', 1, 2) FROM dual;      -- 0  (2nd occurrence not found)
SELECT INSTR('Mississippi', 'is', -1, 1) FROM dual;-- 5  (search from end)

-- Common: extract domain from email
SELECT email, SUBSTR(email, INSTR(email, '@') + 1) AS domain FROM users;

-- Common: check if substring exists
SELECT email FROM users WHERE INSTR(LOWER(email), '@company.com') > 0;
```

## 2.5 TRANSLATE and REPLACE

```sql
-- REPLACE: substitutes an entire substring (case-sensitive)
SELECT REPLACE('Hello World', 'World', 'SQL') FROM dual;   -- 'Hello SQL'
SELECT REPLACE('Hello World', ' ', '') FROM dual;          -- 'HelloWorld'
SELECT REPLACE('HELLO WORLD', 'hello', 'hi') FROM dual;    -- 'HELLO WORLD' (no change)

-- TRANSLATE: character-by-character mapping
SELECT TRANSLATE('Hello World', 'eo', 'aa') FROM dual;     -- 'Halla Warld'

-- Remove vowels (translate to 'a' then strip 'a')
SELECT REPLACE(TRANSLATE('Hello World', 'AEIOUaeiou', 'aaaaaaaaaa'), 'a', '') FROM dual;  -- 'Hll Wrld'
```

**💡 Tip:** REPLACE substitutes an entire substring; TRANSLATE does character-by-character mapping.

## 2.6 LPAD and RPAD

```sql
-- LPAD/RPAD(string, length, pad_string)
SELECT LPAD('123', 6, '0') FROM dual;     -- '000123'
SELECT RPAD('Test', 10, '*') FROM dual;   -- 'Test******'

-- Format account numbers / report columns
SELECT account_id, LPAD(account_id, 10, '0') AS formatted_account FROM accounts;
SELECT RPAD(department, 20, ' ') AS dept, LPAD(TO_CHAR(budget), 12, ' ') AS budget FROM departments;

-- Visual indicators
SELECT product_name, rating, RPAD('*', rating, '*') AS star_rating FROM products;
```

---

# 3. Conditional Logic

## 3.1 DECODE (Oracle-specific)

```sql
-- DECODE(expression, search1, result1, search2, result2, ..., default)
SELECT supplier_id,
    DECODE(supplier_id,
        10000, 'IBM',
        10001, 'Microsoft',
        10002, 'Hewlett Packard',
        'Gateway') AS supplier_name      -- default value
FROM suppliers;

-- Find greater date (clever trick)
SELECT DECODE((date1 - date2) - ABS(date1 - date2), 0, date1, date2) AS greater_date
FROM table_name;

-- Conditional aggregation
SELECT department,
    SUM(DECODE(status, 'ACTIVE', 1, 0))   AS active_count,
    SUM(DECODE(status, 'INACTIVE', 1, 0)) AS inactive_count
FROM employees
GROUP BY department;
```

**💡 Tip:** DECODE is Oracle-specific. Use CASE for standard SQL.

## 3.2 CASE Expressions

```sql
-- Simple CASE (equality check only)
SELECT product_id, category_id, list_price,
    CASE category_id
        WHEN 1 THEN ROUND(list_price * 0.05, 2)  -- CPU: 5%
        WHEN 2 THEN ROUND(list_price * 0.10, 2)  -- Video Card: 10%
        ELSE ROUND(list_price * 0.08, 2)         -- Others: 8%
    END AS discount
FROM products;

-- Searched CASE (any boolean expression)
SELECT trip_id, status,
    CASE
        WHEN status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1
        WHEN status = 'completed' THEN 0
        ELSE NULL
    END AS is_cancelled
FROM trips;

-- Banding
SELECT employee_id, salary,
    CASE
        WHEN salary >= 100000 THEN 'Executive'
        WHEN salary >= 70000  THEN 'Senior'
        WHEN salary >= 50000  THEN 'Mid-level'
        WHEN salary >= 30000  THEN 'Junior'
        ELSE 'Entry-level'
    END AS salary_band
FROM employees;
```

**💡 Conditional aggregation** (pivot-like, with and without GROUP BY):

```sql
SELECT department, COUNT(*) AS total_employees,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN hire_date >= DATE '2023-01-01' THEN 1 ELSE 0 END) AS recent_hires
FROM employees
GROUP BY department;

SELECT COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) AS completed_revenue,
    SUM(CASE WHEN status = 'pending'   THEN amount ELSE 0 END) AS pending_revenue,
    AVG(CASE WHEN status = 'completed' THEN amount END)        AS avg_completed_amount
FROM orders;
```

---

# 4. NULL Handling

## 4.1 COALESCE, NVL, NVL2

```sql
-- COALESCE (SQL standard): first non-null; all args must be compatible types
SELECT employee_id,
    COALESCE(phone_mobile, phone_home, phone_work, 'No phone') AS contact_number
FROM employees;
SELECT COALESCE(NULL, NULL, 123, 456) FROM dual;   -- 123

-- NVL (Oracle): NVL(expression, replacement) — allows implicit conversion
SELECT employee_id, NVL(commission, 0) AS commission FROM employees;
SELECT NVL(NULL, 'default') FROM dual;

-- NVL2(expression, value_if_not_null, value_if_null)
SELECT employee_id, NVL2(commission, 'Has Commission', 'No Commission') AS commission_status
FROM employees;
```

**💡 Tip:** COALESCE is SQL standard and more flexible (multiple args), but all arguments must have compatible datatypes.

## 4.2 NULLs in JOINs and NULLIF

```sql
-- NULLs don't match in joins — substitute a sentinel
SELECT a.id, a.value, b.value
FROM table_a a
LEFT JOIN table_b b ON NVL(a.category, 'UNKNOWN') = NVL(b.category, 'UNKNOWN');
-- (COALESCE works identically here)

-- NULLIF(expr1, expr2): returns NULL if expr1 = expr2, else expr1
SELECT total_sales / NULLIF(total_orders, 0) AS avg_order_value FROM sales_summary;  -- avoid div/0
SELECT employee_id, NULLIF(status, 'UNKNOWN') AS status FROM employees;              -- value → NULL
```

---

# 5. Recursive CTEs

## 5.1 Basic Structure

```sql
WITH cte_name (columns) AS (
    -- Anchor member (non-recursive part)
    SELECT ... FROM base_table WHERE initial_condition

    UNION ALL

    -- Recursive member
    SELECT ... FROM base_table
    INNER JOIN cte_name ON join_condition
    WHERE termination_condition
)
SELECT * FROM cte_name;
```

**💡 Tip:** Always include a termination condition to prevent infinite recursion.

## 5.2 Number Sequence and Date Series

```sql
-- Numbers 1 to 10
WITH number_sequence (n) AS (
    SELECT 1 FROM dual
    UNION ALL
    SELECT n + 1 FROM number_sequence WHERE n < 10
)
SELECT n FROM number_sequence;

-- All dates in a month
WITH date_series AS (
    SELECT DATE '2024-02-01' AS dt FROM dual
    UNION ALL
    SELECT dt + 1 FROM date_series WHERE dt < DATE '2024-02-29'
)
SELECT dt FROM date_series;
```

## 5.3 Organizational Hierarchy

```sql
WITH employee_hierarchy (employee_id, employee_name, manager_id, level_num, path) AS (
    -- Anchor: CEO (no manager)
    SELECT employee_id, employee_name, manager_id, 1 AS level_num, employee_name AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: direct reports
    SELECT e.employee_id, e.employee_name, e.manager_id,
           eh.level_num + 1, eh.path || ' > ' || e.employee_name
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT LPAD(' ', (level_num - 1) * 2, ' ') || employee_name AS org_chart, level_num, path
FROM employee_hierarchy
ORDER BY path;
```

## 5.4 Fibonacci Sequence

```sql
WITH fibonacci (n, fib_curr, fib_next) AS (
    SELECT 1 AS n, 0 AS fib_curr, 1 AS fib_next FROM dual     -- Anchor: F(0)=0, F(1)=1
    UNION ALL
    SELECT n + 1, fib_next, fib_curr + fib_next               -- Recursive: F(n)=F(n-1)+F(n-2)
    FROM fibonacci WHERE n < 10
)
SELECT n, fib_curr AS fibonacci_number FROM fibonacci;
-- Result: 0,1,1,2,3,5,8,13,21,34
```

## 5.5 Graph Traversal (friends of friends)

```sql
WITH connections (user_id, friend_id, degree, path) AS (
    -- Anchor: direct friends (degree 1)
    SELECT user_id, friend_id, 1 AS degree,
           CAST(user_id || '->' || friend_id AS VARCHAR2(1000)) AS path
    FROM friendships
    WHERE user_id = 123

    UNION ALL

    -- Recursive: friends of friends
    SELECT c.user_id, f.friend_id, c.degree + 1, c.path || '->' || f.friend_id
    FROM connections c
    INNER JOIN friendships f ON c.friend_id = f.user_id
    WHERE c.degree < 3                          -- limit to 3 degrees
      AND INSTR(c.path, f.friend_id) = 0        -- avoid cycles
)
SELECT DISTINCT friend_id, MIN(degree) AS closest_degree
FROM connections
GROUP BY friend_id
ORDER BY closest_degree, friend_id;
```

---

# 6. Query Optimization & Performance

## 6.1 Execution Plan Analysis

**Key metrics to examine:**

- **Row estimates vs actual** — large discrepancy indicates stale statistics or poor cardinality estimation
- **I/O reads** — physical (disk, slow) vs logical (memory, fast); goal is to minimize physical reads
- **Access methods** — Full Table Scan (entire table) | Index Range Scan (efficient) | Index Full Scan (entire index) | Index Unique Scan (single row)
- **Step duration** — identify the longest step and focus there

```sql
-- Generate and view a plan
EXPLAIN PLAN FOR
SELECT e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 50000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, NULL, 'ALL'));   -- more detail
```

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

**💡 Tips:** Read from bottom to top and inside out. Look for expensive (high-cost) operations, full table scans on large tables, and verify indexes are being used.

## 6.2 Common Performance Issues

```sql
-- Issue 1: Missing statistics
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCHEMA_NAME', 'EMPLOYEES');
SELECT table_name, last_analyzed FROM user_tables WHERE table_name = 'EMPLOYEES';

-- Issue 2: Function on indexed column prevents index usage
SELECT * FROM employees WHERE UPPER(last_name) = 'SMITH';      -- bad
CREATE INDEX emp_upper_name_idx ON employees(UPPER(last_name)); -- fix: function-based index

-- Issue 3: Implicit type conversion (employee_id is NUMBER)
SELECT * FROM employees WHERE employee_id = '12345';  -- bad
SELECT * FROM employees WHERE employee_id = 12345;    -- good

-- Issue 4: SELECT * retrieves unnecessary columns — select only what you need
SELECT employee_id, employee_name, salary FROM employees WHERE department_id = 10;
```

## 6.3 Index Usage Tips

- **Use indexes on:** high-cardinality columns (many unique values); columns frequently in WHERE/JOIN/ORDER BY; columns with low update frequency
- **Avoid indexes on:** small tables (< 1000 rows); high-update-frequency columns; low-cardinality columns; queries returning >15-20% of table rows

**💡 Tip:** Too many indexes slow down DML operations (INSERT, UPDATE, DELETE).

---

# 7. Stored Procedures & Functions

## 7.1 Block Structure, Variables, Constants

```sql
DECLARE
    -- variable_name [CONSTANT] datatype [NOT NULL] [:= | DEFAULT initial_value]
    v_employee_name VARCHAR2(100);
    v_salary        NUMBER(10,2);
    v_hire_date     DATE := SYSDATE;
    c_tax_rate      CONSTANT NUMBER := 0.15;
    c_company_name  CONSTANT VARCHAR2(50) := 'ACME Corp';
    v_department_id NUMBER NOT NULL := 10;
BEGIN
    v_employee_name := 'John Doe';
    v_salary := 75000 * (1 - c_tax_rate);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_employee_name);
    DBMS_OUTPUT.PUT_LINE('Net Salary: ' || v_salary);
EXCEPTION
    WHEN exception_name THEN NULL;   -- handle exception
END;
/
```

## 7.2 Control Structures (IF, CASE, Loops, GOTO)

```sql
-- IF-THEN-ELSIF-ELSE
IF v_score >= 90 THEN v_grade := 'A';
ELSIF v_score >= 80 THEN v_grade := 'B';
ELSIF v_score >= 70 THEN v_grade := 'C';
ELSE v_grade := 'F';
END IF;

-- CASE statement
CASE v_department_id
    WHEN 10 THEN v_department_name := 'Sales';
    WHEN 20 THEN v_department_name := 'IT';
    ELSE v_department_name := 'Unknown';
END CASE;

-- WHILE loop
WHILE v_counter <= 10 LOOP
    v_sum := v_sum + v_counter;
    v_counter := v_counter + 1;
END LOOP;

-- FOR loop (forward and REVERSE)
FOR i IN 1..5 LOOP v_factorial := v_factorial * i; END LOOP;
FOR i IN REVERSE 1..5 LOOP DBMS_OUTPUT.PUT_LINE('Countdown: ' || i); END LOOP;

-- Basic LOOP with CONTINUE / EXIT
LOOP
    IF MOD(v_counter, 2) = 0 THEN
        v_counter := v_counter + 1;
        CONTINUE;                  -- skip to next iteration
    END IF;
    DBMS_OUTPUT.PUT_LINE('Odd: ' || v_counter);
    v_counter := v_counter + 1;
    EXIT WHEN v_counter > 10;
END LOOP;

-- Labels and GOTO (avoid — harder to maintain; prefer structured programming)
<<check_number>>
IF v_num < 0 THEN GOTO end_program; END IF;
<<end_program>>
DBMS_OUTPUT.PUT_LINE('Program ended');
```

## 7.3 Stored Procedures (create and call)

```sql
CREATE OR REPLACE PROCEDURE update_employee_salary (
    p_employee_id IN NUMBER,
    p_raise_pct   IN NUMBER,
    p_new_salary  OUT NUMBER
)
IS
    v_current_salary NUMBER;
BEGIN
    SELECT salary INTO v_current_salary FROM employees WHERE employee_id = p_employee_id;
    p_new_salary := v_current_salary * (1 + p_raise_pct / 100);
    UPDATE employees SET salary = p_new_salary WHERE employee_id = p_employee_id;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Employee not found');
    WHEN OTHERS THEN ROLLBACK; DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END update_employee_salary;
/

-- Call: Method 1 (EXEC)
EXEC update_employee_salary(101, 10, :new_salary);

-- Call: Method 2 (anonymous block)
DECLARE v_new_salary NUMBER;
BEGIN
    update_employee_salary(101, 10, v_new_salary);
    DBMS_OUTPUT.PUT_LINE('New salary: ' || v_new_salary);
END;
/
```

## 7.4 Functions (create and use)

```sql
CREATE OR REPLACE FUNCTION calculate_bonus (
    p_employee_id IN NUMBER,
    p_bonus_pct   IN NUMBER DEFAULT 10
)
RETURN NUMBER
IS
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary FROM employees WHERE employee_id = p_employee_id;
    RETURN v_salary * (p_bonus_pct / 100);
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
    WHEN OTHERS THEN RETURN -1;
END calculate_bonus;
/

-- Use in SELECT
SELECT employee_id, employee_name, salary, calculate_bonus(employee_id, 15) AS bonus
FROM employees WHERE department_id = 10;

-- Use in PL/SQL
DECLARE v_bonus NUMBER;
BEGIN
    v_bonus := calculate_bonus(101, 20);
    DBMS_OUTPUT.PUT_LINE('Bonus: $' || v_bonus);
END;
/
```

**💡 Tip:** **Procedures** can have OUT parameters and are used for DML operations. **Functions** must return a value, can be used in SQL statements, and should be deterministic.

---

# 8. Common Interview Questions

## 8.1 Find Duplicates

```sql
-- Find duplicate keys
SELECT email, COUNT(*) AS count FROM customers GROUP BY email HAVING COUNT(*) > 1;

-- Get all duplicate rows with details
SELECT * FROM customers c
WHERE email IN (SELECT email FROM customers GROUP BY email HAVING COUNT(*) > 1)
ORDER BY email;

-- Using window function
SELECT * FROM (
    SELECT c.*, ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn
    FROM customers c
) WHERE rn > 1;
```

## 8.2 Delete Duplicates

```sql
-- Keep first occurrence, delete rest
DELETE FROM customers
WHERE ROWID NOT IN (SELECT MIN(ROWID) FROM customers GROUP BY email);

-- Using window function
DELETE FROM customers
WHERE ROWID IN (
    SELECT rid FROM (
        SELECT ROWID AS rid, ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn
        FROM customers
    ) WHERE rn > 1
);
```

## 8.3 Second Highest Salary

```sql
-- Subquery
SELECT MAX(salary) AS second_highest FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- DENSE_RANK
SELECT salary FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rank FROM employees
) WHERE rank = 2;

-- FETCH FIRST (Oracle 12c+)
SELECT DISTINCT salary FROM employees ORDER BY salary DESC
OFFSET 1 ROW FETCH NEXT 1 ROW ONLY;
```

## 8.4 Running Total and Moving Average

```sql
-- Running total
SELECT order_date, daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM daily_sales ORDER BY order_date;

-- 7-day moving average
SELECT order_date, revenue,
    AVG(revenue) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7day
FROM daily_sales ORDER BY order_date;
```

## 8.5 Month-over-Month Change

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

For each user show current score, previous month's score, change, and a trend label. Only include rows where a previous month exists.

```sql
WITH cte AS (
    SELECT user_id, score_month, credit_score,
        LAG(credit_score, 1) OVER (PARTITION BY user_id ORDER BY score_month) AS prev_score
    FROM credit_score_history
)
SELECT user_id, score_month, credit_score, prev_score,
    (credit_score - prev_score) AS change,
    CASE
        WHEN credit_score > prev_score THEN 'Increased'
        WHEN credit_score < prev_score THEN 'Decreased'
        ELSE 'No Change'
    END AS trend
FROM cte
WHERE prev_score IS NOT NULL;
```

**Key points:** `LAG(credit_score, 1)` fetches the previous row's value within each user's partition; `WHERE prev_score IS NOT NULL` drops the first row per user (no prior month).

## 8.6 Pivot and Unpivot

```sql
-- Native PIVOT (Oracle / SQL Server)
SELECT * FROM (SELECT department, gender FROM employees)
PIVOT (COUNT(*) FOR gender IN ('M' AS male, 'F' AS female));

-- Manual pivot using CASE (works everywhere)
SELECT department,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM employees GROUP BY department;
```

**Pivot with aggregation + total column** — pivot revenue by month, show 0 (not NULL) for missing months, add a total, order by total descending:

| product | Jan | Feb | Mar | total |
| ------- | --- | --- | --- | ----- |
| Apple   | 100 | 150 | 200 | 450   |
| Mango   | 80  | 90  | 110 | 280   |
| Banana  | 0   | 70  | 90  | 160   |

```sql
SELECT product,
    SUM(CASE WHEN month = 'Jan' THEN revenue ELSE 0 END) AS Jan,
    SUM(CASE WHEN month = 'Feb' THEN revenue ELSE 0 END) AS Feb,
    SUM(CASE WHEN month = 'Mar' THEN revenue ELSE 0 END) AS Mar,
    SUM(revenue) AS total
FROM sales
GROUP BY product
ORDER BY total DESC;
```

**Key points:** `CASE WHEN ... ELSE 0` shows 0 instead of NULL for missing months; `SUM(revenue)` for the total needs no CASE; everything is driven by a single `GROUP BY product`.

## 8.7 Gap and Island — Consecutive Date Ranges

```sql
WITH numbered_dates AS (
    SELECT visit_date,
        ROW_NUMBER() OVER (ORDER BY visit_date) AS rn,
        visit_date - ROW_NUMBER() OVER (ORDER BY visit_date) AS grp
    FROM visits
)
SELECT MIN(visit_date) AS start_date, MAX(visit_date) AS end_date, COUNT(*) AS consecutive_days
FROM numbered_dates
GROUP BY grp
ORDER BY start_date;
```

## 8.8 Longest Consecutive Streak of Score Increases

**Same table: credit_score_history.** Find, for each user, the longest streak of consecutive months where their credit score increased.

**The island detection trick — why `rn_all - rn_inc` works:**

```
All rows (rn_all):       1  2  3  4  5  6  7
is_increase:             0  1  1  0  1  1  1
                            ↓  ↓     ↓  ↓  ↓
Filtered rows (rn_inc):    1  2     3  4  5
island_id = rn_all - rn_inc:  =1 =1   =2 =2 =2   ← constant within each streak
```

Both counters advance together during a streak. When a non-increase row is skipped, `rn_inc` falls behind, shifting the island_id to a new value.

```sql
WITH step1 AS (
    SELECT user_id, score_month, credit_score,
        CASE WHEN credit_score > LAG(credit_score) OVER (PARTITION BY user_id ORDER BY score_month)
             THEN 1 ELSE 0 END AS is_increase,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY score_month) AS rn_all
    FROM credit_score_history
),
step2 AS (
    SELECT user_id, score_month, rn_all,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY score_month) AS rn_inc
    FROM step1 WHERE is_increase = 1
),
step3 AS (
    SELECT user_id, (rn_all - rn_inc) AS island_id FROM step2
)
SELECT user_id, MAX(streak_length) AS longest_streak
FROM (
    SELECT user_id, island_id, COUNT(*) AS streak_length
    FROM step3 GROUP BY user_id, island_id
) streaks
GROUP BY user_id;
```

**Key points:** `rn_all` counts all rows per user; `rn_inc` counts only "increased" rows — their difference is the island key. Inner subquery counts rows per `(user_id, island_id)`; outer takes the max. `PARTITION BY user_id` on every window function is required.

## 8.9 Self-Join Pattern

```sql
-- Employees earning more than their manager
SELECT e.employee_name, e.salary AS employee_salary,
       m.employee_name AS manager_name, m.salary AS manager_salary
FROM employees e
INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
```

## 8.10 Recursive CTEs — Number Sequence, Date Series, Hierarchy, Fibonacci, Graph

```sql
-- Number sequence 1..N
WITH number_sequence (n) AS (
    SELECT 1 FROM dual
    UNION ALL
    SELECT n + 1 FROM number_sequence WHERE n < 10
)
SELECT n FROM number_sequence;

-- Date series (every date in Feb 2024)
WITH date_series AS (
    SELECT DATE '2024-02-01' AS dt FROM dual
    UNION ALL
    SELECT dt + 1 FROM date_series WHERE dt < DATE '2024-02-29'
)
SELECT dt FROM date_series;

-- Org hierarchy with level + path
WITH employee_hierarchy (employee_id, employee_name, manager_id, level_num, path) AS (
    SELECT employee_id, employee_name, manager_id, 1 AS level_num, employee_name AS path
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.employee_name, e.manager_id,
           eh.level_num + 1, eh.path || ' > ' || e.employee_name
    FROM employees e INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT LPAD(' ', (level_num - 1) * 2, ' ') || employee_name AS org_chart, level_num, path
FROM employee_hierarchy ORDER BY path;

-- Fibonacci (carry two columns as a sliding window)
WITH fibonacci (n, fib_curr, fib_next) AS (
    SELECT 1 AS n, 0 AS fib_curr, 1 AS fib_next FROM dual
    UNION ALL
    SELECT n + 1, fib_next, fib_curr + fib_next FROM fibonacci WHERE n < 10
)
SELECT n, fib_curr AS fibonacci_number FROM fibonacci;

-- Friends of friends within 3 degrees (path string guards against cycles)
WITH connections (user_id, friend_id, degree, path) AS (
    SELECT user_id, friend_id, 1 AS degree,
           CAST(user_id || '->' || friend_id AS VARCHAR2(1000)) AS path
    FROM friendships WHERE user_id = 123
    UNION ALL
    SELECT c.user_id, f.friend_id, c.degree + 1, c.path || '->' || f.friend_id
    FROM connections c INNER JOIN friendships f ON c.friend_id = f.user_id
    WHERE c.degree < 3 AND INSTR(c.path, f.friend_id) = 0
)
SELECT DISTINCT friend_id, MIN(degree) AS closest_degree
FROM connections GROUP BY friend_id ORDER BY closest_degree, friend_id;
```

**Key points:** The anchor seeds the recursion; the recursive branch's `WHERE` is the termination condition (without it → infinite loop). Oracle does not use the `RECURSIVE` keyword — `WITH` alone is sufficient. Adding an integer to a DATE advances it by that many days. Use a `path` string both to audit the chain and to detect cycles. Use `VARCHAR2`, not `VARCHAR`.

## 8.11 Top N per Group

```sql
SELECT * FROM (
    SELECT employee_id, employee_name, department, salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) WHERE rnk <= 3;
```

**Key points:** `ROW_NUMBER` → exactly N rows even with ties (arbitrary tiebreak); `RANK` → ties all included (can return >N rows); `DENSE_RANK` → rank ≤ N with no gaps. The subquery is required because window functions cannot appear in WHERE.

## 8.12 String Aggregation (LISTAGG)

```sql
SELECT department, LISTAGG(employee_name, ', ') WITHIN GROUP (ORDER BY employee_name) AS employee_list
FROM employees GROUP BY department;

-- Distinct values (Oracle 19c+)
SELECT department, LISTAGG(DISTINCT employee_name, ', ') WITHIN GROUP (ORDER BY employee_name) AS employee_list
FROM employees GROUP BY department;

-- Handle overflow beyond 4000 bytes
SELECT department,
    LISTAGG(employee_name, ', ' ON OVERFLOW TRUNCATE '...' WITH COUNT) WITHIN GROUP (ORDER BY employee_name) AS employee_list
FROM employees GROUP BY department;
```

**Key points:** `WITHIN GROUP (ORDER BY ...)` controls value order. Default result type is `VARCHAR2(4000)` — use `ON OVERFLOW TRUNCATE` or `XMLAGG` for unlimited length. Standard SQL equivalents: `STRING_AGG` (PostgreSQL/SQL Server), `GROUP_CONCAT` (MySQL).

## 8.13 Subtotals with ROLLUP and CUBE

```sql
-- ROLLUP — hierarchical subtotals (region → grand total)
SELECT
    CASE WHEN GROUPING(region)  = 1 THEN 'ALL REGIONS'  ELSE region  END AS region,
    CASE WHEN GROUPING(product) = 1 THEN 'ALL PRODUCTS' ELSE product END AS product,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY ROLLUP (region, product)
ORDER BY region NULLS LAST, product NULLS LAST;

-- CUBE — every combination
SELECT ... FROM sales GROUP BY CUBE (region, product) ...;

-- GROUPING SETS — pick exactly which groupings you need
SELECT region, product, SUM(revenue) AS total_revenue
FROM sales
GROUP BY GROUPING SETS (
    (region, product),   -- detail rows
    (region),            -- region subtotals only
    ()                   -- grand total only
);
```

**Key points:** `ROLLUP(A, B)` → `(A,B)`, `(A)`, `()`. `CUBE(A, B)` → all 4: `(A,B)`, `(A)`, `(B)`, `()`. Subtotal rows have NULL in rolled-up columns — `GROUPING(col) = 1` distinguishes a subtotal NULL from a real data NULL. GROUPING SETS is the most precise.

## 8.14 Records in One Table but Not Another

```sql
-- NOT EXISTS — best Oracle performance; optimizer rewrites as anti-join; handles NULLs correctly
SELECT c.customer_id, c.customer_name FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- MINUS — set difference, removes duplicates; returns only selected columns
SELECT customer_id FROM customers MINUS SELECT customer_id FROM orders;

-- LEFT JOIN with NULL check — can produce duplicate rows; add DISTINCT or use a form above
SELECT c.customer_id, c.customer_name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

**Key point:** `NOT IN` with a subquery is dangerous when the subquery can return NULLs — a single NULL makes the entire `NOT IN` return no rows.

## 8.15 Median and Percentile

```sql
-- Aggregate form
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary,        -- interpolated
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary_disc,   -- actual row value
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY salary) AS p90_salary
FROM employees;

-- Analytic form — median per department alongside each row
SELECT employee_id, department, salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) OVER (PARTITION BY department) AS dept_median_salary
FROM employees;
```

**Key points:** `PERCENTILE_CONT` interpolates (always returns a number even if no row has that value); `PERCENTILE_DISC` returns the first actual value at/above the percentile. Fraction: 0=min, 0.5=median, 1=max. Both work as aggregate (`WITHIN GROUP`) or analytic (`OVER`) functions.

## 8.16 CONNECT BY — Oracle Hierarchical Queries

```sql
-- Full org chart
SELECT
    LPAD(' ', (LEVEL - 1) * 2, ' ') || employee_name AS org_chart,
    LEVEL AS level_num,
    SYS_CONNECT_BY_PATH(employee_name, ' > ') AS path,
    CONNECT_BY_ISLEAF AS is_leaf
FROM employees
START WITH manager_id IS NULL                -- root node(s)
CONNECT BY PRIOR employee_id = manager_id    -- parent → child direction
ORDER SIBLINGS BY employee_name;             -- sort children without breaking hierarchy

-- Start from a specific node (subtree only)
SELECT employee_id, employee_name, LEVEL FROM employees
START WITH employee_id = 101
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY employee_name;
```

**Key points:** `START WITH` = anchor; `CONNECT BY PRIOR parent_col = child_col` (PRIOR = parent row in current path); `LEVEL` pseudo-column (1=root); `SYS_CONNECT_BY_PATH` builds the full path; `CONNECT_BY_ISLEAF = 1` flags leaves. Prefer CONNECT BY for simple navigation, recursive CTEs for complex multi-step logic.

## 8.17 MERGE (Upsert)

```sql
MERGE INTO employees tgt
USING employee_updates src ON (tgt.employee_id = src.employee_id)
WHEN MATCHED THEN
    UPDATE SET tgt.salary = src.salary, tgt.job_title = src.job_title
    DELETE WHERE src.active_flag = 'N'    -- Oracle extension: delete now-inactive matched rows
WHEN NOT MATCHED THEN
    INSERT (employee_id, employee_name, salary, job_title)
    VALUES (src.employee_id, src.employee_name, src.salary, src.job_title);
```

**Key points:** The `ON` clause is the match key (use a stable key, not mutable columns). Both `WHEN MATCHED` and `WHEN NOT MATCHED` are optional (omit either for insert-only / update-only). A single MERGE is far more efficient than separate UPDATE + INSERT — the source is scanned once.

## 8.18 Sessionization — Detect User Sessions

Given `page_events (user_id, event_time)`, group page views into sessions where a new session begins after 30 minutes of inactivity.

```sql
WITH gaps AS (
    SELECT user_id, event_time,
        LAG(event_time) OVER (PARTITION BY user_id ORDER BY event_time) AS prev_time
    FROM page_events
),
session_flags AS (
    SELECT user_id, event_time,
        CASE WHEN prev_time IS NULL OR (event_time - prev_time) * 24 * 60 > 30
             THEN 1 ELSE 0 END AS is_session_start
    FROM gaps
),
session_ids AS (
    SELECT user_id, event_time,
        SUM(is_session_start) OVER (PARTITION BY user_id ORDER BY event_time
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS session_id
    FROM session_flags
)
SELECT user_id, session_id,
    MIN(event_time) AS session_start, MAX(event_time) AS session_end, COUNT(*) AS event_count
FROM session_ids
GROUP BY user_id, session_id
ORDER BY user_id, session_id;
```

**Key points:** `(event_time - prev_time) * 24 * 60` converts Oracle DATE subtraction (fractional days) to minutes. A running `SUM` over the session-start flag produces a monotonically increasing session counter per user. The first event per user always starts a new session. This pattern generalizes to any "group by gap" problem.

---

## Quick Reference Card

```sql
-- Ranking:        ROW_NUMBER(), RANK(), DENSE_RANK()
-- Analytics:      LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()
-- Aggregates:     SUM() OVER, AVG() OVER, COUNT() OVER
-- String:         SUBSTR(), INSTR(), TRIM(), REPLACE(), TRANSLATE()
-- Date:           TRUNC(), ROUND(), TO_DATE(), TO_CHAR()
-- Null Handling:  COALESCE(), NVL(), NULLIF()
-- Conditional:    CASE, DECODE()
```

**Performance Checklist:** statistics up to date? · indexes on join/filter columns? · avoid functions on indexed columns · select only needed columns · check execution plan · appropriate join type · partitioning for large tables

**Common Patterns:** Running totals → `SUM() OVER (ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` · Ranking → `DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)` · Prev/Next row → `LAG()/LEAD()` · Conditional aggregation → `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` · Deduplication → `ROW_NUMBER() OVER (PARTITION BY ...)`

---

# 9. Trick Questions & SQL Gotchas

These are semantics traps that test whether you *understand* SQL, not just write it.

## 9.1 NULL Traps

```sql
-- Trap 1: NULL = NULL is never TRUE (three-valued logic: TRUE/FALSE/UNKNOWN; WHERE treats UNKNOWN as FALSE)
SELECT * FROM employees WHERE manager_id = NULL;       -- WRONG: 0 rows
SELECT * FROM employees WHERE manager_id IS NULL;      -- CORRECT
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- Trap 2: joining on a NULL column silently drops rows
SELECT a.id, b.value FROM table_a a JOIN table_b b ON a.category = b.category;  -- NULL rows excluded
SELECT a.id, b.value FROM table_a a
JOIN table_b b ON NVL(a.category, 'UNKNOWN') = NVL(b.category, 'UNKNOWN');      -- fix: sentinel

-- Trap 3: NOT IN with a subquery containing a NULL returns ZERO rows
-- x NOT IN (1, 2, NULL) → x!=1 AND x!=2 AND x!=NULL → last is UNKNOWN → whole thing UNKNOWN
SELECT customer_id FROM customers WHERE customer_id NOT IN (SELECT customer_id FROM orders);  -- WRONG
SELECT customer_id FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL);      -- fix
SELECT c.customer_id FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);                -- or NOT EXISTS

-- Trap 4: COUNT(column) skips NULLs; COUNT(*) does not. AVG also skips NULLs.
SELECT COUNT(*) FROM employees;              -- 10 (every row)
SELECT COUNT(commission) FROM employees;     -- 7  (ignores NULLs)
SELECT AVG(NVL(commission, 0)) FROM employees;  -- treat NULL as 0

-- Trap 5: NULL in CASE WHEN
SELECT CASE status WHEN NULL THEN 'Missing' ELSE status END FROM orders;     -- WRONG: never matches
SELECT CASE WHEN status IS NULL THEN 'Missing' ELSE status END FROM orders;  -- CORRECT

-- Trap 6: concatenating NULL collapses the whole string (NULL || 'x' = NULL)
SELECT first_name || ' ' || NVL(last_name, '') AS full_name FROM employees;  -- fix
```

## 9.2 JOIN Traps

```sql
-- Trap 7: missing ON clause → CROSS JOIN (100 emp × 10 dept = 1000 rows)
SELECT e.name, d.department_name FROM employees e, departments d;             -- WRONG
SELECT e.name, d.department_name FROM employees e
JOIN departments d ON e.department_id = d.department_id;                      -- CORRECT

-- Trap 8: WHERE on right table turns LEFT JOIN into INNER JOIN
SELECT e.name, d.department_name FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.location = 'New York';            -- WRONG: unmatched left rows (d.* NULL) get filtered out
-- Fix: move the filter into the ON clause
SELECT e.name, d.department_name FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id AND d.location = 'New York';

-- Trap 9: one-to-many JOIN duplicates rows — aggregate/window if you want one row per customer
SELECT c.customer_id, c.name, o.order_date FROM customers c
JOIN (SELECT customer_id, MAX(order_date) AS order_date FROM orders GROUP BY customer_id) o
  ON c.customer_id = o.customer_id;
```

## 9.3 Filtering & Ordering Traps

```sql
-- Trap 10: ROWNUM is assigned BEFORE ORDER BY — sort in a subquery first
SELECT employee_id, salary FROM (SELECT employee_id, salary FROM employees ORDER BY salary DESC)
WHERE ROWNUM <= 5;
SELECT employee_id, salary FROM employees ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY;  -- 12c+

-- Trap 11: aggregates go in HAVING, not WHERE
-- Execution order: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
SELECT department, AVG(salary) FROM employees GROUP BY department HAVING AVG(salary) > 60000;

-- Trap 12: NULL sort position depends on direction (default ASC=NULLS LAST, DESC=NULLS FIRST)
SELECT employee_id, salary FROM employees ORDER BY salary DESC NULLS LAST;  -- force NULLs to bottom

-- Trap 13: BETWEEN is inclusive on both ends; TIMESTAMPs make date BETWEEN risky
SELECT * FROM orders WHERE order_date >= DATE '2024-01-01' AND order_date < DATE '2024-02-01';  -- safe
```

## 9.4 Aggregation Traps

```sql
-- Trap 14: non-aggregated column not in GROUP BY → ORA-00979
SELECT department, employee_name, AVG(salary) FROM employees GROUP BY department, employee_name;  -- add to GROUP BY
SELECT department, employee_name, salary,
       AVG(salary) OVER (PARTITION BY department) AS dept_avg FROM employees;                     -- or window fn

-- Trap 15: DISTINCT can't mix with aggregates; GROUP BY can
SELECT department, COUNT(*) FROM employees GROUP BY department;

-- Trap 16: SUM/AVG ignore NULLs but include zeros — a 0 lowers the average, a NULL does not
SELECT COUNT(*), COUNT(score), SUM(score), AVG(score), AVG(NVL(score,0)) FROM scores;
```

## 9.5 Set Operation Traps

```sql
-- Trap 17: UNION removes duplicates (implicit DISTINCT + sort, slower); UNION ALL keeps everything
SELECT customer_id FROM table_a UNION ALL SELECT customer_id FROM table_b;

-- Trap 18: column count AND datatypes must match — align with NULL placeholders
SELECT customer_id, name, NULL AS order_date FROM customers
UNION ALL
SELECT NULL, NULL, order_date FROM orders;

-- Trap 19: ORDER BY allowed only once, at the very end of set operations
SELECT salary FROM employees UNION ALL SELECT salary FROM contractors ORDER BY salary;
```

## 9.6 Type & Conversion Traps

```sql
-- Trap 20: implicit type conversion disables the index (employee_id is NUMBER)
SELECT * FROM employees WHERE employee_id = '12345';  -- WRONG: full table scan
SELECT * FROM employees WHERE employee_id = 12345;    -- CORRECT: index used

-- Trap 21: CHAR pads with spaces; VARCHAR2 does not. Trimming a CHAR column disables the index.
SELECT * FROM orders WHERE status = 'ACTIVE';         -- works (Oracle pads the literal)
-- Prefer VARCHAR2 unless you need fixed-width storage

-- Trap 22: DATE subtraction returns fractional DAYS, not minutes/seconds
SELECT * FROM orders WHERE (ship_date - order_date) * 24 * 60 > 60;  -- > 60 minutes
SELECT EXTRACT(DAY FROM (ship_ts - order_ts))    AS days,
       EXTRACT(HOUR FROM (ship_ts - order_ts))   AS hours,
       EXTRACT(MINUTE FROM (ship_ts - order_ts)) AS minutes
FROM orders;                                          -- TIMESTAMP: use EXTRACT

-- Trap 23: string comparison is case-sensitive by default
SELECT * FROM employees WHERE LOWER(last_name) = 'smith';
CREATE INDEX emp_lower_name_idx ON employees(LOWER(last_name));  -- function-based index restores index use
```

---

**Good luck with your SQL interview! 🚀**