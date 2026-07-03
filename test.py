#!/Users/krishnathejaupadhyaya/opt/anaconda3/envs/PySpark3/bin/python

from pyspark.sql import SparkSession
from pyspark.sql.functions import expr
import pandas as pd

if __name__ == "__main__":
    spark1 = SparkSession.builder \
                .master("local[3]") \
                .appName("TestSparkSQL1") \
                .getOrCreate()
    file2 = '/Users/krishnathejaupadhyaya/Desktop/Learn/Lab/Spark_udemy_1/Fire_Department_Calls_for_Service.csv'

    file_df = spark1.read\
                .format("csv") \
                .option("header", "true") \
                .option("path", file2) \
                .load()

    # print(file_df.columns)
    new_cols = [c.replace(" ", "_") for c in file_df.columns]
    print(new_cols)
    # file_df = file_df.toDF(*new_cols)
    print(*new_cols)
    # print(file_df.columns)