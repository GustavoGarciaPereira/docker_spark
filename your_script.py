from pyspark.sql import SparkSession

def main():
    # Create a Spark session
    spark = SparkSession.builder \
        .appName("PySpark Test") \
        .getOrCreate()

    # Sample data
    data = [("Java", 20000), ("Python", 100000), ("Scala", 3000)]

    # Create a DataFrame
    columns = ["Language", "Users"]
    df = spark.createDataFrame(data, schema=columns)

    # Show the DataFrame
    df.show()

    # Stop the Spark session
    spark.stop()

if __name__ == "__main__":
    main()
