require 'mysql2'

DB_CONFIG = {
  host: ENV['DATABASE_HOST'],
  username: ENV['MYSQL_USER'],
  password: ENV['MYSQL_PASSWORD']
}

begin
  client = Mysql2::Client.new(DB_CONFIG)
  
  client.query("CREATE DATABASE IF NOT EXISTS analytics_db")
  puts "analytics_db database created or already exists."
  
  client.query("GRANT ALL PRIVILEGES ON analytics_db.* TO 'root'@'%'")
  client.query("FLUSH PRIVILEGES")
  puts "Privileges granted to root user."
rescue Mysql2::Error => e
  puts "Error creating database: #{e.message}"
  exit(1)
ensure
  client.close if client
end
