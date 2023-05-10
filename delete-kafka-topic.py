from confluent_kafka.admin import AdminClient, NewTopic

conf = {'bootstrap.servers': '10.0.235.86:9092'}
admin_client = AdminClient(conf)

topic_names = ["pem_responses", "frequency_measurements", "inertia_measurements", "pem_requests", "pem_responses"]
admin_client.delete_topics(topic_names)