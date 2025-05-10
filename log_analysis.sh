#!/bin/bash

LOG_FILE="access.log"  # Change this to your log file name

# Function to count total requests
count_requests() {
    total_requests=$(wc -l < "$LOG_FILE")
    echo "Total Requests: $total_requests"
}

# Function to count GET and POST requests
count_methods() {
    get_requests=$(grep -c "GET" "$LOG_FILE")
    post_requests=$(grep -c "POST" "$LOG_FILE")
    echo "GET Requests: $get_requests"
    echo "POST Requests: $post_requests"
}

# Function to count unique IP addresses and display top 10 with request types
count_unique_ips() {
    echo "Counting unique IP addresses..."
    total_unique=$(awk '{print $1}' "$LOG_FILE" | sort | uniq | wc -l)
    echo "Total Unique IP Addresses: $total_unique"

    echo "Top 10 Unique IP Addresses with GET and POST counts:"
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10 | while read count ip; do
        get_count=$(grep -c "^$ip.*GET" "$LOG_FILE")
        post_count=$(grep -c "^$ip.*POST" "$LOG_FILE")
        echo "IP: $ip | Requests: $count | GET: $get_count | POST: $post_count"
    done
}

# Function to count failed requests
count_failed_requests() {
    failed_requests=$(grep -cE "404|500" "$LOG_FILE")
    echo "Failed Requests: $failed_requests"
    echo "Percentage of Failed Requests: $((failed_requests * 100 / total_requests))%"
}

# Function to find the most active IP
most_active_ip() {
    echo "Most Active IP:"
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 1
}

# Function to calculate daily averages
daily_average_requests() {
    echo "Average Requests Per Day:"
    awk '{print $4}' "$LOG_FILE" | cut -d: -f1 | uniq -c | awk '{sum+=$1} END {print sum/NR}'
}

# Function to analyze request failures by day
failure_analysis_by_day() {
    echo "Failures by Day:"
    grep -E "404|500" "$LOG_FILE" | awk '{print $4}' | cut -d: -f1 | sort | uniq -c | sort -nr
}

# Function to count requests by hour
requests_by_hour() {
    echo "Requests by Hour:"
    awk '{print $4}' "$LOG_FILE" | cut -d: -f2 | sort | uniq -c | sort -nr
}

# Function to provide status codes breakdown
status_code_breakdown() {
    echo "Status Codes Breakdown:"
    awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr
}

# Main function to execute all analyses
main() {
    count_requests
    count_methods
    count_unique_ips
    count_failed_requests
    most_active_ip
    daily_average_requests
    failure_analysis_by_day
    requests_by_hour
    status_code_breakdown
}

# Execute main function
main
