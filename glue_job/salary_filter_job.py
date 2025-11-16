import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from pyspark.sql import functions as F

args = getResolvedOptions(sys.argv, ['JOB_NAME','input_path','output_path'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

df = spark.read.option("header", True).option("inferSchema", True).csv(args['input_path'])
avg_salary = df.select(F.avg("salary")).collect()[0][0]
filtered_df = df.filter(F.col("salary") > avg_salary)
filtered_df.write.mode("overwrite").option("header", True).csv(args['output_path'])
