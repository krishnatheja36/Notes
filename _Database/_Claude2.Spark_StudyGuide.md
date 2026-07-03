# PySpark Interview Preparation Guide

> **Comprehensive PySpark notes with detailed comments, best practices, and interview-focused content**

---

## Cheat Sheet

### Theory
```
- Containers → Driver → Executor
- Log4j → Logger, Configurations, Appender
- Transformations(functions and methods)
    - Narrow dependency transformation : Can be performed in a single partition(where)
    - Wide dependency transformation : Required all partition(group by)
- Actions → read, write, collect, show
- Lazy evaluation → not performed as individual operation but an optimized(By catalyst optimizer) execution plan, terminated by an action
- Execution plan →
    - Application
        - jobs → Stages → tasks
        - each action results in a job
		- exchange
- SparkSQL stages
    - Analysis(syntax checks)
    - Logical Optimization(SQL-optimization - Predicate push down, Projection pruning, Boolean simplification, constant folding)
	- Physical planning(creates a set of RDD operations)
	- Code Generation(Generate java byte code to run on each machine)
- Data Sources and Sinks:
    - Spark Databases & Tables:
        - Table Data(Spark Warehouse) and Table Metadata(Catalog Metastore) - view/ - Hive Metastore
        - Spark Tables
	        - Managed Tables
	        - External Tables
```

### Imports
```
cat $SPARK_HOME → /Users/krishnathejaupadhyaya/Library/Spark/spark-3.4.0-bin-hadoop3/
```
```python
from pyspark import SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import StructType, StructField, StringType,  IntegerType
```

### Session creation
```python
# Option1
spark = SparkSession \
    .builder \
    .master("local[3]") \
    .appName("App_name") \
    .enableHiveSupport() \                            # Hive connection/ Hive meta store access #Optional
    .config("spark.sql.shuffle.partitions", 3) \
    .getOrCreate()

spark.conf.set("spark.sql.shuffle.partitions", 3)     # or shuffle partitions can be set after session creation

# Option2
# Config file
[SPARK_APP_CONFIGS]
spark.app.name = HelloSpark
spark.master = local[3]
spark.sql.shuffle.partitions = 2

# Parse config file
spark_conf = SparkConf()
config = configparser.ConfigParser()
config.read("./01-HelloSpark/spark.conf")
for (key, val) in config.items("SPARK_APP_CONFIGS"):
    spark_conf.set(key, val)

spark = SparkSession \
    .builder \
    .config(conf=spark_conf)\
    .getOrCreate()
```

### Spark read
```python
# Create schema - Option1
name_schema = StructType([
    StructField("firstname", StringType(), True),
    StructField("middlename", StringType(), True),
    StructField("lastname", StringType(), True)
])

MySchemaStruct = StructType([
    StructField("id", IntegerType(), False),    # Can't be Null
    StructField("name", name_schema, True),     # Nested StructType
    StructField("age", IntegerType(), True)
])

for field in MySchemaStruct.fields:
    print(f"{field.name}: {field.dataType}, nullable={field.nullable}")

# Create schema - Option2 (simpler to copy from a SQL/Hive)
MySchemaStruct = """
                    FL_DATE DATE,
                    OP_CARRIER STRING,
                    OP_CARRIER_FL_NUM INT,
                    ORIGIN STRING
                """

# Read Data
source_DF = spark.read \
    .format("csv") \
    .option("header", "true") \             # .option("header", "true") or .option("header", True)
    .option("inferschema", "true") \         # .option() method accepts value in two ways - string or Boolean
    .option("samplingRatio", "0.0001") \
    .option("path", file_path) \
    .option("mode", "FAILFAST") \            # Read modes PERMISIVE, FAILFAST, DROPMALFORMED
    .option("dateFormat", "M/d/y") \         # Override required date time format
    .schema(MySchemaStruct) \                # Explicit, Infer schema, Implicit #dont include infer schema in this case
    .load()
```

### Creating dummy dataframe to test
```python
my_schema = StructType([StructField("ID", StringType()), StructField("EventDate", StringType())])
my_rows = [Row("123", "04/05/2020"), Row("124", "4/5/2020"), Row("125", "04/5/2020"), Row("126", "4/05/2020")]
my_rdd = spark.sparkContext.parallelize(my_rows, 2)
my_df = spark.createDataFrame(my_rdd, my_schema)
```

### Rename columns and add columns
```python
renamed_df = raw_df \
    .withColumnRenamed("Call Number", "CallNumber") \
    .withColumnRenamed("Unit ID", "UnitID") \
    .withColumn("WatchDate", to_date("WatchDate", "MM/dd/yyyy")) \  #overwrites existing column, or creates a new column
    .withColumn("AvailableDtTm", to_timestamp("AvailableDtTm", "MM/dd/yyyy hh:mm:ss a")) \
    .withColumn("Delay", round("Delay", 2))
```

### SQL
```python
source_DF.createOrReplaceTempView("source_tbl")
countDF = spark.sql("select Country, count(1) as count from source_tbl where Age<40 group by Country")
or
countDF = spark.sql("select Country, count(1) as count "
                    "from survery_tbl "
                    "where Age<40 "
                    "group by Country")
```

### Spark Write
```python
# Just writes file, no tables
source_DF.write\
        .format("avro")\                    # Default is Parquet
        .mode("overwrite")\                 # saveMode - append, overwrite, errorifExists, ignore
        .option("path","dataSink/avro/")\
        .save()

# PartitionBY(), BucketBy(), SortBy(), maxRecordsPerFile()
paritionedDF = source_DF.repartition(5)
source_DF.write \
        .format("json") \
        .mode("overwrite") \
        .option("path", "dataSink/json/") \
        .partitionBy("OP_CARRIER","ORIGIN") \
        .option("maxRecordsPerFile", 10000)\
        .save()

# Using jdbc -> relational databases
source_DF.write \
        .format("jdbc") \
        .option("url", "jdbc:postgresql://localhost:5432/mydb") \
        .option("dbtable", "public.employees")  # schema.table
        .option("user", "username") \
        .option("password", "password") \
        .mode("append") \
        .save()

# enableHiveSupport spark session, write into Hive tables
source_DF.write \
        .mode("overwrite") \                        # creates new tables
        .partitionBy("year", "month") \
        .bucketBy(10, "customer_id") \
        .sortBy("order_date") \
        .option("path", "hdfs://path/to/data") \    # This option saves it as external table. Else, it gets saved as a managed table.
        .saveAsTable("sales")

source_DF.write \
        .mode("append")\                            # inserts data into existing tables
        .insertInto("sales")
```

### Spark tables
```python
spark.sql("create Database if not exists AIRLINE_DB")
spark.catalog.setCurrentDatabase("AIRLINE_DB")

flightTimeParquetDF.write\
    .format("csv")\                             # default is parque
    .mode("overwrite")\                         # Managed table
    .bucketBy(5, "ORIGIN","OP_CARRIER")\        # other option to .partitionBy("ORIGIN","OP_CARRIER")\
    .sortBy("ORIGIN","OP_CARRIER")\             # Helps with query
    .saveAsTable("flightTimeParquet_tbl")

logger.info(spark.catalog.listTables("AIRLINE_DB"))
```

### Transformations, Methods, Actions
```python
# Actions
.count()
.show()
.distinct()

# Transformations and Methods :
.printSchema()
.cache()
.createGlobalTempView("view_name")
.createOrReplaceTempView('view_name')
.repartition(5)
.rdd.getNumPartitions()
.select("CallType")

df.where("CallType is not null") \
    .select("CallType") \
    .distinct()

df.select(.expr("CallType as distinct_call_type"))
    .where("Delay > 5")
    .groupBy("CallType")
    .count()
    .orderBy("count", ascending=False) \

spark.catalog.listTables("AIRLINE_DB")
```

### Column level transformations
```python
.select(regexp_extract('value', log_reg, 1).alias("ip")
.where("trim(referrer)!= '-'")

.withColumn("id", monotonically_increasing_id())
.withColumn("day", col("day").cast(IntegerType())
.withColumn("referrer", substring_index("referrer", "/", 3))\
, expr("to_date(concat(Year,Month,DayofMonth),'yyyyMMdd') as FlightDate") #adding new column
df.select(column("Origin")) # access column object
df.select("Origin") # access column string
spark.catalog.listFunctions() # check for UDF [logger.info(f) for f in spark.catalog.listFunctions() if "parse_gender" in f.name]
```

### Working with Dataframe rows
```python
def to_date_df(df, fmt, fld):                           # reusable date conversion function
	return df.withColumn(fld, to_date(col(fld), fmt))
new_df = to_date_df(my_df, "M/d/y", "EventDate")
```

### Parsing unstructured files/ log files
```python
log_reg = r'^(\S+) (\S+) (\S+) \[([\w:/]+\s[+\-]\d{4})\] "(\S+) (\S+) (\S+)" (\d{3}) (\S+) "(\S+)" "([^"]*)'
logs_df = file_df.select(regexp_extract('value', log_reg, 1).alias("ip"),
                            regexp_extract('value', log_reg, 4).alias("date"),
                            regexp_extract('value', log_reg, 6).alias("request"),
                            regexp_extract('value', log_reg, 10).alias("referrer"))
logs_df\
    .where("trim(referrer)!= '-'")\
    .withColumn("referrer", substring_index("referrer", "/", 3))\
    .groupby("referrer")\
    .count()\
    .show(100, truncate = False)
```

### Working with Dataframe columns
```python
airlinesDF.select("Origin", "Dest", "Distance").show(10)	                    #access column string
airlinesDF.select(column("Origin"), col("Dest"), airlinesDF.Distance).show(10)  #access column object #Showing 3 different methods #standard is to use column()

airlinesDF.select("Origin", "Dest", "Distance", expr("to_date(concat(Year,Month,DayofMonth),'yyyyMMdd') as FlightDate")).show(10)      #prefered method
airlinesDF.selectExpr("Origin", "Dest", "Distance", "to_date(concat(Year,Month,DayofMonth),'yyyyMMdd') as FlightDate").show(10)
airlinesDF.select("Origin", "Dest", "Distance", to_date(concat("Year","Month","DayofMonth"),'yyyyMMdd').alias("FlightDate")).show(10)
```

### UDF - User Defined Functions
```python
def parse_gender(gender):
    female_pattern = r"^f$|f.m|w.m"
    male_pattern = r"^m$|ma|m.l"
    if re.search(female_pattern, gender.lower()):
        return "Female"
    elif re.search(male_pattern, gender.lower()):
        return "Male"
    else:
        return "Unknown"

parse_gender_udf = udf(parse_gender, StringType())                              # Register as DataFrame UDF. It won't register the UDF in the catalog, just in the executers
survey_df2 = survey_df.withColumn("Gender", parse_gender_udf("Gender"))         # Use it as a Dataframe column expression

spark.udf.register("parse_gender_udf", parse_gender, StringType())              # Use it as a SQL expression. It will also create a entry in the Catalog
survey_df3 = survey_df.withColumn("Gender", expr("parse_gender_udf(Gender)"))
```

### Misc Transformation
```python
df = raw_df.withColumn("id", monotonically_increasing_id())

df2 = df1.withColumn("day", col("day").cast(IntegerType()))\                            # Type cast
        .withColumn("month", col("month").cast(IntegerType()))\
        .withColumn("year", col("year").cast((IntegerType())))

df3 = df2.withColumn("year", expr("""                                                   # Case Expression option 1
    case
        when year < 21
            then year + 2000
        when year < 100
            then year + 1900
        else year
    end
    """))

df4 = df2.withColumn("year", \
                when(col("year") < 20, col("year") + 2000)\                             # Case Expression option 2
                .when(col("year") < 100, col("year") + 1900)\
                .otherwise(col("year")))

df5 = df3.withColumn("dob", expr("to_date(concat(day,'/', month,'/', year), 'd/M/y')")) # Adding columns option 1
df6 = df3.withColumn("dob",(expr("concat(day,'/', month,'/', year)"), 'd/M/y'))         # Adding columns option 1

df7 = df6.drop("day", "month", "year")\                                                 # Dropping columns
    .dropDuplicates(["name", "dob"])\
    .sort(expr("dob desc"))
```

### Aggregations
```python
invoice_df.select(f.count("*").alias("Count *"),                                        # Aggregations option 1
                    f.sum("Quantity").alias("TotalQuantity"),
                    f.avg("UnitPrice").alias("AvgPrice"),
                    f.countDistinct("InvoiceNo").alias("CountDistinct")
                    ).show()

invoice_df.selectExpr(                                                                  # Aggregations option 2
    "count(1) as `count 1`",
    "count(StockCode) as `count field`",
    "sum(Quantity) as `TotalQuantity`",
    "avg(UnitPrice) as AvgPrice"
    ).show()
```

### Grouping
```python
summary_sql = spark.sql("""                                                             # Grouping option 1
                        Select
                            Country,
                            InvoiceNo,
                            Sum(Quantity) as TotalQuantity,
                            round(sum(Quantity * UnitPrice),2) as InvoiceValue
                        from sales                                                      # sales is a temp view
                        Group By Country, InvoiceNo
                        """)

summary_df = invoice_df\                                                                # Grouping option 2
    .groupBy("Country", "InvoiceNo")\
    .agg(f.sum("Quantity").alias("TotalQuantity"),
            f.round(f.sum(f.expr("Quantity * UnitPrice")),2).alias("InvoiceValue"),
            f.expr("round(sum(Quantity * UnitPrice),2) as InvoiceValue")                   # same as above line, using expr outside
            )

NumInvoices = f.countDistinct("InvoiceNo").alias("NumInvoices")
TotalQuantity = f.sum("Quantity").alias("TotalQuantity")
InvoiceValue = f.expr("round(sum(Quantity * UnitPrice),2) as InvoiceValue")

exSummary_df = invoice_df \
    .withColumn("InvoiceDate", f.to_date(f.col("InvoiceDate"), "dd-MM-yyyy H.mm")) \
    .where("year(InvoiceDate) == 2010") \
    .withColumn("WeekNumber", f.weekofyear(f.col("InvoiceDate"))) \
    .groupBy("Country", "WeekNumber") \
    .agg(NumInvoices, TotalQuantity, InvoiceValue)

exSummary_df.coalesce(1) \
    .write \
    .format("parquet") \
    .mode("overwrite") \
    .save("output")
```

### Window function
```python
running_total_window = Window.partitionBy("Country") \                                  # Windowing option 1
    .orderBy("WeekNumber")\
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
summary_df.withColumn("RunningTotal",f.sum("InvoiceValue").over(running_total_window))\
    .show()

summary_df.withColumn("RunningTotal",f.sum("InvoiceValue").over(Window.partitionBy("Country").orderBy("WeekNumber").rowsBetween(Window.unboundedPreceding, Window.currentRow)))\
    .show()                                                                             # Windowing option 2 - inline

rank_window = Window.partitionBy("Country") \                                           # Rank analytical functions too
    .orderBy(f.col("InvoiceValue").desc()) \
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
df = summary_df.withColumn("Rank", f.dense_rank().over(rank_window)) \
    .where(f.col("Rank") == 1) \
    .sort("Country", "WeekNumber") \
    .show()
```

### Joins
```python
join_expr = order_df.prod_id == product_df.prod_id                                      # Inner Join
order_df.join(product_renamed_df, join_expr, "inner") \
    .drop(product_renamed_df.prod_id) \                                                 # it will work with select *, because of unique internal id
    .select("order_id", "prod_id", "prod_name", "unit_price", "list_price", "qty") \    # But, when you specify column name in select, there will be ambiguity
    .show()

order_df.join(product_renamed_df, join_expr, "left") \                                  # Left Join
    .drop(product_renamed_df.prod_id) \
    .select("order_id", "prod_id", "prod_name", "unit_price", "list_price", "qty") \
    .withColumn("prod_name", expr("coalesce(prod_name, prod_id)")) \                    # coalesce()
    .withColumn("list_price", expr("coalesce(list_price, unit_price)")) \
    .sort("order_id") \
    .show()
```

### Optimizing Joins
```python
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", -1) #force short merge join
spark.conf.set("spark.sql.shuffle.partitions", 3)
```
Shuffle join - causes slowness - it sends all data from map exhange to shuffle exchange

Join Strategies:
- Large to Large
    - Always goes to shuffle join
    - Constraints on parallelism/optimizations
        - Run aggregards, filters before join
        - Number of Shuffle paritions
        - Number of Executors
        - Number of Unique keys
        - Key Distribution
        - Bucketing
- Large to Small
    - Can take advantage of a Broadcast join,
    - Mostly, happens by itself
    ```python
    join_df = flight_time_df1.join(broadcast(flight_time_df2), join_expr, "inner")
    ```
- Bucketing - Utilize this to avoid shuffle during join
    ```python
    df1.coalesce(1).write \
        .bucketBy(3, "id") \
        .mode("overwrite") \
        .saveAsTable("MY_DB.flight_data1")
    ```

---

## Core Concepts & Theory

### Spark Execution Model
```
Containers → Driver → Executors
├── Driver: Orchestrates execution, maintains SparkContext
├── Executors: Perform actual computation on worker nodes
└── Cluster Manager: Allocates resources (YARN, Mesos, Kubernetes, Standalone)
```

**Key Interview Points:**
- **Driver** maintains SparkContext, converts user program to tasks, schedules tasks
- **Executors** run tasks and store data in memory/disk
- **Cluster Manager** allocates resources across applications

### Logging
```python
# Log4j components
├── Logger: Creates log messages
├── Appender: Determines output destination (console, file, etc.)
└── Configuration: Controls log levels (INFO, DEBUG, WARN, ERROR)
```

### Transformations vs Actions

**Transformations** (Lazy - creates execution plan):
```python
# Narrow Dependency - No shuffle, single partition operation
# Examples: map(), filter(), select(), where(), withColumn()
df.filter(col("age") > 25)  # Operates within partition

# Wide Dependency - Requires shuffle across partitions
# Examples: groupBy(), join(), repartition(), distinct()
df.groupBy("country").count()  # Needs data from all partitions
```

**Actions** (Eager - triggers execution):
```python
# Examples: show(), collect(), count(), write(), take()
df.show()       # Triggers execution
df.count()      # Returns result to driver
df.collect()    # ⚠️ Brings all data to driver - use cautiously!
```

**💡 Interview Tip:** Explain that transformations are lazy for optimization - Spark builds an execution plan and optimizes before running.

### Lazy Evaluation
```python
# Nothing executes here
df1 = spark.read.csv("file.csv")
df2 = df1.filter(col("age") > 30)
df3 = df2.select("name", "age")

# Execution happens here - Spark optimizes entire pipeline
df3.show()  # Action triggers execution
```

**Benefits:**
- Query optimization by Catalyst Optimizer
- Reduces unnecessary computations
- Enables pipelining and parallel execution

### Execution Plan Hierarchy
```
Application
└── Jobs (created by each action)
    └── Stages (divided at shuffle boundaries)
        └── Tasks (one per partition)
            └── Exchange (shuffle operation between stages)
```

**View execution plan:**
```python
df.explain()                # Physical plan
df.explain(True)            # Logical and physical plans
df.explain("formatted")     # Formatted output
```

### Spark SQL Optimization Stages

1. **Analysis** - Syntax and semantic checks
2. **Logical Optimization**
   - Predicate pushdown: Filter early in execution
   - Projection pruning: Select only needed columns
   - Boolean simplification: Optimize conditions
   - Constant folding: Pre-compute constant expressions
3. **Physical Planning** - Creates RDD operations
4. **Code Generation** - Generates JVM bytecode (Tungsten engine)

**💡 Interview Question:** "How does Spark optimize your queries?"
Answer: Through Catalyst Optimizer's 4 stages - explain each briefly.

---

## Spark Architecture

### Data Sources and Sinks

**Spark Tables:**
```python
# Managed Tables - Spark manages both data and metadata
# When dropped, both data and metadata are deleted
df.write.saveAsTable("managed_table")

# External Tables - Spark manages only metadata
# When dropped, only metadata is deleted, data remains
df.write.option("path", "/path/to/data").saveAsTable("external_table")

# Temporary Views - Session scoped
df.createOrReplaceTempView("temp_view")

# Global Temporary Views - Application scoped
df.createOrReplaceGlobalTempView("global_temp_view")
# Access: spark.sql("SELECT * FROM global_temp.global_temp_view")
```

**Storage Locations:**
- **Catalog Metastore**: Stores table metadata (schema, location, partitions)
- **Spark Warehouse**: Default location for managed table data
- **Hive Metastore**: External metadata store (when using `.enableHiveSupport()`)

---

## Setup & Initialization

### Environment Setup
```bash
# Check Spark installation
cat $SPARK_HOME
# Output: /Users/username/Library/Spark/spark-3.4.0-bin-hadoop3/

# Important Spark directories
$SPARK_HOME/bin      # Executables (spark-submit, pyspark)
$SPARK_HOME/conf     # Configuration files
$SPARK_HOME/jars     # JAR dependencies
```

### Essential Imports
```python
# Core imports
from pyspark import SparkConf
from pyspark.sql import SparkSession, Row
from pyspark.sql.functions import *
from pyspark.sql.types import (
    StructType, StructField, 
    StringType, IntegerType, DoubleType, DateType, TimestampType,
    ArrayType, MapType
)
from pyspark.sql.window import Window

# For UDFs
from pyspark.sql.functions import udf, pandas_udf
from pyspark.sql.types import *

# For broadcasting
from pyspark.sql.functions import broadcast
```

### Session Creation

#### Option 1: Direct Configuration
```python
spark = SparkSession \
    .builder \
    .master("local[3]") \              # local[*] uses all cores, local[3] uses 3 cores
    .appName("MySparkApp") \
    .enableHiveSupport() \             # Optional: Enable Hive metastore support
    .config("spark.sql.shuffle.partitions", 3) \      # Default: 200
    .config("spark.executor.memory", "4g") \          # Executor memory
    .config("spark.driver.memory", "2g") \            # Driver memory
    .config("spark.sql.adaptive.enabled", "true") \   # Adaptive Query Execution
    .config("spark.dynamicAllocation.enabled", "true") \  # Dynamic resource allocation
    .getOrCreate()

# Modify configuration after creation
spark.conf.set("spark.sql.shuffle.partitions", 10)

# Get current configuration
print(spark.conf.get("spark.sql.shuffle.partitions"))
```

**💡 Interview Tip:** Explain the difference between local[*] and local[N]

#### Option 2: Configuration File
```python
# Config file: spark.conf
[SPARK_APP_CONFIGS]
spark.app.name = MySparkApp
spark.master = local[3]
spark.sql.shuffle.partitions = 2
spark.executor.memory = 4g
spark.driver.memory = 2g

# Python code to parse config
import configparser

spark_conf = SparkConf()
config = configparser.ConfigParser()
config.read("./spark.conf")

for (key, val) in config.items("SPARK_APP_CONFIGS"):
    spark_conf.set(key, val)

spark = SparkSession \
    .builder \
    .config(conf=spark_conf) \
    .getOrCreate()
```

**💡 Best Practice:** Use config files for production, direct config for development

### Important Spark Configurations
```python
# Performance tuning
spark.conf.set("spark.sql.adaptive.enabled", "true")           # AQE - Auto optimization
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
spark.conf.set("spark.sql.shuffle.partitions", "200")          # Shuffle partitions
spark.conf.set("spark.default.parallelism", "100")             # Default parallelism

# Memory management
spark.conf.set("spark.executor.memory", "4g")
spark.conf.set("spark.driver.memory", "2g")
spark.conf.set("spark.memory.fraction", "0.6")                 # Execution + storage memory
spark.conf.set("spark.memory.storageFraction", "0.5")          # Storage vs execution

# Broadcast join threshold
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "10485760")  # 10MB default

# Serialization (Kryo is faster than Java)
spark.conf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
```

---

## Data Reading & Schema

### Schema Definition

#### Option 1: StructType (Programmatic)
```python
# Simple schema
schema = StructType([
    StructField("id", IntegerType(), nullable=False),     # NOT NULL
    StructField("name", StringType(), True),              # Nullable
    StructField("age", IntegerType(), True),
    StructField("salary", DoubleType(), True)
])

# Nested schema example
address_schema = StructType([
    StructField("street", StringType(), True),
    StructField("city", StringType(), True),
    StructField("zipcode", StringType(), True)
])

person_schema = StructType([
    StructField("id", IntegerType(), False),
    StructField("name", StringType(), True),
    StructField("address", address_schema, True),         # Nested StructType
    StructField("phones", ArrayType(StringType()), True), # Array field
    StructField("metadata", MapType(StringType(), StringType()), True)  # Map field
])

# Access schema information
for field in schema.fields:
    print(f"{field.name}: {field.dataType}, nullable={field.nullable}")
```

#### Option 2: DDL String (Simpler)
```python
# DDL-style schema (easier to copy from SQL/Hive)
schema_ddl = """
    id INT,
    name STRING,
    age INT,
    salary DOUBLE,
    hire_date DATE,
    is_active BOOLEAN
"""

# Complex DDL schema
complex_schema = """
    id INT,
    name STRING,
    address STRUCT<street: STRING, city: STRING, zipcode: STRING>,
    phones ARRAY<STRING>,
    metadata MAP<STRING, STRING>
"""
```

**💡 Interview Tip:** DDL format is preferred for readability and SQL compatibility

### Reading Data

#### CSV Files
```python
df = spark.read \
    .format("csv") \
    .option("header", "true") \              # or .option("header", True)
    .option("inferSchema", "true") \         # Auto-infer types (scans data)
    .option("samplingRatio", "0.1") \        # Sample 10% for schema inference
    .option("path", "/path/to/file.csv") \
    .option("mode", "FAILFAST") \            # PERMISSIVE, FAILFAST, DROPMALFORMED
    .option("dateFormat", "M/d/y") \         # Custom date format
    .option("timestampFormat", "M/d/y H:m:s") \
    .option("multiLine", "true") \           # For multi-line CSV
    .option("escape", "\\") \                # Escape character
    .option("nullValue", "NA") \             # Treat "NA" as null
    .schema(schema) \                        # Explicit schema (preferred)
    .load()

# Shorthand
df = spark.read.csv("/path/to/file.csv", header=True, inferSchema=True)
```

**Read Modes:**
- **PERMISSIVE** (default): Sets corrupted records to null
- **DROPMALFORMED**: Drops corrupted records
- **FAILFAST**: Throws exception on corrupted records

#### JSON Files
```python
df = spark.read \
    .format("json") \
    .option("multiLine", "true") \           # For multi-line JSON
    .option("mode", "FAILFAST") \
    .schema(schema) \
    .load("/path/to/file.json")
```

#### Parquet Files (Columnar format - efficient)
```python
df = spark.read \
    .format("parquet") \
    .load("/path/to/file.parquet")

# Parquet automatically includes schema - no need to specify
```

#### Avro Files
```python
df = spark.read \
    .format("avro") \
    .load("/path/to/file.avro")
```

#### ORC Files
```python
df = spark.read \
    .format("orc") \
    .load("/path/to/file.orc")
```

#### JDBC/Database
```python
df = spark.read \
    .format("jdbc") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("dbtable", "public.employees") \
    .option("user", "username") \
    .option("password", "password") \
    .option("driver", "org.postgresql.Driver") \
    .option("fetchsize", "1000") \            # Rows per fetch
    .option("numPartitions", "10") \          # Parallelism
    .option("partitionColumn", "id") \        # Column for partitioning
    .option("lowerBound", "1") \              # Partition range
    .option("upperBound", "10000") \
    .load()

# Read with query
df = spark.read \
    .format("jdbc") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("query", "SELECT * FROM employees WHERE dept = 'IT'") \
    .option("user", "username") \
    .option("password", "password") \
    .load()
```

#### Hive Tables
```python
# Must enable Hive support in SparkSession
df = spark.read.table("database.table_name")

# Or using SQL
df = spark.sql("SELECT * FROM database.table_name")
```

### Creating Test DataFrames
```python
# Method 1: From list of Rows
from pyspark.sql import Row

data = [
    Row(id=1, name="Alice", age=25),
    Row(id=2, name="Bob", age=30),
    Row(id=3, name="Charlie", age=35)
]
df = spark.createDataFrame(data)

# Method 2: From list of tuples with schema
data = [
    (1, "Alice", 25),
    (2, "Bob", 30),
    (3, "Charlie", 35)
]
schema = ["id", "name", "age"]
df = spark.createDataFrame(data, schema)

# Method 3: From RDD
my_schema = StructType([
    StructField("ID", StringType()),
    StructField("EventDate", StringType())
])
my_rows = [
    Row("123", "04/05/2020"),
    Row("124", "4/5/2020")
]
my_rdd = spark.sparkContext.parallelize(my_rows, 2)  # 2 partitions
df = spark.createDataFrame(my_rdd, my_schema)

# Method 4: From Pandas DataFrame (for small data)
import pandas as pd
pdf = pd.DataFrame({
    'id': [1, 2, 3],
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35]
})
df = spark.createDataFrame(pdf)
```

---

## DataFrame Operations

### Basic Operations
```python
# View data
df.show()                      # Default: 20 rows
df.show(10)                    # Show 10 rows
df.show(10, truncate=False)    # Don't truncate long strings
df.show(vertical=True)         # Vertical display

# Schema information
df.printSchema()               # Tree format
df.schema                      # StructType object
df.dtypes                      # List of (name, type) tuples
df.columns                     # List of column names

# Statistics
df.count()                     # Row count
df.describe().show()           # Summary statistics
df.describe("age", "salary").show()  # Specific columns

# Sample data
df.take(5)                     # First 5 rows as list
df.head(5)                     # First 5 rows as list
df.first()                     # First row
df.limit(10).show()            # Limit to 10 rows

# Collect data (⚠️ Use cautiously - brings all data to driver)
rows = df.collect()            # Returns list of Rows
df.toPandas()                  # Convert to Pandas DataFrame
```

### Column Operations

#### Selecting Columns
```python
# Method 1: String column names
df.select("name", "age").show()

# Method 2: Column objects (recommended for complex operations)
from pyspark.sql.functions import col, column

df.select(col("name"), col("age")).show()
df.select(column("name"), column("age")).show()
df.select(df.name, df.age).show()
df.select(df["name"], df["age"]).show()

# With expressions
df.select(
    col("name"),
    col("age"),
    (col("salary") * 1.1).alias("new_salary")
).show()

# Using expr (SQL expressions)
from pyspark.sql.functions import expr

df.select(
    "name",
    "age",
    expr("salary * 1.1 as new_salary")
).show()

# selectExpr (shorthand for expr)
df.selectExpr(
    "name",
    "age",
    "salary * 1.1 as new_salary",
    "CASE WHEN age > 30 THEN 'Senior' ELSE 'Junior' END as level"
).show()
```

**💡 Interview Tip:** `selectExpr` is cleaner for SQL-like transformations. 
It treats inputs as sql expression. Use ` ` for col names with ' ' - df.selectExpr("`call number`").show()


#### Adding/Modifying Columns
```python
from pyspark.sql.functions import *

# Add new column
df = df.withColumn("bonus", col("salary") * 0.1)

# Modify existing column (overwrites)
df = df.withColumn("salary", col("salary") * 1.05)

# Multiple columns
df = df \
    .withColumn("full_name", concat(col("first_name"), lit(" "), col("last_name"))) \
    .withColumn("hire_year", year(col("hire_date"))) \
    .withColumn("is_senior", col("age") > 30)

# Type casting
df = df.withColumn("age", col("age").cast(IntegerType()))
df = df.withColumn("age", col("age").cast("int"))  # Using string
```

#### Renaming Columns
```python
# Rename single column
df = df.withColumnRenamed("old_name", "new_name")

# Rename multiple columns
df = df \
    .withColumnRenamed("Call Number", "CallNumber") \
    .withColumnRenamed("Unit ID", "UnitID")

# Using select with alias
df = df.select(
    col("old_name").alias("new_name"),
    col("another_old").alias("another_new")
)

# Rename all columns (to lowercase)
df = df.toDF(*[c.lower() for c in df.columns])

# Rename all columns (remove spaces)
df = df.toDF(*[c.replace(" ", "_") for c in df.columns])
```

#### Dropping Columns
```python
# Drop single column
df = df.drop("column_name")

# Drop multiple columns
df = df.drop("col1", "col2", "col3")

# Drop columns by pattern
cols_to_drop = [c for c in df.columns if c.startswith("tmp_")]
df = df.drop(*cols_to_drop)
```

### Filtering/Where
```python
# Using where (same as filter)
df.where("age > 30").show()
df.where(col("age") > 30).show()

# Using filter
df.filter("age > 30").show()
df.filter(col("age") > 30).show()

# Multiple conditions
df.where((col("age") > 30) & (col("salary") > 50000)).show()
df.where((col("age") > 30) | (col("dept") == "IT")).show()

# Using SQL expressions
df.where("age > 30 AND salary > 50000").show()
df.where(expr("age > 30 AND dept = 'IT'")).show()

# IN clause
df.where(col("dept").isin("IT", "HR", "Finance")).show()

# LIKE pattern
df.where(col("name").like("A%")).show()       # Starts with A
df.where(col("name").rlike("^A.*n$")).show()  # Regex

# NULL checks
df.where(col("phone").isNull()).show()
df.where(col("phone").isNotNull()).show()

# NOT condition
df.where(~(col("age") > 30)).show()           # NOT age > 30
```

**💡 Best Practice:** Use `col()` for complex conditions, string for simple ones

### Sorting
```python
# Ascending (default)
df.sort("age").show()
df.orderBy("age").show()

# Descending
df.sort(col("age").desc()).show()
df.orderBy(col("age").desc()).show()

# Multiple columns
df.sort("dept", col("age").desc()).show()

# Using SQL expression
df.sort(expr("age DESC")).show()

# Null handling
df.sort(col("age").asc_nulls_first()).show()
df.sort(col("age").asc_nulls_last()).show()
```

### Distinct and Drop Duplicates
```python
# Distinct rows
df.distinct().show()

# Drop duplicates (all columns)
df.dropDuplicates().show()

# Drop duplicates (specific columns)
df.dropDuplicates(["name", "age"]).show()

# Keep first/last (not directly supported, use window functions)
from pyspark.sql.window import Window

window = Window.partitionBy("name").orderBy(col("date").desc())
df = df.withColumn("row_num", row_number().over(window)) \
    .where(col("row_num") == 1) \
    .drop("row_num")
```

### Handling Nulls
```python
# Drop rows with any null
df.dropna().show()
df.na.drop().show()

# Drop rows with all nulls
df.dropna(how="all").show()

# Drop rows with null in specific columns
df.dropna(subset=["age", "salary"]).show()

# Fill nulls
df.fillna(0).show()                         # Fill all numeric nulls with 0
df.fillna("Unknown").show()                 # Fill all string nulls
df.fillna({"age": 0, "name": "Unknown"}).show()  # Column-specific

# Using coalesce (returns first non-null)
df.withColumn("phone", coalesce(col("mobile"), col("landline"))).show()

# Replace values
df.replace(["NA", "null"], None).show()
df.na.replace(["NA", "null"], None).show()
```

---

## Transformations & Actions

### Common Transformations (Lazy)

```python
# Map transformations (use select/withColumn instead in DataFrame API)
rdd = df.rdd.map(lambda row: row.age * 2)

# Better: Use DataFrame API
df.select((col("age") * 2).alias("double_age"))

# FlatMap (explode arrays)
from pyspark.sql.functions import explode, split

df.withColumn("word", explode(split(col("text"), " "))).show()

# Union (combine DataFrames with same schema)
df1.union(df2).show()
df1.unionAll(df2).show()  # Deprecated, use union
df1.unionByName(df2).show()  # Match by column names

# Intersect
df1.intersect(df2).show()

# Except (like SQL EXCEPT)
df1.subtract(df2).show()
df1.exceptAll(df2).show()

# Repartition
df.repartition(10).show()                    # 10 partitions
df.repartition(10, "dept").show()            # Hash partition by dept
df.repartition("dept", "location").show()    # Multiple columns

# Coalesce (reduce partitions without shuffle)
df.coalesce(2).show()  # Reduce to 2 partitions
```

**💡 Interview Question:** What's the difference between repartition and coalesce?
- **repartition**: Full shuffle, can increase or decrease partitions
- **coalesce**: No shuffle, only decrease partitions (combines existing)

### Common Actions (Eager)

```python
# Count
df.count()                     # Total rows

# Show
df.show()                      # Display rows

# Collect (⚠️ Brings all data to driver)
rows = df.collect()

# Take
first_10 = df.take(10)         # First 10 rows

# First/Head
first_row = df.first()
first_5 = df.head(5)

# Write
df.write.parquet("/path")

# Foreach (side effects - e.g., printing, logging)
df.foreach(lambda row: print(row.name))

# ForeachPartition (more efficient for partition-level operations)
def process_partition(iterator):
    for row in iterator:
        # Process row
        pass

df.foreachPartition(process_partition)

# Reduce (on RDD)
total = df.rdd.map(lambda r: r.salary).reduce(lambda a, b: a + b)
```

---

## SQL & Temp Views

### Creating Views
```python
# Temporary view (session scoped)
df.createOrReplaceTempView("employees")

# Global temporary view (application scoped)
df.createOrReplaceGlobalTempView("global_employees")

# Access global temp view
spark.sql("SELECT * FROM global_temp.global_employees").show()

# Check if view exists
spark.catalog.tableExists("employees")
```

### Running SQL Queries
```python
# Simple query
result = spark.sql("SELECT * FROM employees WHERE age > 30")
result.show()

# With aliases and aggregations
result = spark.sql("""
    SELECT 
        dept,
        COUNT(*) as emp_count,
        AVG(salary) as avg_salary,
        MAX(salary) as max_salary
    FROM employees
    WHERE age > 25
    GROUP BY dept
    HAVING COUNT(*) > 5
    ORDER BY avg_salary DESC
""")

# Multi-line query (alternative formatting)
query = """
    SELECT 
        e.name,
        e.dept,
        d.dept_name
    FROM employees e
    JOIN departments d ON e.dept = d.dept_id
    WHERE e.salary > 50000
"""
result = spark.sql(query)

# Parameterized queries (avoid SQL injection)
age_threshold = 30
result = spark.sql(f"SELECT * FROM employees WHERE age > {age_threshold}")

# Using temp views in combination
df1.createOrReplaceTempView("sales")
df2.createOrReplaceTempView("products")

result = spark.sql("""
    SELECT 
        s.order_id,
        p.product_name,
        s.quantity * p.price as total
    FROM sales s
    JOIN products p ON s.product_id = p.id
""")
```

### Catalog Operations
```python
# List databases
spark.catalog.listDatabases()

# List tables
spark.catalog.listTables()
spark.catalog.listTables("database_name")

# List columns
spark.catalog.listColumns("table_name")

# List functions
spark.catalog.listFunctions()

# Set current database
spark.catalog.setCurrentDatabase("my_db")

# Get current database
spark.catalog.currentDatabase()

# Cache table
spark.catalog.cacheTable("employees")
spark.catalog.uncacheTable("employees")

# Drop temp view
spark.catalog.dropTempView("employees")
spark.catalog.dropGlobalTempView("global_employees")
```

---

## Data Writing

### Write to Files

#### Parquet (Recommended for Big Data)
```python
# Basic write
df.write \
    .format("parquet") \
    .mode("overwrite") \
    .save("/path/to/output")

# With partitioning
df.write \
    .format("parquet") \
    .mode("overwrite") \
    .partitionBy("year", "month") \              # Creates year=2023/month=01/
    .save("/path/to/output")

# With options
df.write \
    .format("parquet") \
    .mode("append") \
    .option("compression", "snappy") \           # gzip, snappy, lzo, none
    .option("maxRecordsPerFile", 100000) \       # Split large files
    .partitionBy("dept") \
    .save("/path/to/output")

# Shorthand
df.write.parquet("/path/to/output", mode="overwrite")
```

**Write Modes:**
- **overwrite**: Replace existing data
- **append**: Add to existing data
- **ignore**: Write only if path doesn't exist
- **error/errorifexists** (default): Throw error if exists

#### CSV
```python
df.write \
    .format("csv") \
    .mode("overwrite") \
    .option("header", "true") \
    .option("compression", "gzip") \
    .save("/path/to/output")
```

#### JSON
```python
df.write \
    .format("json") \
    .mode("overwrite") \
    .option("compression", "gzip") \
    .partitionBy("category") \
    .save("/path/to/output")
```

#### Avro
```python
df.write \
    .format("avro") \
    .mode("overwrite") \
    .save("/path/to/output")
```

### Write to Database (JDBC)
```python
df.write \
    .format("jdbc") \
    .mode("append") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("dbtable", "public.employees") \
    .option("user", "username") \
    .option("password", "password") \
    .option("driver", "org.postgresql.Driver") \
    .option("batchsize", "1000") \               # Rows per batch
    .option("isolationLevel", "READ_COMMITTED") \
    .save()

# Truncate and insert
df.write \
    .format("jdbc") \
    .mode("overwrite") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("dbtable", "public.employees") \
    .option("user", "username") \
    .option("password", "password") \
    .option("truncate", "true") \                # Truncate before insert
    .save()
```

### Write to Hive Tables
```python
# Managed table (Spark manages data and metadata)
df.write \
    .mode("overwrite") \
    .saveAsTable("database.table_name")

# External table (Spark manages only metadata)
df.write \
    .mode("overwrite") \
    .option("path", "/user/hive/warehouse/table_data") \
    .saveAsTable("database.table_name")

# Partitioned table
df.write \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .saveAsTable("database.sales")

# Bucketed table (for optimized joins)
df.write \
    .mode("overwrite") \
    .bucketBy(10, "customer_id") \               # 10 buckets by customer_id
    .sortBy("order_date") \                      # Sort within buckets
    .saveAsTable("database.orders")

# Partitioned + Bucketed
df.write \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .bucketBy(10, "customer_id") \
    .sortBy("order_date") \
    .saveAsTable("database.orders")

# Insert into existing table
df.write \
    .mode("append") \
    .insertInto("database.existing_table")

# Insert overwrite partition
df.write \
    .mode("overwrite") \
    .insertInto("database.sales", overwrite=True)
```

**💡 Interview Question:** When to use partitioning vs bucketing?
- **Partitioning**: For columns with low cardinality (year, month, country) - creates directories
- **Bucketing**: For high cardinality (user_id) - optimizes joins, distributes data evenly

### Advanced Write Options

#### Control File Size
```python
# Limit records per file
df.write \
    .option("maxRecordsPerFile", 10000) \
    .parquet("/path")

# Repartition before writing
df.repartition(10).write.parquet("/path")     # Creates 10 files

# Coalesce to single file
df.coalesce(1).write.parquet("/path")         # Creates 1 file
```

#### Compression
```python
# Available compression: none, gzip, snappy, lzo, bzip2
df.write \
    .option("compression", "snappy") \         # Fast, good compression
    .parquet("/path")
```

---

## Aggregations & Grouping

### Basic Aggregations

```python
from pyspark.sql.functions import *

# Single aggregations
df.select(count("*").alias("total_count")).show()
df.select(sum("salary").alias("total_salary")).show()
df.select(avg("age").alias("avg_age")).show()
df.select(min("age"), max("age")).show()

# Multiple aggregations
df.select(
    count("*").alias("count"),
    sum("salary").alias("total_salary"),
    avg("salary").alias("avg_salary"),
    min("salary").alias("min_salary"),
    max("salary").alias("max_salary"),
    countDistinct("dept").alias("unique_depts")
).show()

# Using agg()
df.agg(
    count("*").alias("count"),
    sum("salary").alias("total_salary")
).show()

# Using selectExpr (SQL-style)
df.selectExpr(
    "count(*) as count",
    "sum(salary) as total_salary",
    "avg(salary) as avg_salary",
    "round(avg(salary), 2) as avg_salary_rounded"
).show()
```

### GroupBy Aggregations

```python
# Simple groupBy
df.groupBy("dept").count().show()

# Multiple aggregations
df.groupBy("dept").agg(
    count("*").alias("emp_count"),
    sum("salary").alias("total_salary"),
    avg("salary").alias("avg_salary"),
    max("salary").alias("max_salary")
).show()

# Multiple group columns
df.groupBy("dept", "location").agg(
    count("*").alias("count"),
    avg("salary").alias("avg_salary")
).show()

# Using expr in aggregations
df.groupBy("country").agg(
    count("*").alias("count"),
    expr("round(sum(quantity * price), 2) as total_value")
).show()

# Alternative with selectExpr
df.createOrReplaceTempView("sales")
spark.sql("""
    SELECT 
        country,
        COUNT(*) as count,
        ROUND(SUM(quantity * price), 2) as total_value
    FROM sales
    GROUP BY country
""").show()
```

### Advanced Aggregations

```python
# Collect values into array
df.groupBy("dept").agg(
    collect_list("name").alias("employees"),      # With duplicates
    collect_set("location").alias("locations")    # Unique values only
).show()

# First/Last values
df.groupBy("dept").agg(
    first("name").alias("first_employee"),
    last("name").alias("last_employee")
).show()

# Conditional aggregations
df.groupBy("dept").agg(
    sum(when(col("age") > 30, col("salary")).otherwise(0)).alias("senior_salary_total"),
    count(when(col("age") > 30, True)).alias("senior_count")
).show()

# Percentile
df.groupBy("dept").agg(
    expr("percentile_approx(salary, 0.5)").alias("median_salary")
).show()

# Variance and Standard Deviation
df.groupBy("dept").agg(
    variance("salary").alias("salary_variance"),
    stddev("salary").alias("salary_stddev")
).show()
```

### Pivot (Convert rows to columns)

```python
# Basic pivot
df.groupBy("year") \
    .pivot("quarter") \
    .sum("revenue") \
    .show()

# With specific pivot values (better performance)
df.groupBy("year") \
    .pivot("quarter", ["Q1", "Q2", "Q3", "Q4"]) \
    .sum("revenue") \
    .show()

# Multiple aggregations
df.groupBy("year") \
    .pivot("quarter") \
    .agg(
        sum("revenue").alias("total_revenue"),
        avg("revenue").alias("avg_revenue")
    ) \
    .show()
```

### Rollup and Cube (Multi-level aggregations)

```python
# Rollup - Hierarchical aggregations
df.rollup("country", "city").agg(
    sum("sales").alias("total_sales")
).show()
# Produces: (country, city), (country, null), (null, null)

# Cube - All combinations
df.cube("country", "product").agg(
    sum("sales").alias("total_sales")
).show()
# Produces: (country, product), (country, null), (null, product), (null, null)

# Grouping ID to identify aggregation level
df.cube("country", "product").agg(
    sum("sales").alias("total_sales"),
    grouping_id().alias("grouping_level")
).show()
```

---

## Window Functions

Window functions perform calculations across a set of rows related to the current row.

### Basic Window Functions

```python
from pyspark.sql.window import Window
from pyspark.sql.functions import *

# Define window
window = Window.partitionBy("dept").orderBy("salary")

# Row number
df.withColumn("row_num", row_number().over(window)).show()

# Rank (leaves gaps)
df.withColumn("rank", rank().over(window)).show()

# Dense rank (no gaps)
df.withColumn("dense_rank", dense_rank().over(window)).show()

# Percent rank
df.withColumn("percent_rank", percent_rank().over(window)).show()

# Ntile (distribute into N buckets)
df.withColumn("quartile", ntile(4).over(window)).show()
```

### Aggregation Window Functions

```python
# Running total
window = Window.partitionBy("dept").orderBy("date").rowsBetween(Window.unboundedPreceding, Window.currentRow)

df.withColumn("running_total", sum("amount").over(window)).show()

# Running average
df.withColumn("running_avg", avg("amount").over(window)).show()

# Cumulative count
df.withColumn("cumulative_count", count("*").over(window)).show()

# Total by partition (no ORDER BY needed)
window = Window.partitionBy("dept")
df.withColumn("dept_total", sum("salary").over(window)).show()

# Percentage of total
df.withColumn("pct_of_dept", 
    (col("salary") / sum("salary").over(window)) * 100
).show()
```

### Lead and Lag

```python
window = Window.partitionBy("customer_id").orderBy("order_date")

# Previous value
df.withColumn("prev_amount", lag("amount", 1).over(window)).show()

# Next value
df.withColumn("next_amount", lead("amount", 1).over(window)).show()

# With default value for nulls
df.withColumn("prev_amount", lag("amount", 1, 0).over(window)).show()

# Difference from previous
df.withColumn("prev_amount", lag("amount", 1).over(window)) \
    .withColumn("diff", col("amount") - col("prev_amount")) \
    .show()
```

### Moving Averages

```python
# 3-row moving average (current + 2 previous)
window = Window.partitionBy("product_id") \
    .orderBy("date") \
    .rowsBetween(-2, 0)

df.withColumn("moving_avg_3", avg("sales").over(window)).show()

# 7-day moving average
window = Window.partitionBy("product_id") \
    .orderBy("date") \
    .rangeBetween(-6, 0)  # Range-based for dates

df.withColumn("moving_avg_7day", avg("sales").over(window)).show()
```

### Advanced Window Patterns

```python
# First and last values in window
window = Window.partitionBy("dept").orderBy("salary")

df.withColumn("first_salary", first("salary").over(window)) \
    .withColumn("last_salary", last("salary").over(window)) \
    .show()

# Window with unbounded following
window = Window.partitionBy("dept") \
    .orderBy("date") \
    .rowsBetween(Window.currentRow, Window.unboundedFollowing)

df.withColumn("remaining_sum", sum("amount").over(window)).show()

# Find top N per group
window = Window.partitionBy("country").orderBy(col("sales").desc())

top_products = df.withColumn("rank", rank().over(window)) \
    .where(col("rank") <= 3) \
    .drop("rank")
```

**💡 Interview Question:** rowsBetween vs rangeBetween?
- **rowsBetween**: Counts rows (physical boundaries)
- **rangeBetween**: Based on value range (logical boundaries, useful for dates)

---

## Joins & Optimization

### Join Types

```python
# Sample dataframes
orders = spark.createDataFrame([
    (1, "A", 100),
    (2, "B", 200),
    (3, "C", 150)
], ["order_id", "product_id", "amount"])

products = spark.createDataFrame([
    ("A", "Widget", 10),
    ("B", "Gadget", 20),
    ("D", "Tool", 15)
], ["product_id", "product_name", "price"])

# Inner join (default)
join_expr = orders.product_id == products.product_id

result = orders.join(products, join_expr, "inner")
result.show()

# Alternative join conditions
result = orders.join(products, "product_id", "inner")  # Single column
result = orders.join(products, ["product_id"], "inner")  # List of columns
```

### Join Types Examples

```python
# Inner join
orders.join(products, join_expr, "inner").show()

# Left (outer) join
orders.join(products, join_expr, "left").show()
orders.join(products, join_expr, "left_outer").show()

# Right (outer) join
orders.join(products, join_expr, "right").show()

# Full outer join
orders.join(products, join_expr, "outer").show()
orders.join(products, join_expr, "full_outer").show()

# Left semi join (like IN clause - returns left table rows)
orders.join(products, join_expr, "left_semi").show()

# Left anti join (like NOT IN - returns unmatched left rows)
orders.join(products, join_expr, "left_anti").show()

# Cross join (Cartesian product)
orders.crossJoin(products).show()
```

### Handling Duplicate Columns After Join

```python
# Problem: Both dataframes have 'product_id'
result = orders.join(products, join_expr, "inner")
# result.select("product_id")  # ERROR: Ambiguous reference

# Solution 1: Drop duplicate column
result = orders.join(products, join_expr, "inner") \
    .drop(products.product_id)

# Solution 2: Rename before join
products_renamed = products.withColumnRenamed("product_id", "prod_id")
result = orders.join(products_renamed, 
    orders.product_id == products_renamed.prod_id, "inner")

# Solution 3: Use column with dataframe prefix
result = orders.join(products, join_expr, "inner") \
    .select(orders.product_id, products.product_name, orders.amount)

# Solution 4: Join on column name (auto-handles duplicates)
result = orders.join(products, "product_id", "inner")
# No duplicate product_id in result
```

### Broadcast Join (Small to Large)

```python
from pyspark.sql.functions import broadcast

# Hint Spark to broadcast small table
large_df.join(broadcast(small_df), "key", "inner").show()

# Check broadcast join threshold
spark.conf.get("spark.sql.autoBroadcastJoinThreshold")  # Default: 10MB

# Disable auto-broadcast
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", -1)

# Enable auto-broadcast with custom threshold
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "50m")  # 50MB
```

**💡 Interview Question:** When is broadcast join used?
- When one table is small enough to fit in memory of each executor
- Avoids shuffle (no exchange) - significant performance gain
- Automatically used if table < 10MB (default threshold)

### Bucketed Joins (Large to Large)

```python
# Write tables with bucketing
df1.write \
    .bucketBy(10, "customer_id") \
    .sortBy("order_date") \
    .mode("overwrite") \
    .saveAsTable("orders")

df2.write \
    .bucketBy(10, "customer_id") \
    .sortBy("customer_id") \
    .mode("overwrite") \
    .saveAsTable("customers")

# Join bucketed tables (no shuffle!)
orders = spark.table("orders")
customers = spark.table("customers")

result = orders.join(customers, "customer_id", "inner")
# Spark uses bucket join - no shuffle exchange
```

**💡 Interview Tip:** Bucketing pre-distributes data, eliminating shuffle in joins

### Join Optimization Strategies

```python
# 1. Filter before join (predicate pushdown)
# Bad
df1.join(df2, "id").where(col("status") == "active")

# Good
df1.where(col("status") == "active").join(df2, "id")

# 2. Select only needed columns before join
# Bad
df1.join(df2, "id")

# Good
df1.select("id", "name").join(df2.select("id", "category"), "id")

# 3. Use appropriate join type
# If you only need rows from left table that match
df1.join(df2, "id", "left_semi")  # Instead of inner join + select

# 4. Broadcast small tables
df1.join(broadcast(df2), "id")

# 5. Repartition on join key before join
df1.repartition("id").join(df2.repartition("id"), "id")

# 6. Use bucketing for repeated joins
# Write once with buckets, join multiple times without shuffle
```

### Shuffle Join Configuration

```python
# Number of partitions for shuffle operations
spark.conf.set("spark.sql.shuffle.partitions", "200")  # Default

# For small datasets
spark.conf.set("spark.sql.shuffle.partitions", "10")

# For large datasets
spark.conf.set("spark.sql.shuffle.partitions", "500")

# Adaptive Query Execution (auto-optimizes partitions)
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
```

**💡 Formula for shuffle partitions:**
- General rule: 2-4 partitions per CPU core
- Each partition should be 100MB - 200MB after shuffle

---

## UDFs & Custom Functions

### DataFrame UDFs

```python
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType, IntegerType
import re

# Define Python function
def categorize_age(age):
    if age < 18:
        return "Minor"
    elif age < 65:
        return "Adult"
    else:
        return "Senior"

# Register as DataFrame UDF
categorize_age_udf = udf(categorize_age, StringType())

# Use in DataFrame
df = df.withColumn("age_category", categorize_age_udf(col("age")))

# Alternative: Decorator syntax
@udf(returnType=StringType())
def categorize_age(age):
    if age < 18:
        return "Minor"
    elif age < 65:
        return "Adult"
    else:
        return "Senior"

df = df.withColumn("age_category", categorize_age(col("age")))
```

### SQL UDFs (Registered in Catalog)

```python
# Register UDF for SQL use
spark.udf.register("categorize_age_udf", categorize_age, StringType())

# Use in SQL
df.createOrReplaceTempView("people")
result = spark.sql("""
    SELECT 
        name,
        age,
        categorize_age_udf(age) as age_category
    FROM people
""")

# Or use in DataFrame with expr
df = df.withColumn("age_category", expr("categorize_age_udf(age)"))
```

### Complex UDF Examples

```python
# UDF with multiple parameters
def calculate_tax(salary, tax_rate):
    return salary * tax_rate

calculate_tax_udf = udf(calculate_tax, DoubleType())

df = df.withColumn("tax", calculate_tax_udf(col("salary"), lit(0.25)))

# UDF returning complex types
from pyspark.sql.types import StructType, StructField

# Return struct
address_schema = StructType([
    StructField("street", StringType()),
    StructField("city", StringType())
])

def parse_address(address_str):
    parts = address_str.split(",")
    return (parts[0].strip(), parts[1].strip())

parse_address_udf = udf(parse_address, address_schema)

df = df.withColumn("parsed_address", parse_address_udf(col("address")))

# Return array
from pyspark.sql.types import ArrayType

def get_initials(name):
    return [word[0].upper() for word in name.split()]

get_initials_udf = udf(get_initials, ArrayType(StringType()))

df = df.withColumn("initials", get_initials_udf(col("name")))
```

### Pandas UDFs (Vectorized - Much Faster!)

```python
from pyspark.sql.functions import pandas_udf
import pandas as pd

# Pandas UDF for scalar operations
@pandas_udf(StringType())
def categorize_age_pandas(ages: pd.Series) -> pd.Series:
    def categorize(age):
        if age < 18:
            return "Minor"
        elif age < 65:
            return "Adult"
        else:
            return "Senior"
    return ages.apply(categorize)

df = df.withColumn("age_category", categorize_age_pandas(col("age")))

# Pandas UDF for grouped operations
@pandas_udf(DoubleType())
def calculate_z_score(values: pd.Series) -> pd.Series:
    return (values - values.mean()) / values.std()

# Use with groupBy
df.groupBy("dept").agg(
    calculate_z_score(col("salary")).alias("salary_z_score")
).show()
```

**💡 Interview Question:** Regular UDF vs Pandas UDF?
- **Regular UDF**: Row-by-row, Python → JVM overhead, slow
- **Pandas UDF**: Vectorized (batch processing), uses Apache Arrow, 10-100x faster

### When to Use UDFs

```python
# ✅ Good use case: Complex logic not available in Spark
def complex_business_logic(value):
    # Complex calculation
    return result

# ❌ Bad use case: Simple operations (use built-in functions)
# Don't do this
def double_value(x):
    return x * 2

double_udf = udf(double_value, IntegerType())
df.withColumn("doubled", double_udf(col("value")))

# Do this instead
df.withColumn("doubled", col("value") * 2)

# ✅ Good: Use when() instead of UDF for conditionals
df.withColumn("category",
    when(col("age") < 18, "Minor")
    .when(col("age") < 65, "Adult")
    .otherwise("Senior")
)
```

**💡 Best Practice:** Avoid UDFs when possible - use built-in functions for better performance

---

## Performance Optimization

### 1. Partitioning

```python
# Check current partitions
df.rdd.getNumPartitions()

# Repartition (with shuffle)
df = df.repartition(100)                      # 100 partitions
df = df.repartition(100, "customer_id")       # Hash partition by column

# Coalesce (without shuffle - only reduce)
df = df.coalesce(10)

# Rule of thumb for partitions
# Each partition should be 100-200 MB
num_partitions = total_data_size_mb / 128
```

### 2. Caching/Persistence

```python
# Cache in memory
df.cache()
df.persist()  # Same as cache()

# Different storage levels
from pyspark import StorageLevel

df.persist(StorageLevel.MEMORY_ONLY)          # Default
df.persist(StorageLevel.MEMORY_AND_DISK)      # Spill to disk if needed
df.persist(StorageLevel.DISK_ONLY)            # Only disk
df.persist(StorageLevel.MEMORY_ONLY_SER)      # Serialized in memory
df.persist(StorageLevel.OFF_HEAP)             # Off-heap memory

# Unpersist
df.unpersist()

# When to cache:
# ✅ DataFrame used multiple times
# ✅ Expensive computations
# ✅ Iterative algorithms
# ❌ DataFrame used only once
# ❌ Very large datasets that don't fit in memory
```

**Example:**
```python
# Without cache - reads data twice
expensive_df = spark.read.parquet("large_file.parquet") \
    .filter(col("status") == "active") \
    .groupBy("dept").agg(sum("amount"))

result1 = expensive_df.where(col("dept") == "IT").count()
result2 = expensive_df.where(col("dept") == "HR").count()
# Data is read and processed twice!

# With cache - reads once
expensive_df = spark.read.parquet("large_file.parquet") \
    .filter(col("status") == "active") \
    .groupBy("dept").agg(sum("amount")) \
    .cache()  # Cache here

result1 = expensive_df.where(col("dept") == "IT").count()  # Reads from cache
result2 = expensive_df.where(col("dept") == "HR").count()  # Reads from cache
```

### 3. Broadcast Variables

```python
from pyspark.sql.functions import broadcast

# Broadcast small lookup table
small_df.cache()  # Cache small table
result = large_df.join(broadcast(small_df), "key")

# Broadcast threshold
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "10m")  # 10MB
```

### 4. Adaptive Query Execution (AQE)

```python
# Enable AQE (Spark 3.0+)
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
spark.conf.set("spark.sql.adaptive.skewJoin.enabled", "true")

# AQE benefits:
# - Dynamically coalesces shuffle partitions
# - Converts sort-merge join to broadcast join
# - Optimizes skewed joins
```

### 5. Predicate Pushdown

```python
# ✅ Good - Filter pushed to data source
df = spark.read.parquet("data.parquet") \
    .where(col("year") == 2023)  # Only reads 2023 data

# ❌ Bad - Reads all data then filters
df = spark.read.parquet("data.parquet")
df = df.where(col("year") == 2023)  # Reads everything first
```

### 6. Column Pruning

```python
# ✅ Good - Select only needed columns
df = spark.read.parquet("data.parquet") \
    .select("id", "name", "amount")

# ❌ Bad - Reads all columns
df = spark.read.parquet("data.parquet")  # Reads all columns
df = df.select("id", "name", "amount")
```

### 7. File Format Optimization

```python
# Parquet/ORC - Columnar, compressed, schema embedded
# Best for analytical queries
df.write.parquet("output.parquet")

# Avro - Row-based, good for write-heavy
df.write.format("avro").save("output.avro")

# Delta Lake - ACID transactions, time travel
df.write.format("delta").save("output.delta")
```

### 8. Data Skew Handling

```python
# Problem: Some partitions much larger than others

# Solution 1: Salt the join key
from pyspark.sql.functions import concat, lit, rand

df1 = df1.withColumn("salt", (rand() * 10).cast("int"))
df1 = df1.withColumn("salted_key", concat(col("key"), lit("_"), col("salt")))

df2 = df2.withColumn("salt", explode(array([lit(i) for i in range(10)])))
df2 = df2.withColumn("salted_key", concat(col("key"), lit("_"), col("salt")))

result = df1.join(df2, "salted_key")

# Solution 2: Use AQE skew join optimization
spark.conf.set("spark.sql.adaptive.skewJoin.enabled", "true")
```

### 9. Avoid Shuffles

```python
# ✅ Good - No shuffle
df.select("col1", "col2").show()
df.filter(col("status") == "active").show()

# ⚠️ Triggers shuffle
df.groupBy("dept").count().show()
df.repartition(100).show()
df.join(df2, "key").show()
df.distinct().show()

# Minimize shuffles:
# - Filter before groupBy/join
# - Use broadcast for small tables
# - Pre-partition/bucket data
```

### 10. Tungsten Execution Engine

```python
# Whole-stage code generation (automatic in Spark 2.0+)
# Compiles queries to optimized JVM bytecode

# Check if enabled
spark.conf.get("spark.sql.codegen.wholeStage")  # Should be "true"

# Benefits:
# - Removes virtual function calls
# - Operates on serialized data
# - Better CPU cache locality
```

---

## Common Interview Questions

### Q1: Explain Spark architecture
**Answer:**
- **Driver**: Runs main(), creates SparkContext, converts code to DAG, schedules tasks
- **Cluster Manager**: Allocates resources (YARN/Mesos/K8s/Standalone)
- **Executors**: Run tasks, store data, report back to driver
- **Execution flow**: Driver → DAG → Stages → Tasks → Executors

### Q2: Transformations vs Actions
**Answer:**
- **Transformations**: Lazy, create new RDD/DataFrame (map, filter, groupBy)
- **Actions**: Eager, trigger execution, return results (show, count, collect)
- Spark builds DAG of transformations, optimizes, executes on action

### Q3: Narrow vs Wide Transformations
**Answer:**
- **Narrow**: No shuffle, single partition (filter, map, select)
- **Wide**: Requires shuffle across partitions (groupBy, join, distinct)
- Wide transformations create stage boundaries

### Q4: How to optimize Spark joins?
**Answer:**
1. Broadcast small tables (< 10MB)
2. Filter before join
3. Select only needed columns
4. Use bucketing for repeated large-to-large joins
5. Repartition on join key
6. Enable AQE for dynamic optimization

### Q5: repartition() vs coalesce()
**Answer:**
- **repartition()**: Full shuffle, can increase/decrease partitions
- **coalesce()**: No shuffle, only decrease partitions, faster
- Use repartition for increase, coalesce for decrease

### Q6: How does Catalyst Optimizer work?
**Answer:**
1. **Analysis**: Resolve column names, check types
2. **Logical Optimization**: Predicate pushdown, constant folding, projection pruning
3. **Physical Planning**: Generate execution plans, choose best
4. **Code Generation**: Generate JVM bytecode (Tungsten)

### Q7: What is lazy evaluation and why?
**Answer:**
- Operations aren't executed immediately
- Spark builds execution plan, optimizes entire pipeline
- Benefits: Optimization, reduce unnecessary work, pipelining

### Q8: How to handle skewed data?
**Answer:**
1. Salt join keys to distribute evenly
2. Use AQE skew join optimization
3. Broadcast small skewed table
4. Repartition with appropriate key
5. Custom partitioning logic

### Q9: When to use cache()?
**Answer:**
- DataFrame used multiple times
- After expensive operations (joins, aggregations)
- Iterative algorithms (ML)
- Don't cache if used once or too large for memory

### Q10: Managed vs External tables
**Answer:**
- **Managed**: Spark manages data + metadata, DROP deletes both
- **External**: Spark manages only metadata, DROP keeps data
- Use external for shared data, managed for Spark-only

### Q11: Explain Adaptive Query Execution (AQE)
**Answer:**
- Runtime optimization based on statistics
- Dynamically coalesces partitions
- Converts joins (e.g., sort-merge to broadcast)
- Handles skewed joins automatically
- Enable: `spark.sql.adaptive.enabled=true`

### Q12: What are accumulators and broadcast variables?
**Answer:**
- **Accumulators**: Shared variables for aggregating (counters, sums)
- **Broadcast**: Read-only variables distributed to all nodes
- Use broadcast for lookup tables in joins

---

## Interview Coding Exercises

### 1. Find Duplicate Records

```python
from pyspark.sql.functions import col, count, collect_list, row_number
from pyspark.sql.window import Window

# Method 1: groupBy + count, then filter and join back to get full rows
dupe_keys = df.groupBy("name", "email").agg(count("*").alias("count")).filter(col("count") > 1)
duplicate_rows = df.join(dupe_keys.select("name", "email"), on=["name", "email"], how="inner")

# Method 2: window function - flag every row after the first as a duplicate
window = Window.partitionBy("name", "email").orderBy("id")
df_flagged = df.withColumn("row_num", row_number().over(window))
duplicates = df_flagged.filter(col("row_num") > 1)
df_deduped = df_flagged.filter(col("row_num") == 1).drop("row_num")

# Method 3: simplest - just drop them
df_deduped = df.dropDuplicates(["name", "email"])

# Method 4: see which IDs make up each duplicate group
duplicate_details = df.groupBy("name", "email") \
    .agg(count("*").alias("count"), collect_list("id").alias("duplicate_ids")) \
    .filter(col("count") > 1)
```

### 2. Parse Nested JSON

```python
from pyspark.sql.functions import col, explode, explode_outer, from_json
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

# Schema: address is a struct, phones is an array of strings
# root
#  |-- address: struct (city, street, zipcode)
#  |-- phones: array<string>

# Extract struct fields - dot notation (preferred) or getField()
df_flat = df.select(
    "id", "name",
    col("address.street").alias("street"),
    col("address.city").alias("city"),
    col("address").getField("zipcode").alias("zipcode"),
)

# Explode an array column into one row per element
df_exploded = df.select("id", "name", explode("phones").alias("phone"))
df_exploded_outer = df.select("id", "name", explode_outer("phones").alias("phone"))  # keeps rows with null/empty arrays

# Array of structs: explode the array, then pull fields off the resulting struct
df_orders = df.select("user_id", "name", explode("orders").alias("order"))
df_items = df_orders.select(
    "user_id", "name",
    col("order.order_id").alias("order_id"),
    explode("order.items").alias("item"),
).select("user_id", "name", "order_id", col("item.product").alias("product"), col("item.price").alias("price"))

# Deeply nested fields - just chain dot notation
df.select(col("level1.level2.level3.level4.value").alias("extracted_value"))

# Parse a JSON string stored in a column (not yet a struct)
json_schema = StructType([StructField("name", StringType()), StructField("age", IntegerType())])
df_parsed = df.withColumn("parsed", from_json(col("json_string"), json_schema))
df_final = df_parsed.select("id", col("parsed.name").alias("name"), col("parsed.age").alias("age"))
```

### 3. Handle Skewed Data in Joins

In addition to salting and AQE (see [Performance Optimization → Data Skew Handling](#8-data-skew-handling)):

```python
# Skew join hint (Spark 3.0+) - lets the optimizer handle a known-skewed table
result = spark.sql("""
    SELECT /*+ SKEW('left_table') */ *
    FROM left_table
    JOIN right_table ON left_table.id = right_table.id
""")

# Split skewed keys out, salt only those, union back with the regular join
skewed_keys = df_left.groupBy("id").count().filter(col("count") > 1000).select("id")

left_skewed = df_left.join(skewed_keys, "id", "inner")
left_normal = df_left.join(skewed_keys, "id", "left_anti")
right_skewed = df_right.join(skewed_keys, "id", "inner")
right_normal = df_right.join(skewed_keys, "id", "left_anti")

result_normal = left_normal.join(right_normal, "id")
# result_skewed = ... salt left_skewed/right_skewed as shown above, then join ...
final_result = result_normal.union(result_skewed)
```

**💡 Tip:** Running totals (window functions), optimizing a slow job (caching, broadcast joins, partition pruning, filter-early), and basic skew handling (salting, AQE) are covered in depth in [Window Functions](#window-functions) and [Performance Optimization](#performance-optimization) above.

---

## Best Practices

### 1. Schema Management
```python
# ✅ Always define schema explicitly (don't infer)
schema = StructType([...])
df = spark.read.schema(schema).csv("file.csv")

# ❌ Avoid inferring (slow + unreliable)
df = spark.read.option("inferSchema", "true").csv("file.csv")
```

### 2. DataFrame Operations
```python
# ✅ Use built-in functions over UDFs
df.withColumn("doubled", col("value") * 2)

# ❌ Avoid UDFs for simple operations
double_udf = udf(lambda x: x * 2, IntegerType())
df.withColumn("doubled", double_udf(col("value")))

# ✅ Use column objects for complex expressions
df.filter((col("age") > 30) & (col("salary") > 50000))

# ✅ Chain operations efficiently
df = df.filter(...).select(...).groupBy(...).agg(...)
```

### 3. Data Writing
```python
# ✅ Use Parquet for analytics
df.write.parquet("output.parquet")

# ✅ Partition by low-cardinality columns
df.write.partitionBy("year", "month").parquet("output")

# ✅ Control file size
df.repartition(10).write.parquet("output")  # 10 files

# ✅ Use compression
df.write.option("compression", "snappy").parquet("output")
```

### 4. Performance
```python
# ✅ Cache strategically
expensive_df.cache()

# ✅ Filter early
df.where(...).groupBy(...).agg(...)  # Filter before groupBy

# ✅ Broadcast small tables
large.join(broadcast(small), "key")

# ✅ Use appropriate file formats
# Parquet/ORC for analytics
# Avro for row-based operations
```

### 5. Resource Management
```python
# ✅ Set appropriate shuffle partitions
spark.conf.set("spark.sql.shuffle.partitions", "200")

# ✅ Use dynamic allocation
spark.conf.set("spark.dynamicAllocation.enabled", "true")

# ✅ Monitor memory
spark.conf.set("spark.executor.memory", "4g")
spark.conf.set("spark.driver.memory", "2g")
```

### 6. Code Organization
```python
# ✅ Use config files for settings
# ✅ Create reusable functions
# ✅ Use meaningful variable names
# ✅ Add comments for complex logic
# ✅ Use logging instead of print()

import logging
logger = logging.getLogger(__name__)
logger.info("Processing started")
```

### 7. Error Handling
```python
# ✅ Use try-except for robustness
try:
    df = spark.read.parquet("file.parquet")
except Exception as e:
    logger.error(f"Failed to read file: {e}")
    # Handle error

# ✅ Validate data
assert df.count() > 0, "DataFrame is empty"
assert "id" in df.columns, "Missing required column"
```

### 8. Testing
```python
# ✅ Test with sample data
sample_df = df.sample(0.01)  # 1% sample

# ✅ Use .explain() to understand execution
df.explain(True)

# ✅ Monitor via Spark UI
# http://localhost:4040
```

---

## Additional Resources

### Useful Spark Configurations
```python
# View all configurations
spark.sparkContext.getConf().getAll()

# Common tuning parameters
spark.conf.set("spark.sql.shuffle.partitions", "200")
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "10m")
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
spark.conf.set("spark.default.parallelism", "100")
```

### Debugging Tips
```python
# View execution plan
df.explain()
df.explain(True)  # Extended
df.explain("formatted")
df.explain("cost")

# View physical plan
df.queryExecution.executedPlan

# View logical plan
df.queryExecution.logical

# Check lineage
df.rdd.toDebugString()

# Monitor via Spark UI: http://localhost:4040
```

### Common Errors and Solutions
```python
# OutOfMemoryError
# → Increase executor memory, reduce data size, cache less

# Too many small files
# → Coalesce before writing, use maxRecordsPerFile

# Slow shuffles
# → Reduce shuffle partitions, optimize joins, use broadcast

# Executor failures
# → Increase memory, handle skewed data, check for bad data
```

---

## Quick Reference Card

### Must-Know Functions
```python
# Column operations
col(), expr(), lit(), when(), coalesce()

# Aggregations
count(), sum(), avg(), min(), max(), countDistinct()
collect_list(), collect_set(), first(), last()

# String functions
concat(), substring(), split(), regexp_extract(), trim()
upper(), lower(), length()

# Date functions
to_date(), to_timestamp(), date_format(), year(), month(), day()
datediff(), date_add(), date_sub()

# Window functions
row_number(), rank(), dense_rank(), lag(), lead()
sum().over(), avg().over()

# Array functions
explode(), array_contains(), size(), sort_array()
```

### Performance Checklist
- [ ] Schema defined explicitly
- [ ] Filter before groupBy/join
- [ ] Select only needed columns
- [ ] Broadcast small tables
- [ ] Use appropriate file format
- [ ] Set shuffle partitions correctly
- [ ] Cache reused DataFrames
- [ ] Avoid UDFs when possible
- [ ] Monitor via Spark UI
- [ ] Enable AQE

---

**Good luck with your interview! 🚀**