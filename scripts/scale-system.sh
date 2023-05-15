#!/bin/bash

BATTERY_PODS=$1
N_BATTERIES=$2

kubectl patch deployment battery -n energy-balancing-mvp --patch "$(cat patch.yaml)"

kubectl scale deployment battery --replicas=${BATTERY_PODS}