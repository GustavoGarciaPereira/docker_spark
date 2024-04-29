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
# FROM python:3.8-slim-bullseye

# # Set the working directory
# WORKDIR /app

# # Install Java and wget (required for downloading Spark)
# RUN apt-get update && apt-get install -y openjdk-11-jre-headless wget procps



# # Set JAVA_HOME environment variable
# ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# # Download and install Spark
# ENV SPARK_VERSION 3.5.1
# ENV HADOOP_VERSION 3
# RUN wget --no-verbose https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
#     && tar -xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /opt \
#     && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# # Set SPARK_HOME environment variable
# ENV SPARK_HOME /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
# ENV PATH $PATH:$SPARK_HOME/bin

# # Copy the start script to the container
# COPY start-spark.sh /app/start-spark.sh
# COPY requirements.txt /app/requirements.txt
# RUN pip install -r /app/requirements.txt
# RUN chmod +x /app/start-spark.sh

# # Expose the Spark UI port
# EXPOSE 4040

# # Command to run on container start
# CMD ["/app/start-spark.sh"]
# # CMD ["/bin/bash"]
# # # Command to run on container start
# # CMD ["python", "./your_script.py"]
# #CMD ["pyspark"]
# #CMD ["spark-shell"]


# Use a specific tag for a stable Python environment
FROM python:3.8-slim-bullseye

# Set environment variables for Java and Spark versions
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    SPARK_VERSION=3.5.1 \
    HADOOP_VERSION=3 \
    SPARK_HOME=/opt/spark-3.5.1-bin-hadoop3 \
    PATH=$PATH:/opt/spark-3.5.1-bin-hadoop3/bin

# Set the working directory in the container
WORKDIR /app

# Install Java, wget, and procps (required for managing processes)
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless wget procps && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Download and install Apache Spark
RUN wget --no-verbose https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -O /tmp/spark.tgz && \
    tar -xzf /tmp/spark.tgz -C /opt && \
    rm /tmp/spark.tgz

# Copy necessary files
COPY start-spark.sh requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt && \
    chmod +x start-spark.sh

# Expose port for Spark UI
EXPOSE 4040

# Command to run on container start
CMD ["./start-spark.sh"]
