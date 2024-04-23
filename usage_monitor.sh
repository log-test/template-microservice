#!/bin/bash

# Function to log process name, CPU, and memory usage
log_usage() {
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - Process: $1, CPU: $2%, Memory: $3%" >> usage_log.txt
}

# Function to monitor CPU and memory usage
monitor_usage() {
    threshold_cpu=$1
    threshold_memory=$2

    while true; do
        # Get the top CPU-consuming process
        top_output=$(top -bn1 | grep -E "^ *[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+[ ]+[0-9]+\.[0-9]+[ ]+[0-9]+\.[0-9]+[ ]+[^ ]+" | sort -k9 -nr | head -n1)
        pid=$(echo "$top_output" | awk '{print $1}')
        process_name=$(ps -p $pid -o comm=)
        cpu_percent=$(echo "$top_output" | awk '{print 100 - $9}')
        memory_percent=$(echo "$top_output" | awk '{print $10}')

        if [ "$(echo "$cpu_percent > $threshold_cpu" | bc)" -eq 1 ] || [ "$(echo "$memory_percent > $threshold_memory" | bc)" -eq 1 ]; then
            log_usage "$process_name" "$cpu_percent" "$memory_percent"
        fi

        sleep 1
    done
}

# Main
threshold_cpu=80  # Example CPU threshold (80%)
threshold_memory=80  # Example memory threshold (80%)

monitor_usage "$threshold_cpu" "$threshold_memory"
