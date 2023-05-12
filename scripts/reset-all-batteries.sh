echo "Deleting all batteries..."
kubectl get pods --no-headers=true -o custom-columns=:metadata.name | grep battery | xargs kubectl delete pod