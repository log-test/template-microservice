#!/bin/bash

# Function to log CPU and memory usage
log_usage() {
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - CPU: $1%, Memory: $2%" >> usage_log.txt
}

# Function to monitor CPU and memory usage
monitor_usage() {
    threshold_cpu=$1
    threshold_memory=$2

    while true; do
        cpu_percent=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
        memory_percent=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

        if [ "$(echo "$cpu_percent > $threshold_cpu" | bc)" -eq 1 ] || [ "$(echo "$memory_percent > $threshold_memory" | bc)" -eq 1 ]; then
            log_usage "$cpu_percent" "$memory_percent"
        fi

        sleep 1
    done
}

# Main
threshold_cpu=80  # Example CPU threshold (80%)
threshold_memory=80  # Example memory threshold (80%)

monitor_usage "$threshold_cpu" "$threshold_memory"
