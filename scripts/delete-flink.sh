# This makes argo try to delete the managed resource, which will be possible once the job is gone
argocd app delete flink

kubectl -n energy-balancing-mvp get jobs --no-headers=true -o custom-columns=:metadata.name | grep flink | xargs kubectl delete job

kubectl -n energy-balancing-mvp get pods --no-headers=true -o custom-columns=:metadata.name | grep flink | xargs kubectl delete pod
