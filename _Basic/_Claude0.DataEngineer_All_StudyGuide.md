# DATA ENGINEER INTERVIEW STUDY GUIDE

## Comprehensive Coverage of:
- SQL - Advanced Queries and Optimization
- Data Modeling - Dimensional & Normalization
- System Design - Scalable Data Architectures
- Query Tuning - Performance Optimization
- Hadoop - Distributed Computing Framework
- Hive - Data Warehousing on Hadoop
- Kafka - Event Streaming Platform

---

# 1. SQL - STRUCTURED QUERY LANGUAGE

## 1.1 Window Functions

### Q: Explain window functions and their use cases.

**Answer:** Window functions perform calculations across a set of rows that are related to the current row, without collapsing the result set like GROUP BY does. They operate on a "window" of rows defined by the OVER clause.

**Key Components:**
- **PARTITION BY**: Divides rows into partitions
- **ORDER BY**: Defines the order within each partition
- **Frame Clause**: Defines the subset of rows (ROWS or RANGE)

**Common Functions:**
- `ROW_NUMBER()`: Assigns unique sequential numbers
- `RANK()`: Assigns rank with gaps for ties
- `DENSE_RANK()`: Assigns rank without gaps
- `LAG()/LEAD()`: Access previous/next row values
- `SUM()/AVG() OVER`: Running totals and moving averages

**Example:**
```sql
SELECT employee_id, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank,
       AVG(salary) OVER (PARTITION BY department) as dept_avg_salary
FROM employees;
```

### Q: Write a query to find the second highest salary per department.

**Answer:** Use DENSE_RANK() to avoid gaps when there are ties:

```sql
WITH ranked_salaries AS (
  SELECT department, salary,
         DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank
  FROM employees
)
SELECT department, salary
FROM ranked_salaries
WHERE rank = 2;
```

### Q: Calculate a running total of sales by month.

**Answer:**
```sql
SELECT month, sales,
       SUM(sales) OVER (ORDER BY month 
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM monthly_sales
ORDER BY month;
```

---

## 1.2 Common Table Expressions (CTEs)

### Q: What are CTEs and when should you use them?

**Answer:** CTEs (Common Table Expressions) are temporary named result sets that exist only during query execution. They improve readability and can be referenced multiple times within the same query.

**Advantages:**
- Improved query readability and maintainability
- Can be referenced multiple times in the same query
- Support for recursive queries
- Better alternative to subqueries for complex logic

**Example:**
```sql
WITH high_performers AS (
  SELECT employee_id, department, performance_score
  FROM employees
  WHERE performance_score > 8
)
SELECT department, COUNT(*) as high_performer_count
FROM high_performers
GROUP BY department;
```

### Q: Write a recursive CTE to traverse a hierarchical employee structure.

**Answer:**
```sql
WITH RECURSIVE employee_hierarchy AS (
  -- Anchor: Start with top-level managers
  SELECT employee_id, manager_id, name, 1 as level
  FROM employees
  WHERE manager_id IS NULL
  
  UNION ALL
  
  -- Recursive: Join with subordinates
  SELECT e.employee_id, e.manager_id, e.name, eh.level + 1
  FROM employees e
  INNER JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM employee_hierarchy
ORDER BY level, employee_id;
```

---

## 1.3 Joins and Set Operations

### Q: Explain the difference between INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN.

**Answer:**
- **INNER JOIN**: Returns only matching rows from both tables
- **LEFT JOIN**: Returns all rows from left table, matching rows from right (NULL if no match)
- **RIGHT JOIN**: Returns all rows from right table, matching rows from left (NULL if no match)
- **FULL OUTER JOIN**: Returns all rows from both tables, with NULLs where no match exists
- **CROSS JOIN**: Returns Cartesian product of both tables

**Performance consideration:** INNER JOINs are typically faster as they reduce the result set. Outer joins must scan more rows and handle NULLs.

### Q: What's the difference between UNION and UNION ALL?

**Answer:**
- **UNION**: Combines results and removes duplicates (implicit DISTINCT). Slower due to sorting/deduplication.
- **UNION ALL**: Combines all results including duplicates. Faster as no deduplication is needed.

**Best Practice:** Use UNION ALL when you know there are no duplicates or duplicates are acceptable. Only use UNION when deduplication is required.

### Q: Find customers who made purchases in 2023 but not in 2024.

**Answer:**
```sql
-- Using NOT EXISTS (typically faster)
SELECT DISTINCT c.customer_id, c.name
FROM customers c
INNER JOIN orders o2023 ON c.customer_id = o2023.customer_id
WHERE YEAR(o2023.order_date) = 2023
  AND NOT EXISTS (
    SELECT 1 FROM orders o2024
    WHERE o2024.customer_id = c.customer_id
      AND YEAR(o2024.order_date) = 2024
  );

-- Alternative using EXCEPT (SQL Server, PostgreSQL)
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2023
EXCEPT
SELECT customer_id FROM orders WHERE YEAR(order_date) = 2024;
```

---

## 1.4 Aggregations and GROUP BY

### Q: Explain GROUP BY, HAVING, and the order of SQL execution.

**Answer:** SQL logical execution order is:

1. **FROM** - Table joins
2. **WHERE** - Row filtering before grouping
3. **GROUP BY** - Group rows by specified columns
4. **HAVING** - Filter groups after aggregation
5. **SELECT** - Project columns
6. **ORDER BY** - Sort final results
7. **LIMIT/OFFSET** - Restrict result set

**WHERE vs HAVING:**
- **WHERE**: Filters individual rows before grouping
- **HAVING**: Filters groups after aggregation

**Example:**
```sql
SELECT department, AVG(salary) as avg_salary
FROM employees
WHERE hire_date >= '2020-01-01'  -- Filter rows before grouping
GROUP BY department
HAVING AVG(salary) > 75000;       -- Filter groups after aggregation
```

### Q: What are GROUPING SETS, ROLLUP, and CUBE?

**Answer:** These are advanced GROUP BY extensions for multi-dimensional aggregations:

- **GROUPING SETS**: Specify multiple grouping combinations in one query
- **ROLLUP**: Creates hierarchical subtotals (left to right hierarchy)
- **CUBE**: Creates all possible grouping combinations (power set)

**Example - ROLLUP:**
```sql
SELECT year, quarter, SUM(sales) as total_sales
FROM sales_data
GROUP BY ROLLUP(year, quarter);
-- Returns: (year, quarter), (year, NULL), (NULL, NULL)
-- Gives totals by quarter, by year, and grand total
```

**Example - CUBE:**
```sql
SELECT region, product, SUM(sales)
FROM sales_data
GROUP BY CUBE(region, product);
-- Returns all combinations:
-- (region, product), (region, NULL), (NULL, product), (NULL, NULL)
```

### Q: Calculate year-over-year growth percentage.

**Answer:**
```sql
SELECT year, revenue,
       LAG(revenue) OVER (ORDER BY year) as prev_year_revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY year)) * 100.0 / 
             LAG(revenue) OVER (ORDER BY year), 2) as yoy_growth_pct
FROM annual_revenue
ORDER BY year;
```

---

## 1.5 Subqueries and Derived Tables

### Q: What are correlated vs non-correlated subqueries?

**Answer:**

**Non-correlated subquery:** Executes once independently. Can be evaluated before the outer query.
```sql
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**Correlated subquery:** References outer query columns. Executes once per outer row. Generally slower.
```sql
SELECT e.name, e.salary
FROM employees e
WHERE salary > (SELECT AVG(salary) 
                FROM employees 
                WHERE department = e.department);
```

**Performance Tip:** Correlated subqueries can often be rewritten as JOINs or window functions for better performance.

### Q: When should you use EXISTS vs IN?

**Answer:**
- **EXISTS**: Returns TRUE as soon as first match is found (short-circuits). Better for large subquery results.
- **IN**: Evaluates all subquery results. Better for small, static lists.

**Performance comparison:**
```sql
-- EXISTS (typically faster for large result sets)
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- IN (good for small lists)
SELECT * FROM employees WHERE department_id IN (1, 2, 3);

-- NOT EXISTS handles NULLs correctly
SELECT * FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);
```

**NULL handling:** EXISTS works correctly with NULLs, while IN may produce unexpected results when the subquery contains NULLs.

---

# 2. DATA MODELING

## 2.1 Normalization

### Q: Explain database normalization and its normal forms.

**Answer:** Normalization is the process of organizing data to minimize redundancy and dependency. The goal is to isolate data so that changes to one piece affect only one place.

- **1NF (First Normal Form)**: Atomic values, no repeating groups. Each cell contains single value.
- **2NF (Second Normal Form)**: Must be in 1NF. All non-key attributes fully dependent on primary key. No partial dependencies.
- **3NF (Third Normal Form)**: Must be in 2NF. No transitive dependencies. Non-key attributes depend only on primary key.
- **BCNF (Boyce-Codd)**: Stricter version of 3NF. Every determinant must be a candidate key.

**Example - Violation of 2NF:**
```
OrderDetails (OrderID, ProductID, ProductName, Quantity)
-- ProductName depends only on ProductID (partial dependency)
-- Solution: Split into Orders and Products tables
```

### Q: When should you denormalize a database?

**Answer:** Denormalization adds redundancy to improve read performance. Use when:

- Read performance is critical and writes are infrequent
- Complex joins significantly impact query performance
- Aggregated data is frequently accessed
- Historical data that doesn't change

**Common denormalization patterns:**
- Adding redundant columns to avoid joins
- Pre-calculating aggregates (counts, sums, averages)
- Storing derived values
- Adding summary tables

**Trade-offs:**
- **Pros**: Faster reads, simpler queries, reduced join overhead
- **Cons**: Data redundancy, update anomalies, more storage, complex write logic

---

## 2.2 Dimensional Modeling

### Q: Explain Star Schema and Snowflake Schema.

**Answer:** Both are dimensional modeling techniques for data warehouses.

**Star Schema:**
- Central fact table surrounded by denormalized dimension tables
- Simpler queries with fewer joins
- Better query performance
- More storage due to denormalization
- Easier to understand and navigate

**Snowflake Schema:**
- Normalized dimension tables (dimensions split into sub-dimensions)
- Less data redundancy and storage
- More complex queries with additional joins
- Slower query performance
- Better data integrity

**Example Star Schema:**
```
Fact_Sales (sale_id, date_key, product_key, customer_key, store_key, quantity, amount)
Dim_Date (date_key, date, year, quarter, month, day)
Dim_Product (product_key, product_name, category, brand)
Dim_Customer (customer_key, name, city, state, country)
Dim_Store (store_key, store_name, city, state, region)
```

### Q: What are Fact and Dimension tables?

**Answer:**

**Fact Tables:**
- Store quantitative, measurable business metrics (facts)
- Contains foreign keys to dimension tables
- Typically much larger than dimension tables
- Examples: Sales amount, quantity sold, order count
- Types: Transactional, Periodic Snapshot, Accumulating Snapshot

**Dimension Tables:**
- Descriptive attributes providing context to facts
- Relatively smaller, wide tables
- Used for filtering, grouping, and labeling
- Examples: Product, Customer, Time, Location
- Often contains hierarchies (Year > Quarter > Month > Day)

### Q: Explain Slowly Changing Dimensions (SCD) Types.

**Answer:** SCDs handle how dimension attributes change over time.

- **Type 0**: Retain original value. Never change.
- **Type 1**: Overwrite old value. No history preserved.
  - Example: Customer address updated directly
- **Type 2**: Add new row with version. Preserves full history. Most common.
  - Columns: surrogate_key, natural_key, attribute, start_date, end_date, is_current
- **Type 3**: Add columns for current and previous values. Limited history.
  - Columns: customer_key, current_address, previous_address
- **Type 4**: Separate current and historical tables.
- **Type 6 (Hybrid)**: Combination of Types 1, 2, and 3. Tracks current and historical values.

---

## 2.3 Data Vault Modeling

### Q: What is Data Vault and its core components?

**Answer:** Data Vault is an agile modeling technique designed for long-term historical storage and scalability. It separates business keys, relationships, and descriptive data.

**Core Components:**
- **Hubs**: Store unique business keys (e.g., Customer_Hub with customer_id)
- **Links**: Store relationships between hubs (e.g., Order_Customer_Link)
- **Satellites**: Store descriptive attributes and track history (e.g., Customer_Satellite with name, address, effective_date)

**Advantages:**
- Highly scalable and flexible
- Supports parallel loading from multiple sources
- Audit trail built-in
- Handles changing business requirements easily

**Disadvantages:**
- More complex to query (requires joins across hubs, links, satellites)
- Steeper learning curve
- Requires additional transformation layer for reporting

---

# 3. SYSTEM DESIGN

## 3.1 Data Pipeline Architecture

### Q: Design a real-time data pipeline for processing user events.

**Answer:** A typical real-time event processing pipeline includes:

**Components:**
- **Ingestion Layer**: Kafka for event streaming, handling millions of events per second
- **Stream Processing**: Apache Flink or Spark Streaming for real-time transformations
- **Storage**:
  - Hot storage: Redis/Cassandra for recent data and fast lookups
  - Cold storage: S3/HDFS for historical data
  - Analytics: Redshift/Snowflake for data warehouse
- **Monitoring**: Prometheus + Grafana for pipeline health, latency tracking

**Architecture Flow:**
```
User Events → Kafka Topics → Flink Jobs → 
  ├─ Real-time Metrics (Redis)
  ├─ Event Store (Cassandra)
  └─ Data Warehouse (Hourly batch to Redshift)
```

**Key Considerations:**
- Exactly-once processing semantics
- Handling late-arriving data with watermarks
- Schema evolution and backward compatibility
- Dead letter queues for failed messages
- Backpressure handling

### Q: Design a batch ETL pipeline for daily data processing.

**Answer:**

**Extraction:**
- Extract from multiple sources (databases, APIs, files)
- Use incremental extraction with change data capture (CDC) when possible
- Store raw data in data lake (S3/HDFS)

**Transformation:**
- Apache Spark for distributed processing
- Data quality checks and validation
- Business logic transformations
- Aggregations and denormalizations

**Loading:**
- Load to data warehouse (full or incremental)
- Update dimension tables (handle SCDs)
- Load fact tables with partitioning

**Orchestration:**
- Use Apache Airflow for workflow management
- DAG dependencies and scheduling
- Retry logic and alerting
- Data lineage tracking

---

## 3.2 Scalability and Performance

### Q: How do you partition large datasets?

**Answer:** Partitioning strategies depend on data access patterns:

**Time-based Partitioning**: Most common for event data
- Partition by date (year/month/day)
- Example: `/data/year=2024/month=01/day=15/`
- Enables partition pruning for time-range queries

**Hash Partitioning**: Distributes data evenly
- Hash on customer_id, user_id, etc.
- Good for distributed processing

**Range Partitioning**: Based on value ranges
- Example: salary ranges, age groups

**List Partitioning**: Based on discrete values
- Example: by region (US, EU, APAC)

**Hive Partitioning Example:**
```sql
CREATE TABLE events (
  event_id STRING,
  user_id STRING,
  event_type STRING
)
PARTITIONED BY (year INT, month INT, day INT)
STORED AS PARQUET;
```

### Q: Explain data skew and how to handle it.

**Answer:** Data skew occurs when data is unevenly distributed across partitions, causing some workers to process significantly more data than others.

**Types of Skew:**
- **Key Skew**: Uneven distribution of keys (e.g., 80% of users from one city)
- **Join Skew**: One side of join has hot keys

**Solutions:**
- **Salting**: Add random suffix to keys to distribute load
  ```
  -- Original: user_id='popular_user'
  -- Salted: user_id='popular_user_0', 'popular_user_1', ...
  ```
- **Isolated Broadcast Join**: Separate hot keys and broadcast join them
- **Adaptive Query Execution**: Spark 3.0+ can automatically handle some skew
- **Repartitioning**: Use better partition keys or increase partition count

---

## 3.3 Data Quality and Governance

### Q: How do you ensure data quality in a data pipeline?

**Answer:**

**Schema Validation:**
- Define and enforce schemas at ingestion
- Use schema registries (Confluent Schema Registry)

**Data Profiling:**
- Compute statistics (min, max, distinct count, nulls)
- Identify anomalies and outliers

**Quality Checks:**
- **Completeness**: No missing required fields
- **Accuracy**: Values within expected ranges
- **Consistency**: Cross-field validation
- **Uniqueness**: Check for duplicates
- **Timeliness**: Data freshness checks

**Data Quality Tools:**
- Great Expectations for Python-based validation
- Deequ for Spark-based quality checks
- Monte Carlo for data observability

---

# 4. QUERY TUNING AND OPTIMIZATION

## 4.1 Indexing Strategies

### Q: Explain different types of database indexes.

**Answer:**

- **B-Tree Index**: Default in most databases. Balanced tree structure. Good for range queries and equality.
- **Hash Index**: Fast equality lookups. Cannot support range queries.
- **Bitmap Index**: Efficient for low-cardinality columns. Common in data warehouses.
- **Clustered Index**: Physical order of data matches index order. One per table.
- **Non-Clustered Index**: Separate structure with pointers to data. Multiple allowed per table.
- **Covering Index**: Includes all columns needed by query (index-only scan).
- **Partial Index**: Index on subset of rows (WHERE clause in index definition).
- **Full-Text Index**: Optimized for text search queries.

### Q: When should you avoid using an index?

**Answer:** Indexes have overhead and aren't always beneficial:

- Small tables (full table scan is faster)
- Columns with high percentage of NULL values
- Tables with frequent INSERT/UPDATE/DELETE operations
- Queries returning large percentage of rows (>15-20%)
- Functions applied to indexed columns (breaks index usage)

**Example:**
```sql
-- Bad: Function prevents index usage
WHERE YEAR(order_date) = 2024

-- Good: Index can be used
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
```

---

## 4.2 Execution Plans

### Q: How do you read and interpret a query execution plan?

**Answer:** Execution plans show how the database executes a query. Key elements to analyze:

**Scan Types:**
- **Table Scan**: Reads entire table (slow for large tables)
- **Index Seek**: Uses index to find specific rows (fast)
- **Index Scan**: Reads entire index (better than table scan)

**Join Methods:**
- **Nested Loop**: Good for small datasets or when one side is small
- **Hash Join**: Good for large datasets with equality conditions
- **Merge Join**: Good for sorted data, range conditions

**Cost Metrics:**
- Estimated vs Actual rows
- CPU and I/O costs
- Execution time

**Red Flags:**
- Large discrepancy between estimated and actual rows
- Table scans on large tables
- High-cost operations (sort, hash aggregate)
- Implicit conversions or type mismatches

### Q: What causes statistics to become outdated and why does it matter?

**Answer:** Database statistics track data distribution (row counts, distinct values, histograms). The query optimizer uses these to choose the best execution plan.

**Causes of Stale Statistics:**
- Large data modifications (INSERT, UPDATE, DELETE)
- Bulk loads
- Index rebuilds
- Data distribution changes over time

**Impact:**
- Suboptimal execution plans (wrong join order, scan type)
- Performance degradation

**Solution:**
```sql
-- Update statistics
ANALYZE TABLE employees;  -- PostgreSQL
UPDATE STATISTICS employees;  -- SQL Server
ANALYZE TABLE employees COMPUTE STATISTICS;  -- Hive
```

---

## 4.3 Query Optimization Techniques

### Q: List common query optimization techniques.

**Answer:**

- Use SELECT specific columns instead of SELECT *
- Filter early: WHERE conditions before joins when possible
- Use EXISTS instead of IN for subqueries with large result sets
- Avoid functions on indexed columns in WHERE clause
- Use UNION ALL instead of UNION when duplicates are acceptable
- Limit result sets: Use LIMIT/TOP for pagination
- Partition tables: Enable partition pruning
- Use appropriate data types: Avoid implicit conversions
- Batch operations: Bulk inserts instead of row-by-row
- Materialize complex subqueries: Use CTEs or temp tables

### Q: Optimize this slow query.

**Slow Query:**
```sql
SELECT *
FROM orders o
WHERE YEAR(o.order_date) = 2024
  AND o.customer_id IN (SELECT customer_id FROM customers WHERE country = 'USA')
ORDER BY o.order_date;
```

**Answer - Optimized version:**
```sql
-- Optimized Query
SELECT o.order_id, o.order_date, o.total_amount  -- Specific columns
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id  -- JOIN instead of IN
WHERE o.order_date >= '2024-01-01'  -- Index-friendly date range
  AND o.order_date < '2025-01-01'
  AND c.country = 'USA'
ORDER BY o.order_date;
```

**Improvements:**
- Replaced SELECT * with specific columns
- Removed YEAR() function to allow index usage
- Changed IN subquery to INNER JOIN
- Used sargable date range condition

**Additional recommendations:**
- Create index: `CREATE INDEX idx_order_date ON orders(order_date, customer_id);`
- Create index: `CREATE INDEX idx_customer_country ON customers(country);`
- Partition orders table by year/month

---

# 5. HADOOP ECOSYSTEM

## 5.1 HDFS Architecture

### Q: Explain HDFS architecture and its components.

**Answer:** HDFS (Hadoop Distributed File System) is designed for storing large datasets across commodity hardware with high fault tolerance.

**Core Components:**

**NameNode (Master):**
- Manages filesystem metadata and namespace
- Maintains file-to-block mapping
- Handles client read/write requests
- Single point of failure (unless HA enabled)

**DataNodes (Workers):**
- Store actual data blocks
- Send heartbeats to NameNode
- Perform read/write operations

**Secondary NameNode:**
- NOT a backup NameNode
- Performs periodic checkpointing
- Merges fsimage and edit logs

**Key Characteristics:**
- Default block size: 128MB (configurable)
- Default replication factor: 3
- Write-once, read-many access pattern
- Data locality: Move computation to data

### Q: How does HDFS ensure data reliability and fault tolerance?

**Answer:**

**Replication:**
- Each block replicated across multiple DataNodes (default 3)
- Rack-aware placement: 2 replicas on same rack, 1 on different rack
- If DataNode fails, NameNode re-replicates blocks from remaining copies

**Heartbeat Mechanism:**
- DataNodes send heartbeats every 3 seconds
- No heartbeat for 10 minutes = DataNode considered dead

**Block Reports:**
- DataNodes periodically send list of blocks to NameNode
- Helps NameNode detect missing or corrupt blocks

**Checksums:**
- HDFS verifies data integrity using checksums
- Corrupt blocks are detected and re-replicated

---

## 5.2 MapReduce Framework

### Q: Explain the MapReduce programming model.

**Answer:** MapReduce is a distributed computing framework that processes large datasets in parallel across a Hadoop cluster.

**Phases:**

**Map Phase:**
- Input splits distributed to mappers
- Map function transforms input into key-value pairs
- Output written to local disk

**Shuffle and Sort:**
- Framework groups all values for same key
- Data transferred across network to reducers
- Keys sorted before reduce phase

**Reduce Phase:**
- Reduce function processes grouped values
- Produces final output
- Output written to HDFS

**Word Count Example:**
```
Input: "hello world", "hello hadoop"
Map Output: (hello, 1), (world, 1), (hello, 1), (hadoop, 1)
Shuffle: (hello, [1, 1]), (world, [1]), (hadoop, [1])
Reduce Output: (hello, 2), (world, 1), (hadoop, 1)
```

### Q: What are Combiners and when should you use them?

**Answer:** Combiners are mini-reducers that run on mapper output before shuffle phase to reduce data transfer.

**Benefits:**
- Reduces network I/O during shuffle
- Improves overall job performance
- Local aggregation before sending to reducers

**When to use:**
- Aggregation operations (SUM, COUNT, MAX, MIN)
- Operations that are commutative and associative

**When NOT to use:**
- Computing averages (not associative)
- Finding median or percentiles
- Operations requiring all values

---

## 5.3 YARN Resource Management

### Q: Explain YARN architecture.

**Answer:** YARN (Yet Another Resource Negotiator) is Hadoop's cluster resource management framework, separating resource management from application processing.

**Components:**

**ResourceManager (Master):**
- Global resource scheduler
- Allocates resources to applications
- Manages NodeManagers

**NodeManager (Worker):**
- Per-machine agent
- Launches and monitors containers
- Reports resource usage to ResourceManager

**ApplicationMaster:**
- Per-application coordinator
- Negotiates resources from ResourceManager
- Works with NodeManagers to execute tasks

**Container:**
- Resource allocation unit (CPU, memory, disk, network)
- Runs application tasks

### Q: What are YARN schedulers and their differences?

**Answer:**

**FIFO Scheduler:**
- First In, First Out queue
- Simple but not suitable for shared clusters
- Large jobs can block small ones

**Capacity Scheduler:**
- Multiple queues with guaranteed capacity
- Hierarchical queue structure
- Can use spare capacity from other queues
- Good for multi-tenant environments

**Fair Scheduler:**
- Dynamically balances resources across applications
- All jobs get equal share over time
- Supports preemption
- Better for interactive workloads

---

# 6. APACHE HIVE

## 6.1 Hive Fundamentals

### Q: What is Hive and its architecture?

**Answer:** Hive is a data warehouse system built on Hadoop that provides SQL-like query capabilities (HiveQL) for querying and analyzing large datasets stored in HDFS.

**Components:**

**Metastore:**
- Stores metadata about tables, columns, partitions
- Typically uses relational database (MySQL, PostgreSQL)

**Driver:**
- Receives HiveQL queries
- Manages query lifecycle

**Compiler:**
- Parses HiveQL
- Generates execution plan
- Optimizes query

**Execution Engine:**
- Executes the plan (MapReduce, Tez, or Spark)
- Submits jobs to YARN

**Key Features:**
- SQL-like interface for non-programmers
- Support for multiple file formats (ORC, Parquet, Avro)
- Partitioning and bucketing for optimization
- User-defined functions (UDFs)

### Q: Explain Hive partitioning and bucketing.

**Answer:**

**Partitioning:**
- Divides table into parts based on column values
- Each partition stored in separate subdirectory
- Enables partition pruning - only scan relevant partitions
- Best for low-cardinality columns (date, region, category)

```sql
CREATE TABLE sales (
  product_id INT,
  amount DECIMAL(10,2)
)
PARTITIONED BY (year INT, month INT)
STORED AS ORC;
```

**Bucketing:**
- Divides data into fixed number of files based on hash of column
- Good for high-cardinality columns (user_id, transaction_id)
- Improves join performance (bucket map join)
- Enables efficient sampling

```sql
CREATE TABLE users (
  user_id INT,
  name STRING
)
CLUSTERED BY (user_id) INTO 32 BUCKETS
STORED AS ORC;
```

**Comparison:**
- Partitioning: Directory-based, dynamic partition count
- Bucketing: File-based, fixed bucket count
- Can combine both: Partition by date, bucket by user_id

---

## 6.2 Hive File Formats

### Q: Compare ORC and Parquet file formats.

**Answer:** Both are columnar storage formats optimized for big data workloads.

**ORC (Optimized Row Columnar):**
- Developed for Hive
- Stores statistics at file, stripe, and row group level
- Built-in indexes (min/max, bloom filters)
- ACID transaction support
- Better compression (ZLIB, SNAPPY, LZO)
- Faster reads in Hive

**Parquet:**
- Developed by Cloudera and Twitter
- Better ecosystem support (Spark, Impala, Presto)
- Nested data structures support
- Good compression (Snappy, GZIP)
- More portable across platforms

**When to use:**
- **ORC**: Hive-centric workloads, ACID requirements
- **Parquet**: Multi-engine environments, nested data

---

## 6.3 Hive Optimization

### Q: List Hive performance optimization techniques.

**Answer:**

**Use Tez or Spark instead of MapReduce:**
```sql
SET hive.execution.engine=tez;
```

**Enable Cost-Based Optimization (CBO):**
```sql
SET hive.cbo.enable=true;
ANALYZE TABLE tablename COMPUTE STATISTICS;
```

**Use columnar file formats (ORC/Parquet):**
- Better compression and faster queries

**Partition large tables:**
```sql
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
```

**Bucket tables for joins:**
```sql
SET hive.optimize.bucketmapjoin=true;
```

**Enable vectorization:**
```sql
SET hive.vectorized.execution.enabled=true;
```

**Use map-side joins for small tables:**
```sql
SET hive.auto.convert.join=true;
SET hive.mapjoin.smalltable.filesize=25000000;
```

**Compress intermediate data:**
```sql
SET hive.exec.compress.intermediate=true;
```

**Use EXPLAIN EXTENDED to analyze query plans**

### Q: What are Hive transactions and ACID support?

**Answer:** Starting with Hive 0.14, Hive supports ACID (Atomicity, Consistency, Isolation, Durability) transactions on ORC tables.

**Requirements:**
- Table must be in ORC format
- Table must be bucketed
- Set transactional property to true

**Example:**
```sql
CREATE TABLE transactions (
  id INT,
  amount DECIMAL(10,2)
)
CLUSTERED BY (id) INTO 8 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- Enable ACID operations
SET hive.support.concurrency=true;
SET hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;

-- Now you can use UPDATE, DELETE, INSERT
UPDATE transactions SET amount = amount * 1.1 WHERE id = 100;
DELETE FROM transactions WHERE amount < 0;
```

---

# 7. APACHE KAFKA

## 7.1 Kafka Architecture

### Q: Explain Kafka's core concepts and architecture.

**Answer:** Kafka is a distributed event streaming platform designed for high-throughput, fault-tolerant, real-time data pipelines.

**Core Concepts:**
- **Topic**: Category/feed name where records are published. Partitioned for parallelism.
- **Partition**: Ordered, immutable sequence of records. Unit of parallelism.
- **Offset**: Unique sequential ID for each record within a partition.
- **Producer**: Publishes records to topics.
- **Consumer**: Subscribes to topics and processes records.
- **Consumer Group**: Set of consumers working together. Each partition consumed by one consumer in group.

**Components:**
- **Broker**: Kafka server that stores and serves data. Cluster has multiple brokers.
- **ZooKeeper (or KRaft)**: Manages cluster metadata and leader election. KRaft mode removes ZooKeeper dependency.

**Key Properties:**
- Distributed and horizontally scalable
- Fault-tolerant through replication
- High throughput (millions of messages/sec)
- Durable message storage (configurable retention)
- Real-time processing

### Q: How does Kafka ensure fault tolerance and data durability?

**Answer:**

**Replication:**
- Each partition has one leader and multiple followers (replicas)
- Replication factor determines number of copies (typically 3)
- Leader handles all reads and writes
- Followers replicate data from leader

**In-Sync Replicas (ISR):**
- Replicas that are caught up with leader
- If leader fails, new leader elected from ISR

**Acknowledgments (acks):**
- **acks=0**: Producer doesn't wait for acknowledgment (fastest, least safe)
- **acks=1**: Leader writes to local log (balanced)
- **acks=all**: Leader waits for all ISR to acknowledge (slowest, safest)

**Log Segments:**
- Data persisted to disk in log segments
- Configurable retention (time or size-based)
- Old segments deleted or compacted

---

## 7.2 Producers and Consumers

### Q: Explain Kafka producer partitioning strategies.

**Answer:** Producers must decide which partition to send each record to.

**Strategies:**

**Key-based Partitioning:**
- Records with same key go to same partition
- Uses hash(key) % num_partitions
- Maintains ordering per key

**Round-Robin:**
- Used when no key provided
- Distributes messages evenly
- No ordering guarantee

**Custom Partitioner:**
- Implement custom logic
- Example: Route by geographic region

**Example Producer Configuration:**
```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("acks", "all");
props.put("retries", 3);
props.put("batch.size", 16384);
props.put("linger.ms", 10);
```

### Q: How do Kafka consumer groups work?

**Answer:** Consumer groups enable parallel consumption with load balancing and fault tolerance.

**Key Principles:**
- Each partition assigned to exactly one consumer in the group
- One consumer can handle multiple partitions
- Adding consumers (up to partition count) increases parallelism
- More consumers than partitions = some consumers idle

**Rebalancing:**
- Triggered when consumers join/leave group or partition count changes
- Partitions reassigned among consumers
- Brief pause in consumption during rebalance

**Offset Management:**
- Consumer tracks position (offset) in each partition
- Offsets committed to __consumer_offsets topic
- Auto-commit (enable.auto.commit=true) or manual commit

### Q: What are the different delivery semantics in Kafka?

**Answer:**

**At-most-once:**
- Messages may be lost but never redelivered
- Commit offset before processing
- Fastest but least reliable

**At-least-once:**
- Messages never lost but may be redelivered
- Commit offset after processing
- Most common pattern
- Requires idempotent processing

**Exactly-once:**
- Messages delivered and processed exactly once
- Uses Kafka transactions (producer idempotence + transactions)
- Slower but strongest guarantee

**Configuration for exactly-once:**
```java
// Producer
props.put("enable.idempotence", true);
props.put("transactional.id", "my-transactional-id");

// Consumer
props.put("isolation.level", "read_committed");
```

---

## 7.3 Kafka Performance and Tuning

### Q: What factors affect Kafka throughput and how do you optimize it?

**Answer:**

**Producer Optimization:**
- **Batching**: Increase batch.size (default 16KB) and linger.ms to send larger batches
- **Compression**: Use compression.type (snappy, lz4, gzip, zstd) to reduce network I/O
- **Acks**: Lower acks setting (1 instead of all) for higher throughput
- **Buffer Memory**: Increase buffer.memory if producer blocked

**Broker Optimization:**
- **Partition Count**: More partitions = more parallelism (but more overhead)
- **Replication Factor**: Balance durability vs throughput (3 is standard)
- **Log Segment Size**: Larger segments reduce overhead
- **Disk I/O**: Use fast SSDs, RAID arrays

**Consumer Optimization:**
- **Fetch Size**: Increase fetch.min.bytes and max.partition.fetch.bytes
- **Consumer Count**: Scale up to partition count for parallelism
- **Processing**: Optimize application processing logic

### Q: Explain Kafka's log compaction feature.

**Answer:** Log compaction is a retention policy that keeps the latest value for each key, creating a compact log of the latest state.

**How it works:**
- Retains at least the last known value for each key
- Deletes older values for the same key
- Tombstone records (null value) mark keys for deletion
- Background thread performs compaction

**Use cases:**
- Database change capture (CDC)
- Event sourcing with state snapshots
- Cache updates
- User profile updates

**Configuration:**
```
log.cleanup.policy=compact
min.cleanable.dirty.ratio=0.5
segment.ms=604800000  # 7 days
```

---

## 7.4 Kafka Streams and Connect

### Q: What is Kafka Streams and its key features?

**Answer:** Kafka Streams is a client library for building stream processing applications that process data stored in Kafka.

**Key Features:**
- No separate cluster needed - runs as library in your application
- Exactly-once processing semantics
- Stateful processing with state stores
- Windowing operations (tumbling, hopping, sliding, session)
- Joins (stream-stream, stream-table, table-table)
- Aggregations (count, sum, groupBy)

**Core Abstractions:**
- **KStream**: Unbounded stream of records (insert semantics)
- **KTable**: Changelog stream representing current state (update semantics)
- **GlobalKTable**: Fully replicated KTable

**Example:**
```java
StreamsBuilder builder = new StreamsBuilder();

KStream<String, String> source = builder.stream("input-topic");

KStream<String, Long> wordCounts = source
    .flatMapValues(value -> Arrays.asList(value.toLowerCase().split("\W+")))
    .groupBy((key, word) -> word)
    .count()
    .toStream();

wordCounts.to("output-topic");
```

### Q: What is Kafka Connect and its use cases?

**Answer:** Kafka Connect is a framework for streaming data between Kafka and external systems (databases, file systems, cloud services).

**Components:**
- **Source Connectors**: Import data from external systems into Kafka
- **Sink Connectors**: Export data from Kafka to external systems
- **Converters**: Transform data format (JSON, Avro, Protobuf)
- **Transforms**: Modify records in-flight (SMT - Single Message Transforms)

**Modes:**
- **Standalone**: Single process, good for development
- **Distributed**: Multiple workers, fault-tolerant, scalable

**Popular Connectors:**
- JDBC Source/Sink: Relational databases
- Elasticsearch Sink: Search and analytics
- S3 Sink: Data lake storage
- HDFS Sink: Hadoop integration
- Debezium: CDC from databases

---

# 8. ADVANCED TOPICS AND BEST PRACTICES

## 8.1 Data Pipeline Design Patterns

### Q: What is Lambda Architecture?

**Answer:** Lambda Architecture is a data processing architecture that handles both real-time and batch processing.

**Three Layers:**

**Batch Layer:**
- Processes all historical data
- Precomputes batch views
- Accurate but high latency

**Speed Layer:**
- Processes recent data only
- Provides real-time views
- Lower latency, approximate results

**Serving Layer:**
- Merges batch and real-time views
- Responds to queries

**Pros:**
- Handles both batch and real-time
- Fault-tolerant

**Cons:**
- Complex - maintain two code paths
- Duplicate logic

### Q: What is Kappa Architecture and how does it differ from Lambda?

**Answer:** Kappa Architecture simplifies Lambda by using only stream processing for both real-time and batch workloads.

**Key Principles:**
- Everything is a stream
- Single code path for processing
- Reprocess data by replaying stream
- Store raw events indefinitely (or long retention)

**Advantages:**
- Simpler architecture
- Single codebase to maintain
- Easier to reason about

**When to use:**
- Stream processing engine can handle batch workloads
- Data retention is feasible
- Want to minimize complexity

---

## 8.2 Data Quality and Testing

### Q: How do you test data pipelines?

**Answer:**

**Unit Tests:**
- Test individual transformation functions
- Mock data sources and sinks
- Test data quality rules

**Integration Tests:**
- Test end-to-end pipeline with sample data
- Use containerized dependencies (Docker)
- Verify data correctness and completeness

**Data Quality Tests:**
- Schema validation
- Null checks and completeness
- Range and constraint validation
- Referential integrity
- Freshness checks

**Performance Tests:**
- Load testing with production-like volumes
- Benchmark query performance
- Monitor resource utilization

---

## 8.3 Interview Tips and Common Scenarios

### Q: Design a system to process 1 billion events per day.

**Answer:** This is a common system design question. Approach:

**1. Clarify Requirements:**
- Event size? (1KB = ~1TB/day)
- Peak vs average load?
- Latency requirements? (real-time vs batch)
- Retention period?

**2. High-Level Design:**
- Ingestion: Kafka (distributed, scalable, durable)
- Processing: Spark/Flink for transformations
- Storage: S3/HDFS for raw, Redshift/Snowflake for analytics
- Serving: ElasticSearch for search, Redis for caching

**3. Scaling Considerations:**
- Partition Kafka topics (50-100 partitions)
- Horizontal scaling of consumers
- Partition warehouse tables by date
- Use columnar formats (Parquet/ORC)

**4. Monitoring:**
- End-to-end latency tracking
- Data quality metrics
- Resource utilization
- Alert on anomalies

### Q: How would you handle schema evolution?

**Answer:**

**Use Schema Registry:**
- Centralized schema management
- Version control for schemas
- Compatibility checking

**Compatibility Types:**
- **Backward**: New schema reads old data
- **Forward**: Old schema reads new data
- **Full**: Both directions

**Best Practices:**
- Add fields with default values
- Never remove required fields
- Use Avro/Protobuf for schema support
- Version your schemas
- Test compatibility before deployment

---

# 9. FINAL PREPARATION TIPS

## What to Focus On

- **SQL Mastery**: Practice complex joins, window functions, and optimization
- **Distributed Systems**: Understand partitioning, replication, and fault tolerance
- **Hands-On Experience**: Build actual projects with Spark, Kafka, and Airflow
- **System Design**: Practice designing end-to-end data pipelines
- **Performance Tuning**: Learn to identify and resolve bottlenecks

## Common Interview Mistakes to Avoid

- Not asking clarifying questions
- Jumping to implementation without design
- Ignoring edge cases and error handling
- Over-engineering simple problems
- Not discussing trade-offs
- Weak understanding of fundamentals

## During the Interview

- Think out loud - explain your reasoning
- Start with high-level design before diving into details
- Discuss assumptions and constraints
- Consider scalability, reliability, and maintainability
- Be honest about what you don't know
- Ask questions and engage in discussion

## Additional Resources

**Books:**
- Designing Data-Intensive Applications by Martin Kleppmann
- The Data Warehouse Toolkit by Ralph Kimball
- Hadoop: The Definitive Guide by Tom White

**Practice Platforms:**
- LeetCode - SQL section
- HackerRank - SQL and databases
- DataLemur - Data engineering questions

**Documentation:**
- Apache Spark, Kafka, Airflow official docs
- Hive, Hadoop documentation
- Cloud platform docs (AWS, GCP, Azure)

---

**Good luck with your interviews!**
