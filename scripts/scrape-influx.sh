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
averageFrequency=$(echo $result | awk '/averageFrequency/ {print $8}')

# Finding the median
result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT PERCENTILE(frequency, 50) AS medianFreq FROM frequency WHERE time > $time")
medianFrequency=$(echo $result | awk '/medianFreq/ {print $8}')

# Finding the frequency standard deviation
result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT STDDEV(frequency) AS frequencyStdDev FROM frequency WHERE time > $time")
frequencyStdDev=$(echo $result | awk '/frequencyStdDev/ {print $8}')

# Finding the max frequency
result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT MAX(frequency) AS maxFrequency FROM frequency WHERE time > $time")
maxFrequency=$(echo $result | awk '/maxFrequency/ {print $8}')

# Finding min frequency
result=$(kubectl exec charts-v1-influxdb-0 -- influx --database influx -precision rfc3339 --execute "SELECT MIN(frequency) AS minFrequency FROM frequency WHERE time > $time")
minFrequency=$(echo $result | awk '/minFrequency/ {print $8}')


############ RESULTS ############

# If the variable is empty, assign it a value of 0
[ -z "$averageFrequency" ] && averageFrequency=0
[ -z "$medianFrequency" ] && medianFrequency=0
[ -z "$frequencyStdDev" ] && frequencyStdDev=0
[ -z "$maxFrequency" ] && maxFrequency=0
[ -z "$minFrequency" ] && minFrequency=0
[ -z "$chargeSum" ] && chargeSum=0
[ -z "$dischargeSum" ] && dischargeSum=0

echo "Average frequency: $averageFrequency"
echo "Median frequency: $medianFrequency"
echo "Frequency standard deviation: $frequencyStdDev"
echo "Max frequency: $maxFrequency"
echo "Min frequency: $minFrequency"
echo "Charge actions: $chargeSum"
echo "Discharge actions: $dischargeSum"

echo "Saving results to $filename.csv..."
echo -e "$time, $batteryPods, $nBatteries, $averageFrequency, $medianFrequency, $frequencyStdDev, $maxFrequency, $minFrequency, $chargeSum, $dischargeSum" >> $filename.csv