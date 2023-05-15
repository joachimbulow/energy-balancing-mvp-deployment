#!/bin/bash

total_duration_minutes=$1  # Total duration in minutes
sleep_interval_minutes=$2  # Sleep interval in minutes

# Convert total_duration_minutes to seconds
total_duration_seconds=$((total_duration_minutes * 60))

# Loop until total_duration_seconds is reached
current_duration=0
while (( current_duration < total_duration_seconds )); do
  # Calculate remaining duration
  remaining_duration_seconds=$((total_duration_seconds - current_duration))
  remaining_duration_minutes=$((remaining_duration_seconds / 60))
  
  echo "Sleeping for ${sleep_interval_minutes} minute(s) - ${remaining_duration_minutes} minute(s) remaining..."
  sleep ${sleep_interval_minutes}m
  
  # Increment current duration
  current_duration=$((current_duration + (sleep_interval_minutes * 60)))
done

echo "Sleep completed for ${total_duration_minutes} minute(s)."
