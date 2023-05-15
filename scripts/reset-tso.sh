#!/bin/bash

echo "Deleting TSO..."
kubectl get pods --no-headers=true -o custom-columns=:metadata.name | grep tso | xargs kubectl delete pod