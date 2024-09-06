require 'sidekiq'
require 'sidekiq-cron'

redis_conn = { url: "redis://#{ENV['REDIS_HOST'] || 'redis-cache'}:6379/1" }

Sidekiq.configure_server do |config|
  config.redis = redis_conn
  config.logger = Rails.logger
end

Sidekiq.configure_client do |config|
  config.redis = redis_conn
  config.logger = Rails.logger
end


Rails.application.config.active_job.queue_adapter = :sidekiq

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"
    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end
