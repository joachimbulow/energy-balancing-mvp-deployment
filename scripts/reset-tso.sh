#!/bin/bash

# Start the spinner in the background
(
  spinner="/|\\-/"; 
  while :; do 
    for i in {1..4}; do 
      echo -n "${spinner:$i:1}" 
      echo -en "\010" 
      sleep 1 
    done 
  done
) &

# Remember its PID so it can be killed later
SPINNER_PID=$!

# Redirect its output to avoid messing up the script's output
exec 2>/dev/null

# Run the command
kubectl get pods --no-headers=true -o custom-columns=:metadata.name | grep tso | xargs kubectl delete pod

# Kill the spinner now that the long-running command is done
kill $SPINNER_PID

# Get the output back
exec 2>&1