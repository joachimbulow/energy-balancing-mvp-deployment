#!/bin/bash

# Check if the argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide the time in seconds as an argument."
    exit 1
fi

# Check if the argument is a number
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "The argument must be a positive integer."
    exit 1
fi

# Define the total time
total_time=$1
remaining_time=$total_time

# Define the progress bar
bar_length=50
bar_filled=0
printf -v bar_empty "%*s" $bar_length

# Timer loop
while [ $remaining_time -gt 0 ]; do
    # Calculate the filled part of the progress bar
    bar_filled=$(( (total_time - remaining_time + 1) * bar_length / total_time ))

    # Generate the progress bar
    printf "\r[%.*s%.*s] %02d:%02d" \
        $bar_filled "${bar_empty// /#}" \
        $((bar_length - bar_filled)) "${bar_empty}" \
        $((remaining_time / 60)) $((remaining_time % 60))

    # Pause for a second
    sleep 1

    # Decrease the remaining time
    remaining_time=$(( remaining_time - 1 ))
done

# Print a new line at the end
echo ""
