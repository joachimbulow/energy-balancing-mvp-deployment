#!/bin/bash

KAFKA_POD_NAME="mvp-cluster-kafka-0"
NAMESPACE="energy-balancing-mvp"

# Execute the script inside the Kafka pod
kubectl exec $KAFKA_POD_NAME -n $NAMESPACE -- /bin/bash -c "/opt/kafka/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list | while read GROUP; do \
STATUS=\$(/opt/kafka/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group \"\$GROUP\" | awk '{print \$6}'); \
if [ \"\$STATUS\" = \"Empty\" ]; then \
echo \"Deleting consumer group: \$GROUP\"; \
/opt/kafka/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --delete --group \"\$GROUP\"; \
else \
echo \"Skipping active consumer group: \$GROUP\"; \
fi; \
done"
