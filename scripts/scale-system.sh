#!/bin/bash

BATTERY_PODS=$1
N_BATTERIES=$2

kubectl patch deployment battery -n energy-balancing-mvp --patch "spec: { template: { spec: { containers: [ { name: "battery", env: [ { name: "N_BATTERIES", value: '${N_BATTERIES}' } ] } ] } } }"

kubectl scale deployment battery --replicas=${BATTERY_PODS}

# This should not be necessary
#./scripts/reset-all-batteries.sh