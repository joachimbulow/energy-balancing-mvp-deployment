#!/bin/bash

time=$1
filename=$2
batteryPods=$3
nBatteries=$4

# Finding the battery actions

result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT sum(chargeActions) AS chargeSum, sum(dischargeActions) AS dischargeSum FROM actionSummary WHERE time > $time GROUP BY chargeActions, dischargeActions")
chargeSum=$(echo $result | awk '/chargeActions/ {print $13}')
dischargeSum=$(echo $result | awk '/dischargeActions/ {print $14}')


# Finding the average frequency

result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT MEAN(frequency) AS averageFrequency FROM frequency WHERE time > $time")

# - - - - Result is retarded, so this is the best we can do for now to extract the right data
averageFrequency=$(echo $result | awk '/averageFrequency/ {print $8}')


# Finding the max frequency
result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT MAX(frequency) AS maxFrequency FROM frequency WHERE time > $time")

maxFrequency=$(echo $result | awk '/maxFrequency/ {print $8}')

echo "Saving results to $filename..."
echo "Average frequency: $averageFrequency"
echo "Max frequency: $maxFrequency"
echo "Charge actions: $chargeSum"
echo "Discharge actions: $dischargeSum"
echo -e "$time, $batteryPods, $nBatteries, $averageFrequency, $maxFrequency, $chargeSum, $dischargeSum" >> $filename.csv