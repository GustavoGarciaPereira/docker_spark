# Use a base image with Python and Java (required for PySpark)
FROM openjdk:11-jre-slim

WORKDIR /app


# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*
COPY . /app
# Upgrade pip and install requirements
RUN pip3 install --upgrade pip && \
    pip3 install --upgrade certifi && \
    pip3 install -r requirements.txt

# Copy the local code to the container's working directory


# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "main_copy:app", "--host", "0.0.0.0", "--port", "8000"]
