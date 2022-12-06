/pulsar/bin/pulsar-admin tenants create armada
/pulsar/bin/pulsar-admin namespaces create armada/armada
/pulsar/bin/pulsar-admin topics delete-partitioned-topic persistent://armada/armada/events -f > /dev/null 2>&1 || true
/pulsar/bin/pulsar-admin topics create-partitioned-topic persistent://armada/armada/events -p 2

# Disable topic auto-creation to ensure an error is thrown on using the wrong topic
# (Pulsar automatically created the public tenant and default namespace).
/pulsar/bin/pulsar-admin namespaces set-auto-topic-creation public/default --disable
/pulsar/bin/pulsar-admin namespaces set-auto-topic-creation armada/armada --disable

echo 'Pulsar setup completed'
