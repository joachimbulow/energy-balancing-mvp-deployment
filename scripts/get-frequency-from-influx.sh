#!/bin/bash

simulation_number=$1
local_path=$2

# if variables are not set or empty, print error message and exit
if [[ -z "$simulation_number" || -z "$local_path" ]]; then
    echo "Usage: ./get-frequency-from-influx.sh <simulation_number> <local_path_of_simulations_csv_without_the_filename>"
    echo "Example: ./get-frequency-from-influx.sh 5 /Users/sofielouise/masterbeasts/energy-balancing-mvp"
    exit 1
fi

csv_file="$local_path/simulations$simulation_number.csv"

# Read the CSV file and execute kubectl exec for each line
while IFS=',' read -r start_time pods batteries _; do
    # Skip empty lines
    if [[ -n "$start_time" ]]; then
        echo "Read line: $start_time, $pods, $batteries"

        # if cl_start_time is not empty, execute kubectl exec command
        if [[ -n "$cl_start_time" ]]; then
            echo "CL_START_TIME: $cl_start_time"
            echo "CL_PODS: $cl_pods"
            echo "CL_BATTERIES: $cl_batteries"
            echo "FILE_NAME: $file_name"

            # Execute kubectl exec command
            kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT frequency FROM frequency WHERE time > $cl_start_time and time < $start_time" > $file_name

            echo "Command executed for start time: $cl_start_time, end time: $start_time, pods: $cl_pods, batteries: $cl_batteries and saved to file: $file_name"
        fi

        cl_start_time="$start_time"
        cl_pods="$pods"
        cl_batteries="$batteries"
        file_name="simulations${simulation_number}_frequency_${cl_pods// /}_${cl_batteries// /}.csv"

        echo "Command executed for start time: $start_time"
    fi
done < "$csv_file"