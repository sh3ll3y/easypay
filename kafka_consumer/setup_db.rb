require 'mysql2'

DB_CONFIG = {
  host: ENV['DATABASE_HOST'],
  username: ENV['MYSQL_USER'],
  password: ENV['MYSQL_PASSWORD'],
  database: ENV['MYSQL_DATABASE']
}

begin
  client = Mysql2::Client.new(DB_CONFIG)

  client.query("
    CREATE TABLE IF NOT EXISTS payment_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id VARCHAR(255) NOT NULL,
    amount VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    biller_id VARCHAR(255) NOT NULL,
    mobile_num VARCHAR(255) NOT NULL,
    plan JSON,
    metadata JSON,
    timestamp DATETIME
  )")

  puts "payment_events table created or already exists in the analytics_db."
rescue Mysql2::Error => e
  puts "Error setting up database: #{e.message}"
  exit(1)
ensure
  client.close if client
end
