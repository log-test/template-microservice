#!/bin/bash

# Function to log CPU, memory usage, and process name
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
        top_output=$(ps -eo pid,comm,%cpu,%mem --sort=-%cpu,-%mem | head -n 2 | tail -n 1)
        process_name=$(echo "$top_output" | awk '{print $2}')
        cpu_percent=$(echo "$top_output" | awk '{print $3}')
        memory_percent=$(echo "$top_output" | awk '{print $4}')

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
