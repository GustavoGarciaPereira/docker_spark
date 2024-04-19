#!/bin/bash
# Start Spark master and worker
$SPARK_HOME/sbin/start-master.sh
$SPARK_HOME/sbin/start-slave.sh spark://localhost:7077

# Keep container running
tail -f /dev/null
