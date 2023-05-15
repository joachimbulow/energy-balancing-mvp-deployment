#!/bin/bash

# Step 1 - scale the system to the correct state (Battery pods, N_BATTERIES)
# Step 2 - reset/delete the TSO and save a time stamp
# Step 3 - wait x amount of time
# Step 4 - gather the data from Influx, perform analysis on it and save to a text file in a timely manner
# Step 5 - repeat steps 1-4 until the simulation is complete

SIMULATION_INDEX=0
SIMLATIONS_COUNT=5
SIMULATION_TIME_MINUTES=20
# Each index is a simulation parameter
BATTERY_PODS=(200 400 600 800 1000)
N_BATTERIES=(300 400 500 600 700)

# Step 1
for ((i=0; i < ${#BATTERY_PODS[@]}; i++)); do
    echo "Scaling the system to ${BATTERY_PODS[$i]} battery pods each with ${N_BATTERIES[$i]} batteries"
    ./scripts/scale-system.sh ${BATTERY_PODS[$i]} ${N_BATTERIES[$i]}
    echo "Waiting for a minute seconds to allow the system to settle"
    sleep 45
    
    # Step 2
    echo "Resetting the TSO to reset the simulation"
    ./scripts/reset-tso.sh
    sleep 10

    # Step 3
    ./scripts/sleep-timer.sh ${SIMULATION_TIME_MINUTES} 5

    # Step 4
    echo "Gathering data from InfluxDB"
    ./scripts/gather-data.sh ${SIMULATION_INDEX}
    sleep 10

    # Step 5
    SIMULATION_INDEX=$((SIMULATION_INDEX+1))
done