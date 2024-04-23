# # Use the official Python image from the Debian bullseye release
# FROM python:3.8-slim-bullseye

# # Set the working directory in the container
# WORKDIR /usr/src/app

# # Install Java (required for PySpark)
# RUN apt-get update && apt-get install -y openjdk-11-jre-headless && apt-get clean;

# # Set JAVA_HOME environment variable
# ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# # Install PySpark using pip
# RUN pip install pyspark

# # Copy the current directory contents into the container at /usr/src/app
# COPY . .

# # Command to run on container start
# CMD ["python", "./your_script.py"]
# Use the official Debian Python image as a base
# Use the official Debian Python image as a base
FROM python:3.8-slim-bullseye

# Set the working directory
WORKDIR /app

# Install Java and wget (required for downloading Spark)
RUN apt-get update && apt-get install -y openjdk-11-jre-headless wget

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Download and install Spark
ENV SPARK_VERSION 3.5.1
ENV HADOOP_VERSION 3
RUN wget --no-verbose https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
    && tar -xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /opt \
    && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# Set SPARK_HOME environment variable
ENV SPARK_HOME /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
ENV PATH $PATH:$SPARK_HOME/bin

# Copy the start script to the container
COPY start-spark.sh /app/start-spark.sh
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
RUN chmod +x /app/start-spark.sh

# Expose the Spark UI port
EXPOSE 4040

# Command to run on container start
CMD ["/app/start-spark.sh"]
# # Command to run on container start
# CMD ["python", "./your_script.py"]
#CMD ["pyspark"]
#CMD ["spark-shell"]
