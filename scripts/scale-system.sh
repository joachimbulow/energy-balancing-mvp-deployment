#!/bin/bash

BATTERY_PODS=$1
N_BATTERIES=$2

kubectl patch deployment battery -n energy-balancing-mvp --patch "$(cat ./scripts/patch-batteries.yaml)"

kubectl scale deployment battery --replicas=${BATTERY_PODS}

# This should not be necessary
#./scripts/reset-all-batteries.sh