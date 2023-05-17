#!/bin/bash

# Step 1 - scale the system to the correct state (Battery pods, N_BATTERIES)
# Step 2 - wait x amount of time
# Step 3 - reset/delete the TSO and save a time stamp
# Step 4 - gather the data from Influx, perform analysis on it and save to a text file in a timely manner
# Step 5 - repeat steps 1-4 until the simulation is complete

SIMULATION_INDEX=0
SIMULATION_TIME_MINUTES=10
# Each index is a simulation parameter
BATTERY_PODS=(50 100 100 200 400 600 800 1000)
N_BATTERIES=(50 100 200 200 400 500 800 1000)

# We expect you to be in the root of the project when running this file

for ((i=0; i < ${#BATTERY_PODS[@]}; i++)); do
    echo "╔═╗┌─┐┌─┐┬  ┌─┐";
    echo "╚═╗│  ├─┤│  ├┤ ";
    echo "╚═╝└─┘┴ ┴┴─┘└─┘";

    echo "Scaling to ${BATTERY_PODS[$i]} battery pods - each with ${N_BATTERIES[$i]} batteries"
    ./scripts/scale-system.sh ${BATTERY_PODS[$i]} ${N_BATTERIES[$i]}

    echo "Waiting a while to allow the system to settle"
    ./scripts/sleep-timer.sh 120
    

    echo "╦═╗┌─┐┌─┐┌─┐┌┬┐";
    echo "╠╦╝├┤ └─┐├┤  │ ";
    echo "╩╚═└─┘└─┘└─┘ ┴ ";
    
    echo "Resetting the TSO to reset the simulation... we continue once it is has been deleted..."
    ./scripts/reset-tso.sh
    
    ./scripts/sleep-timer.sh 5

    # For MacOS u need coreutils (install with `brew install coreutils`)
    time=$(gdate +%s%N)
    echo "Starting the simulation at time: $time"

    echo "┬─┐┬ ┬┌┐┌  ┌─┐┬┌┬┐┬ ┬┬  ┌─┐┌┬┐┬┌─┐┌┐┌";
    echo "├┬┘│ ││││  └─┐│││││ ││  ├─┤ │ ││ ││││";
    echo "┴└─└─┘┘└┘  └─┘┴┴ ┴└─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘";

    ./scripts/sleep-timer.sh $((SIMULATION_TIME_MINUTES * 60))

    echo "╔═╗┌─┐┬─┐┌─┐┌─┐┌─┐";
    echo "╚═╗│  ├┬┘├─┤├─┘├┤ ";
    echo "╚═╝└─┘┴└─┴ ┴┴  └─┘";

    echo "Gathering data from InfluxDB"
    ./scripts/scrape-influx.sh $time "mysimulation" ${BATTERY_PODS[$i]} ${N_BATTERIES[$i]}
    sleep 10

    echo "╦═╗┌─┐┌─┐┌─┐┌─┐┌┬┐";
    echo "╠╦╝├┤ ├─┘├┤ ├─┤ │ ";
    echo "╩╚═└─┘┴  └─┘┴ ┴ ┴ ";
    SIMULATION_INDEX=$((SIMULATION_INDEX + 1))

done