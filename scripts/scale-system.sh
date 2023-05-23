#!/bin/bash

BATTERY_PODS=$1
N_BATTERIES=$2
PACKET_TIME_S=$3
REQUEST_INTERVAL_SECONDS=$4

echo "Scaling the batteries to $BATTERY_PODS battery pods with $N_BATTERIES batteries - packet time: $PACKET_TIME_S - request interval: $REQUEST_INTERVAL_SECONDS"
kubectl patch deployment battery -n energy-balancing-mvp --patch "spec: { template: { spec: { containers: [ { name: "battery", env: [ { name: "N_BATTERIES", value: '${N_BATTERIES}' }, { name: "PACKET_TIME_S", value: '${PACKET_TIME_S}' }, { name: "REQUEST_INTERVAL_SECONDS", value: '${REQUEST_INTERVAL_SECONDS}' } ] } ] } } }"
kubectl scale deployment battery --replicas=${BATTERY_PODS}

echo "Patching the TSO to have a packet time of $PACKET_TIME_S and a packet power of $REQUEST_INTERVAL_SECONDS"
kubectl patch deployment tso -n energy-balancing-mvp --patch "spec: { template: { spec: { containers: [ { name: "tso", env: [ { name: "PACKET_TIME_S", value: '${PACKET_TIME_S}' }, { name: "PACKET_POWER_W", value: '${REQUEST_INTERVAL_SECONDS}' } ] } ] } } }"


# This should not be necessary
#./scripts/reset-all-batteries.sh
