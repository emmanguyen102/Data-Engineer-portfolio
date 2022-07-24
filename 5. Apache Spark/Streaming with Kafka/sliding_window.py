from pyspark.sql import SparkSession, Window
from pyspark.sql.functions import from_json, col, to_timestamp, window, expr, sum
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

spark = SparkSession \
	.builder \
	.appName("lab10") \
	.master("local") \
	.config("spark.streaming.stopGracefullyOnShutdown", "true") \
	.config("spark.sql.shuffle.partitions", 2) \
    .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.3.0")\
    .config("spark.sql.streaming.schemaInference", "true") \
	.getOrCreate()

stock_schema = StructType([
        StructField("CreatedTime", StringType()),
        StructField("Type", StringType()),
        StructField("Amount", IntegerType()),
        StructField("BrokerCode", StringType())
    ])

# Đọc dữ liệu từ Kafka
kafka_df = spark.readStream \
	.format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
	.option("subscribe", "trades") \
	.option("startingOffsets", "earliest") \
    .option("failOnDataLoss", "false") \
	.load()

# Chuyển dữ liệu từ dạng JSON về MapType()
value_df = kafka_df.select(from_json(col("value").cast("string"), stock_schema).alias("value"))

# Trích xuất các dữ liệu
trade_df = value_df.select("value.*") \
        .withColumn("CreatedTime", to_timestamp(col("CreatedTime"), "yyyy-MM-dd HH:mm:ss")) \
        .withColumn("Buy", expr("case when Type == 'BUY' then Amount else 0 end")) \
        .withColumn("Sell", expr("case when Type == 'SELL' then Amount else 0 end"))


# Sử dụng cơ chế Tumbling Window
window_agg_df = trade_df \
        .groupBy(  # col("BrokerCode"),
         window(col("CreatedTime"), "15 minute")) \
        .agg(sum("Buy").alias("TotalBuy"),
             sum("Sell").alias("TotalSell"))

# Ghi dữ liệu đã xử lý
output_df = window_agg_df.select("window.start", "window.end", "TotalBuy", "TotalSell")

window_query = output_df.writeStream \
        .format("console") \
        .outputMode("update") \
        .trigger(processingTime="1 minute") \
        .start()

print("Waiting for Query")
window_query.awaitTermination()