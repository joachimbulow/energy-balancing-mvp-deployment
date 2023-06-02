#!/bin/bash

# Step 1 - scale the system to the correct state (Battery pods, N_BATTERIES)
# Step 2 - wait x amount of time
# Step 3 - reset/delete the TSO and save a time stamp
# Step 4 - gather the data from Influx, perform analysis on it and save to a text file in a timely manner
# Step 5 - repeat steps 1-4 until the simulation is complete


######################################

# We expect you to be in the root of the project when running this file

SIMULATION_TIME_MINUTES=60
# Each index is a simulation parameter
BATTERY_PODS=(400 400 400 400)
N_BATTERIES=(1000 1000 1000 1000 800 1000 1000)

# We just assume batteries always have a wattage of 4000
PACKET_TIME_S=(60 180 240 300)
REQUEST_INTERVAL_SECONDS=(60 60 60 60 60 60 60 60 60 60)



for ((i=0; i < ${#BATTERY_PODS[@]}; i++)); do
    echo "╔═╗┌─┐┌─┐┬  ┌─┐";
    echo "╚═╗│  ├─┤│  ├┤ ";
    echo "╚═╝└─┘┴ ┴┴─┘└─┘";

    ./scripts/scale-system.sh ${BATTERY_PODS[$i]} ${N_BATTERIES[$i]} ${PACKET_TIME_S[$i]} ${REQUEST_INTERVAL_SECONDS[$i]}

    echo "Waiting a while to allow the system to settle"
    ./scripts/sleep-timer.sh 140
    
    echo "╦═╗┌─┐┌─┐┌─┐┌┬┐";
    echo "╠╦╝├┤ └─┐├┤  │ ";
    echo "╩╚═└─┘└─┘└─┘ ┴ ";
    
    echo "Resetting the TSO to reset the simulation... we continue once it is has been deleted..."
    ./scripts/reset-tso.sh
    
    ./scripts/sleep-timer.sh 5

    # For MacOS u need coreutils (install with `brew install coreutils`)
    time=$(gdate +%s%N)
    echo "Starting the simulation at time: $time ..."

    echo "┬─┐┬ ┬┌┐┌  ┌─┐┬┌┬┐┬ ┬┬  ┌─┐┌┬┐┬┌─┐┌┐┌";
    echo "├┬┘│ ││││  └─┐│││││ ││  ├─┤ │ ││ ││││";
    echo "┴└─└─┘┘└┘  └─┘┴┴ ┴└─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘";

    ./scripts/sleep-timer.sh $((SIMULATION_TIME_MINUTES * 60))

    echo "╔═╗┌─┐┬─┐┌─┐┌─┐┌─┐";
    echo "╚═╗│  ├┬┘├─┤├─┘├┤ ";
    echo "╚═╝└─┘┴└─┴ ┴┴  └─┘";

    echo "Gathering data from InfluxDB..."
    ./scripts/scrape-influx.sh $time "mysimulation" ${BATTERY_PODS[$i]} ${N_BATTERIES[$i]}
    ./scripts/sleep-timer.sh 10

    echo "╦═╗┌─┐┌─┐┌─┐┌─┐┌┬┐";
    echo "╠╦╝├┤ ├─┘├┤ ├─┤ │ ";
    echo "╩╚═└─┘┴  └─┘┴ ┴ ┴ ";

    # Reset the system to "factory defaults"
    ./scripts/scale-system.sh 0 0 0 0
    echo "Resetting the system... please wait..."
    ./scripts/sleep-timer.sh 120

done