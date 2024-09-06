KAFKA_PRODUCER = Kafka.new(
  seed_brokers: ['kafka:29092'],
  client_id: "payment_service"
)
