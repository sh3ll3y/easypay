require 'kafka'
require 'time'
require 'mysql2'
require 'json'

KAFKA_BROKERS = ENV['KAFKA_BROKERS'].split(',')
KAFKA_TOPIC = 'payment_events'
CONSUMER_GROUP = 'payment_events_consumer'
DB_CONFIG = {
  host: ENV['DATABASE_HOST'],
  username: ENV['MYSQL_USER'],
  password: ENV['MYSQL_PASSWORD'],
  database: ENV['MYSQL_DATABASE']
}
def ensure_json(value)
  return '{}' if value.nil? || value.empty?
  return value if value.is_a?(String) && valid_json?(value)
  JSON.generate(value)
rescue JSON::GeneratorError
  '{}'
end

def valid_json?(json)
  JSON.parse(json)
  true
rescue JSON::ParserError
  false
end

def inspect_event_data(event)
  puts "Inspecting event data:"
  puts event
  puts "----"
  event.each do |key, value|
    puts "  #{key}: #{value.inspect} (#{value.class})"
  end
end

begin
  kafka = Kafka.new(seed_brokers: KAFKA_BROKERS)
  consumer = kafka.consumer(group_id: CONSUMER_GROUP)
  consumer.subscribe(KAFKA_TOPIC)

  db = Mysql2::Client.new(DB_CONFIG)

  puts "Kafka consumer started. Waiting for messages...!!!!!!!$$$"

  stmt = db.prepare("INSERT INTO payment_events (payment_id, amount, status, user_id, biller_id, mobile_num, plan, metadata, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")

  consumer.each_message do |message|
    event = JSON.parse(message.value)

    inspect_event_data(event)
    
    stmt.execute(event['payment_id'], event['amount'], event['status'], event['user_id'], event['biller_id'], event['mobile_num'], ensure_json(event['plan']), ensure_json(event['metadata']), Time.parse(event['timestamp']).strftime('%Y-%m-%d %H:%M:%S'))
 
    puts "Processed event: #{event['payment_id']} - #{event['status']}"
  end
rescue Kafka::ProcessingError => e
  puts "Error processing Kafka message: #{e.message}"
  puts "Cause: #{e.cause}"
  puts "Backtrace:"
  puts e.backtrace
rescue Mysql2::Error => e
  puts "Database error: #{e.message}"
rescue JSON::ParserError => e
  puts "Error parsing message JSON: #{e.message}"
rescue => e
  puts "Unexpected error: #{e.class} - #{e.message}"
  puts "Backtrace:"
  puts e.backtrace
ensure
  consumer.stop if defined?(consumer) && !consumer.nil?
  db.close if defined?(db) && !db.nil?
end

