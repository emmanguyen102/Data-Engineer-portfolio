from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.python_operator import BranchPythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from datetime import datetime
import os
import pyspark
from pyspark.sql import SparkSession, SQLContext, functions as F
from pyspark.sql.functions import *
import pandas as pd
import findspark

findspark.init()

# using pyspark to do analysis on dataset from mongo collections
def spark_processing():
	spark = SparkSession \
		.builder \
		.master("local") \
		.appName("depx303_asm2") \
		.config("spark.driver.memory", "15g") \
		.config("spark.mongodb.read.connection.uri", "mongodb://localhost:27017/DEPx303_ASM2") \
		.config("spark.mongodb.write.connection.uri", "mongodb://localhost:27017/DEPx303_ASM2") \
		.config('spark.jars.packages', 'org.mongodb.spark:mongo-spark-connector:10.0.2') \
		.getOrCreate()
	
	# read collections into spark dataframes, with columns modification
	questions = spark.read \
		  .format("mongodb") \
		  .option("uri", "mongodb://localhost:27017/DEPx303_ASM2") \
		  .option("database", "DEPx303_ASM2") \
		  .option("collection", "questions") \
		  .load()

	questions = questions.withColumnRenamed("Id", "QuestionID")
	    
	answers = spark.read \
		  .format("mongodb") \
		  .option("uri", "mongodb://localhost:27017/DEPx303_ASM2") \
		  .option("database", "DEPx303_ASM2") \
		  .option("collection", "answers") \
		  .load()

	    # create a new database if not exists
	spark.sql("CREATE DATABASE IF NOT EXISTS DB1")
	spark.sql("USE DB1")

	    # use bucket join to join 2 dataframes 

	    # write data from df to parquet table 
	questions.write.bucketBy(10, "QuestionID") \
		.format("parquet") \
		.mode("overwrite")\
		.option("path", r"/home/<user>/airflow/dags/output1")\
		.saveAsTable("DB1.questions")

	    # write data from answers dataframe to parquet table 
	answers.write \
		.bucketBy(10, "ParentId") \
		.format("parquet") \
		.mode("overwrite") \
		.option("path", r"/home/<user>/airflow/dags/output2")\
		.saveAsTable("DB1.answers")


	df3 = spark.read.table("DB1.questions")
	df4 = spark.read.table("DB1.answers") 
	join_expr = df3.QuestionID == df4.ParentId

	    # all questions with its total number of answers
	result = df3.join(df4, join_expr, "inner") \
	       .select("QuestionID", "Id") \
	       .groupBy("QuestionID") \
	       .agg(F.count("Id").alias("Number of answers")) \
	       .sort(asc("QuestionID")) 

	#write dataframe into csv file
	result.toPandas() \
	      .to_csv(r'/home/<user>/airflow/dags/result.csv', index=False)
	
	spark.stop()

# function for branching
# if files are not downloaded then task clear_file, else move to end task
def branch(**kwargs):
	# path of the directory
	directoryPath = "/home/<user>/airflow/dags/data"
	if os.listdir(directoryPath) == ["Answers.csv", "Questions.csv"]:
		return 'end'
	return 'clear_file'


with DAG('DEPx303_ASM2', start_date=datetime(2022, 1, 1), 
    schedule_interval=None, catchup=False) as dag:

    start = DummyOperator(
        task_id="start"
    )

    end = DummyOperator(
        task_id="end",
	trigger_rule="none_failed"
    )
    # let's do branching 
    branching = BranchPythonOperator(
        task_id='branching',
        python_callable=branch
    )
    # clear all files in data folder
    clear_file = BashOperator(
        task_id='clear_file',
        bash_command="rm -f /home/<user>/airflow/dags/data/*"
    )
    # download files using gdown
    download_task_1 = BashOperator(
        task_id = "download_answer_file_task",
        bash_command="cd /home/<user>/airflow/dags/data && gdown https://drive.google.com/u/0/uc?id=1F_L6X5cj_Cm8gjCp8jD0LSTk2dd5o2f4&export=download&confirm=t"
    )

    download_task_2 = BashOperator(
        task_id = "download_question_file_task",
        bash_command="cd /home/<user>/airflow/dags/data && gdown https://drive.google.com/u/0/uc?id=1vPjs6L5otcJt38FWxXjZZPErcXN_BkUd&export=download&confirm=t"
    )
    # import data into mongodb
    import_task_1 = BashOperator(
        task_id="import_answers_mongo",
        bash_command= "mongoimport --type csv -d DEPx303_ASM2 -c answers --headerline --drop /home/<user>/airflow/dags/data/Answers.csv"
    )

    import_task_2 = BashOperator(
        task_id="import_questions_mongo",
        bash_command= "mongoimport --type csv -d DEPx303_ASM2 -c questions --headerline --drop /home/<user>/airflow/dags/data/Questions.csv"
    )
    #spark process, using PythonOperator :)
    # not using SparkSubmitOperator since the spark task will go into infinite loop, all other errors have been fixed while doing this
    # so that it's safer to go with PythonOperator
    # can use BashOperator here also, for checking logs
    spark_task = PythonOperator(
		task_id='spark_process', 
        	python_callable=spark_processing
    )
    # import data from csv to mongo
    write_csv_task = BashOperator(
         task_id = "import_output_mongo",
         bash_command="mongoimport --type csv -d DEPx303_ASM2 -c result --headerline --drop /home/<user>/airflow/dags/result.csv"
    )



# order of tasks
start >> branching 
branching >> clear_file >> [download_task_1 , download_task_2] 
download_task_1 >> import_task_1
download_task_2 >> import_task_2
[import_task_1, import_task_2] >> spark_task >> write_csv_task >> end
branching >> end