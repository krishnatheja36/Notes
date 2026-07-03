# System Design Solutions for Data Engineering Interviews

## Table of Contents
1. Design ETL Pipeline for TurboTax Data
2. Real-time Fraud Detection System
3. Data Warehouse for Financial Reporting
4. Streaming Pipeline with Kafka + Spark
5. Data Quality Validation Framework


## 1. Design ETL Pipeline for TurboTax Data
Problem Statement
Design a scalable ETL pipeline to process millions of tax returns during tax season (peak load), ensuring data security, compliance, and high availability.
Requirements

Handle 10M+ tax returns during peak season (Jan-April)
10x spike during last week before deadline
PII data security and encryption
Audit trail for compliance (IRS requirements)
99.9% uptime during tax season
Data retention: 7 years
Support various data sources (web, mobile, API)

High-Level Architecture
┌─────────────────────────────────────────────────────────────────┐
│                        Data Sources                              │
├─────────────┬──────────────┬──────────────┬─────────────────────┤
│  Web App    │  Mobile App  │  Third-Party │  Document Upload    │
│             │              │  APIs (W2s)  │  (PDF, Images)      │
└──────┬──────┴──────┬───────┴──────┬───────┴──────┬──────────────┘
       │             │              │              │
       ▼             ▼              ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Ingestion Layer                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ API GW   │  │ Kinesis  │  │ S3 Event │  │ SQS      │       │
│  │ (REST)   │  │ Streams  │  │ Triggers │  │ Queues   │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Raw Data Storage (Bronze)                     │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  S3 - Encrypted (SSE-KMS) - Partitioned by date/user      │  │
│  │  Path: s3://tax-data/bronze/year=YYYY/month=MM/day=DD/    │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Processing Layer (ETL)                         │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              AWS Glue / Spark on EMR                    │    │
│  │  - Data Validation & Cleansing                          │    │
│  │  - PII Tokenization/Encryption                          │    │
│  │  - Schema Validation                                     │    │
│  │  - Business Rules Application                           │    │
│  │  - Tax Calculations                                      │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              Processed Data Storage (Silver)                     │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  S3 - Parquet Format - Partitioned - Compressed          │  │
│  │  Path: s3://tax-data/silver/year=YYYY/month=MM/          │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│           Aggregation & Analytics Layer (Gold)                   │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  - Tax Summary Tables                                    │    │
│  │  - User Profiles                                         │    │
│  │  - IRS Filing Status                                     │    │
│  │  - Deduction Analytics                                   │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Data Consumption Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ Redshift │  │ Athena   │  │ QuickSight│  │ ML Models│       │
│  │ (DWH)    │  │ (Query)  │  │ (BI)     │  │          │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
Detailed Component Design
1. Ingestion Layer
python# AWS Lambda function for API ingestion
import json
import boto3
import hashlib
from datetime import datetime

s3 = boto3.client('s3')
kms = boto3.client('kms')

def lambda_handler(event, context):
    """
    Ingest tax return data from API Gateway
    """
    try:
        # Extract data
        user_id = event['body']['user_id']
        tax_data = event['body']['tax_data']
        
        # Generate unique transaction ID
        transaction_id = hashlib.sha256(
            f"{user_id}_{datetime.utcnow().isoformat()}".encode()
        ).hexdigest()
        
        # Add metadata
        enriched_data = {
            'transaction_id': transaction_id,
            'user_id': user_id,
            'tax_data': tax_data,
            'ingestion_timestamp': datetime.utcnow().isoformat(),
            'source': 'web_api',
            'tax_year': event['body'].get('tax_year', 2024)
        }
        
        # Write to S3 (Bronze layer)
        date = datetime.utcnow()
        s3_key = f"bronze/year={date.year}/month={date.month:02d}/day={date.day:02d}/{transaction_id}.json"
        
        s3.put_object(
            Bucket='turbotax-data-lake',
            Key=s3_key,
            Body=json.dumps(enriched_data),
            ServerSideEncryption='aws:kms',
            SSEKMSKeyId='arn:aws:kms:region:account:key/key-id'
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'transaction_id': transaction_id,
                'status': 'accepted'
            })
        }
        
    except Exception as e:
        # Log error and send to DLQ
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal server error'})
        }
2. ETL Processing (PySpark)
pythonfrom pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, lit, current_timestamp, sha2, concat_ws
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType

# Initialize Spark with encryption
spark = SparkSession.builder \
    .appName("TurboTax-ETL") \
    .config("spark.sql.parquet.compression.codec", "snappy") \
    .config("spark.hadoop.fs.s3a.encryption.enabled", "true") \
    .config("spark.hadoop.fs.s3a.server-side-encryption-algorithm", "SSE-KMS") \
    .getOrCreate()

# Define schema for tax return data
tax_return_schema = StructType([
    StructField("transaction_id", StringType(), False),
    StructField("user_id", StringType(), False),
    StructField("tax_year", IntegerType(), False),
    StructField("filing_status", StringType(), True),
    StructField("total_income", DoubleType(), True),
    StructField("total_deductions", DoubleType(), True),
    StructField("tax_owed", DoubleType(), True),
    StructField("ssn", StringType(), True),  # Will be tokenized
    StructField("address", StringType(), True)
])

def process_tax_returns(bronze_path, silver_path, date_partition):
    """
    ETL pipeline for processing tax returns
    """
    
    # Read from Bronze layer
    df_raw = spark.read \
        .schema(tax_return_schema) \
        .json(f"{bronze_path}/year={date_partition['year']}/month={date_partition['month']}/day={date_partition['day']}/")
    
    # Data Quality Checks
    df_validated = df_raw.filter(
        (col("user_id").isNotNull()) &
        (col("tax_year").between(2015, 2024)) &
        (col("total_income") >= 0) &
        (col("total_deductions") >= 0)
    )
    
    # Tokenize PII (SSN)
    df_tokenized = df_validated.withColumn(
        "ssn_token",
        sha2(concat_ws("_", col("ssn"), lit("SECRET_SALT")), 256)
    ).drop("ssn")
    
    # Apply business rules - Calculate tax liability
    df_processed = df_tokenized.withColumn(
        "taxable_income",
        col("total_income") - col("total_deductions")
    ).withColumn(
        "calculated_tax",
        when(col("taxable_income") <= 10000, col("taxable_income") * 0.10)
        .when(col("taxable_income") <= 40000, 1000 + (col("taxable_income") - 10000) * 0.12)
        .when(col("taxable_income") <= 85000, 4600 + (col("taxable_income") - 40000) * 0.22)
        .otherwise(14500 + (col("taxable_income") - 85000) * 0.24)
    ).withColumn(
        "processing_timestamp",
        current_timestamp()
    ).withColumn(
        "data_quality_score",
        lit(100)  # Simplified - would be complex calculation
    )
    
    # Add audit columns
    df_final = df_processed.withColumn("processed_by", lit("etl_pipeline_v1")) \
        .withColumn("pipeline_run_id", lit(date_partition['run_id']))
    
    # Write to Silver layer (partitioned Parquet)
    df_final.write \
        .mode("append") \
        .partitionBy("tax_year", "filing_status") \
        .parquet(silver_path)
    
    # Write metrics for monitoring
    metrics = {
        'total_records': df_raw.count(),
        'valid_records': df_validated.count(),
        'processed_records': df_final.count(),
        'avg_tax_owed': df_final.agg({'calculated_tax': 'avg'}).collect()[0][0]
    }
    
    return metrics

# Example usage
bronze_path = "s3://turbotax-data-lake/bronze/"
silver_path = "s3://turbotax-data-lake/silver/"
date_partition = {
    'year': 2024,
    'month': 4,
    'day': 15,
    'run_id': 'run_20240415_001'
}

metrics = process_tax_returns(bronze_path, silver_path, date_partition)
print(f"Processing metrics: {metrics}")
3. Gold Layer - Aggregation
pythonfrom pyspark.sql.functions import sum, avg, count, max, min, row_number, date_format
from pyspark.sql.window import Window

def create_aggregated_tables(silver_path, gold_path):
    """
    Create aggregated tables for analytics and reporting
    """
    
    # Read from Silver layer
    df_silver = spark.read.parquet(silver_path)
    
    # 1. Tax summary by filing status
    df_tax_summary = df_silver.groupBy("tax_year", "filing_status") \
        .agg(
            count("*").alias("num_returns"),
            avg("total_income").alias("avg_income"),
            avg("calculated_tax").alias("avg_tax"),
            sum("calculated_tax").alias("total_tax_collected")
        )
    
    df_tax_summary.write \
        .mode("overwrite") \
        .partitionBy("tax_year") \
        .parquet(f"{gold_path}/tax_summary/")
    
    # 2. User filing history
    window_spec = Window.partitionBy("user_id").orderBy("processing_timestamp")
    
    df_user_history = df_silver.select(
        "user_id",
        "tax_year",
        "filing_status",
        "total_income",
        "calculated_tax",
        "processing_timestamp"
    ).withColumn("filing_sequence", row_number().over(window_spec))
    
    df_user_history.write \
        .mode("overwrite") \
        .partitionBy("tax_year") \
        .parquet(f"{gold_path}/user_filing_history/")
    
    # 3. Deduction analytics
    df_deduction_analysis = df_silver.groupBy("tax_year", "filing_status") \
        .agg(
            avg("total_deductions").alias("avg_deductions"),
            max("total_deductions").alias("max_deductions"),
            min("total_deductions").alias("min_deductions")
        )
    
    df_deduction_analysis.write \
        .mode("overwrite") \
        .partitionBy("tax_year") \
        .parquet(f"{gold_path}/deduction_analysis/")
    
    # 4. Daily processing metrics
    df_daily_metrics = df_silver.groupBy(
        date_format("processing_timestamp", "yyyy-MM-dd").alias("processing_date")
    ).agg(
        count("*").alias("records_processed"),
        avg("data_quality_score").alias("avg_quality_score")
    )
    
    df_daily_metrics.write \
        .mode("overwrite") \
        .parquet(f"{gold_path}/daily_metrics/")

# Execute aggregations
gold_path = "s3://turbotax-data-lake/gold/"
create_aggregated_tables(silver_path, gold_path)
4. Orchestration (Apache Airflow)
pythonfrom airflow import DAG
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-engineering',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5)
}

dag = DAG(
    'turbotax_etl_pipeline',
    default_args=default_args,
    description='Daily ETL pipeline for TurboTax data',
    schedule_interval='0 2 * * *',  # Run at 2 AM daily
    catchup=False,
    max_active_runs=1
)

# Task 1: Check if new data is available
check_bronze_data = S3KeySensor(
    task_id='check_bronze_data',
    bucket_name='turbotax-data-lake',
    bucket_key='bronze/year={{ execution_date.year }}/month={{ execution_date.month }}/day={{ execution_date.day }}/',
    aws_conn_id='aws_default',
    timeout=3600,
    poke_interval=300,
    dag=dag
)

# Task 2: Run ETL job (Bronze to Silver)
bronze_to_silver = GlueJobOperator(
    task_id='bronze_to_silver',
    job_name='turbotax-bronze-to-silver',
    script_location='s3://turbotax-scripts/etl/bronze_to_silver.py',
    s3_bucket='turbotax-glue-logs',
    iam_role_name='GlueServiceRole',
    create_job_kwargs={
        'GlueVersion': '3.0',
        'NumberOfWorkers': 10,
        'WorkerType': 'G.1X'
    },
    script_args={
        '--date': '{{ ds }}',
        '--source_path': 's3://turbotax-data-lake/bronze/',
        '--target_path': 's3://turbotax-data-lake/silver/'
    },
    dag=dag
)

# Task 3: Run aggregation job (Silver to Gold)
silver_to_gold = GlueJobOperator(
    task_id='silver_to_gold',
    job_name='turbotax-silver-to-gold',
    script_location='s3://turbotax-scripts/etl/silver_to_gold.py',
    s3_bucket='turbotax-glue-logs',
    iam_role_name='GlueServiceRole',
    create_job_kwargs={
        'GlueVersion': '3.0',
        'NumberOfWorkers': 5,
        'WorkerType': 'G.1X'
    },
    script_args={
        '--date': '{{ ds }}',
        '--source_path': 's3://turbotax-data-lake/silver/',
        '--target_path': 's3://turbotax-data-lake/gold/'
    },
    dag=dag
)

# Task 4: Data quality validation
def validate_data_quality(**context):
    """
    Validate data quality metrics
    """
    # Connect to data and run quality checks
    # This would include checks like:
    # - Row count validation
    # - Null check on critical columns
    # - Data type validation
    # - Business rule validation
    pass

data_quality_check = PythonOperator(
    task_id='data_quality_check',
    python_callable=validate_data_quality,
    provide_context=True,
    dag=dag
)

# Task 5: Load to Redshift
load_to_redshift = GlueJobOperator(
    task_id='load_to_redshift',
    job_name='turbotax-load-redshift',
    script_location='s3://turbotax-scripts/etl/load_redshift.py',
    s3_bucket='turbotax-glue-logs',
    iam_role_name='GlueServiceRole',
    script_args={
        '--date': '{{ ds }}',
        '--source_path': 's3://turbotax-data-lake/gold/',
        '--redshift_cluster': 'turbotax-prod-cluster'
    },
    dag=dag
)

# Define task dependencies
check_bronze_data >> bronze_to_silver >> data_quality_check >> silver_to_gold >> load_to_redshift
Scaling for Peak Season
python# Auto-scaling configuration for EMR cluster
from boto3 import client

emr = client('emr')

def create_autoscaling_emr_cluster():
    """
    Create EMR cluster with auto-scaling for tax season
    """
    response = emr.run_job_flow(
        Name='TurboTax-ETL-Cluster',
        ReleaseLabel='emr-6.10.0',
        Applications=[
            {'Name': 'Spark'},
            {'Name': 'Hadoop'}
        ],
        Instances={
            'InstanceGroups': [
                {
                    'Name': 'Master',
                    'InstanceRole': 'MASTER',
                    'InstanceType': 'r5.2xlarge',
                    'InstanceCount': 1
                },
                {
                    'Name': 'Core',
                    'InstanceRole': 'CORE',
                    'InstanceType': 'r5.4xlarge',
                    'InstanceCount': 5,
                    'AutoScalingPolicy': {
                        'Constraints': {
                            'MinCapacity': 5,
                            'MaxCapacity': 50  # Scale up to 50 during peak
                        },
                        'Rules': [
                            {
                                'Name': 'ScaleUpOnYARNMemory',
                                'Action': {
                                    'SimpleScalingPolicyConfiguration': {
                                        'AdjustmentType': 'CHANGE_IN_CAPACITY',
                                        'ScalingAdjustment': 5,
                                        'CoolDown': 300
                                    }
                                },
                                'Trigger': {
                                    'CloudWatchAlarmDefinition': {
                                        'ComparisonOperator': 'GREATER_THAN',
                                        'EvaluationPeriods': 2,
                                        'MetricName': 'YARNMemoryAvailablePercentage',
                                        'Period': 300,
                                        'Threshold': 15.0,
                                        'Statistic': 'AVERAGE',
                                        'Unit': 'PERCENT'
                                    }
                                }
                            },
                            {
                                'Name': 'ScaleDownOnYARNMemory',
                                'Action': {
                                    'SimpleScalingPolicyConfiguration': {
                                        'AdjustmentType': 'CHANGE_IN_CAPACITY',
                                        'ScalingAdjustment': -2,
                                        'CoolDown': 300
                                    }
                                },
                                'Trigger': {
                                    'CloudWatchAlarmDefinition': {
                                        'ComparisonOperator': 'LESS_THAN',
                                        'EvaluationPeriods': 2,
                                        'MetricName': 'YARNMemoryAvailablePercentage',
                                        'Period': 300,
                                        'Threshold': 75.0,
                                        'Statistic': 'AVERAGE',
                                        'Unit': 'PERCENT'
                                    }
                                }
                            }
                        ]
                    }
                }
            ],
            'KeepJobFlowAliveWhenNoSteps': True,
            'TerminationProtected': False,
            'Ec2SubnetId': 'subnet-xxxxx'
        },
        ServiceRole='EMR_DefaultRole',
        JobFlowRole='EMR_EC2_DefaultRole'
    )
    
    return response['JobFlowId']
Security & Compliance
python# PII Data Tokenization Service
import hashlib
import hmac
import json
import uuid
from cryptography.fernet import Fernet
import boto3
from datetime import datetime, timedelta

class PIITokenizer:
    def __init__(self, kms_key_id):
        self.kms = boto3.client('kms')
        self.kms_key_id = kms_key_id
        
    def tokenize_ssn(self, ssn, user_id):
        """
        Tokenize SSN using HMAC with KMS-managed key
        """
        # Get data key from KMS
        response = self.kms.generate_data_key(
            KeyId=self.kms_key_id,
            KeySpec='AES_256'
        )
        
        plaintext_key = response['Plaintext']
        
        # Create HMAC token
        token = hmac.new(
            plaintext_key,
            f"{ssn}_{user_id}".encode(),
            hashlib.sha256
        ).hexdigest()
        
        return token
    
    def encrypt_sensitive_data(self, data):
        """
        Encrypt sensitive data using KMS
        """
        response = self.kms.encrypt(
            KeyId=self.kms_key_id,
            Plaintext=data.encode()
        )
        
        return response['CiphertextBlob']
    
    def audit_log(self, action, user_id, data_accessed):
        """
        Log all PII access for audit trail
        """
        log_entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'action': action,
            'user_id': user_id,
            'data_accessed': data_accessed,
            'ip_address': 'xxx.xxx.xxx.xxx'  # From request context
        }
        
        # Write to audit log (S3 with WORM - Write Once Read Many)
        s3 = boto3.client('s3')
        s3.put_object(
            Bucket='turbotax-audit-logs',
            Key=f"audit/{datetime.utcnow().date()}/{uuid.uuid4()}.json",
            Body=json.dumps(log_entry),
            ServerSideEncryption='aws:kms',
            ObjectLockMode='GOVERNANCE',
            ObjectLockRetainUntilDate=datetime.utcnow() + timedelta(days=2555)  # 7 years
        )
Monitoring & Alerting
python# CloudWatch Metrics and Alarms
import boto3
from datetime import datetime

cloudwatch = boto3.client('cloudwatch')

def publish_pipeline_metrics(namespace='TurboTax/ETL', metrics_data=None):
    """
    Publish custom metrics to CloudWatch
    """
    if metrics_data is None:
        metrics_data = {}
        
    cloudwatch.put_metric_data(
        Namespace=namespace,
        MetricData=[
            {
                'MetricName': 'RecordsProcessed',
                'Value': metrics_data.get('records_processed', 0),
                'Unit': 'Count',
                'Timestamp': datetime.utcnow()
            },
            {
                'MetricName': 'ProcessingDuration',
                'Value': metrics_data.get('duration_seconds', 0),
                'Unit': 'Seconds',
                'Timestamp': datetime.utcnow()
            },
            {
                'MetricName': 'DataQualityScore',
                'Value': metrics_data.get('quality_score', 0),
                'Unit': 'Percent',
                'Timestamp': datetime.utcnow()
            },
            {
                'MetricName': 'FailedRecords',
                'Value': metrics_data.get('failed_records', 0),
                'Unit': 'Count',
                'Timestamp': datetime.utcnow()
            }
        ]
    )

# Create CloudWatch Alarms
def create_pipeline_alarms():
    """
    Create alarms for pipeline monitoring
    """
    # Alarm for high failure rate
    cloudwatch.put_metric_alarm(
        AlarmName='TurboTax-ETL-High-Failure-Rate',
        ComparisonOperator='GreaterThanThreshold',
        EvaluationPeriods=2,
        MetricName='FailedRecords',
        Namespace='TurboTax/ETL',
        Period=300,
        Statistic='Sum',
        Threshold=1000.0,
        ActionsEnabled=True,
        AlarmActions=['arn:aws:sns:region:account:turbotax-alerts'],
        AlarmDescription='Alert when failed records exceed threshold'
    )
    
    # Alarm for processing delay
    cloudwatch.put_metric_alarm(
        AlarmName='TurboTax-ETL-Processing-Delay',
        ComparisonOperator='GreaterThanThreshold',
        EvaluationPeriods=1,
        MetricName='ProcessingDuration',
        Namespace='TurboTax/ETL',
        Period=3600,
        Statistic='Average',
        Threshold=7200.0,  # 2 hours
        ActionsEnabled=True,
        AlarmActions=['arn:aws:sns:region:account:turbotax-alerts'],
        AlarmDescription='Alert when processing takes too long'
    )
Key Design Decisions

Data Lake Architecture (Bronze/Silver/Gold)

Bronze: Raw data, immutable, encrypted
Silver: Cleansed, validated, PII tokenized
Gold: Aggregated, optimized for analytics


Partitioning Strategy

Time-based partitioning (year/month/day) for efficient queries
Secondary partitioning by filing_status for common filters


Security

Encryption at rest (KMS) and in transit (TLS)
PII tokenization/encryption
Audit logging for compliance
IAM roles with least privilege


Scalability

Auto-scaling EMR clusters for peak season
Serverless components (Lambda, Glue) for elastic scaling
Partitioning for parallel processing


Data Quality

Schema validation at ingestion
Business rule validation in ETL
Data quality scores and monitoring
Dead letter queues for failed records


High Availability

Multi-AZ deployment
S3 for durable storage (99.999999999% durability)
Retry logic and idempotent operations
Disaster recovery with cross-region replication




2. Real-time Fraud Detection System
Problem Statement
Design a real-time fraud detection system for financial transactions that can process millions of transactions per second, detect fraudulent patterns, and alert/block suspicious activity within milliseconds.
Requirements

Process 10M+ transactions per second
Detection latency < 100ms (p99)
99.99% uptime
False positive rate < 1%
Support for ML model updates without downtime
Real-time feature engineering
Historical data for model training

High-Level Architecture
┌────────────────────────────────────────────────────────────────────┐
│                      Transaction Sources                            │
├──────────────┬──────────────┬──────────────┬──────────────────────┤
│  Mobile App  │  Web App     │  ATM         │  POS Terminals       │
└──────┬───────┴──────┬───────┴──────┬───────┴──────┬───────────────┘
       │              │              │              │
       ▼              ▼              ▼              ▼
┌────RetryThis response paused because Claude reached its max length for a message. Hit continue to nudge Claude along.ContinueClaude can make mistakes. Please double-check responses.