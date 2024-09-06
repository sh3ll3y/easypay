require "active_support/core_ext/integer/time"
require 'logstash-logger'



Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.





  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  config.hosts << "web"

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  config.cache_store = :redis_cache_store, { url: "redis://#{ENV['REDIS_HOST']}:6379/1" }

  config.consider_all_requests_local = true
  config.file_watcher = ActiveSupport::FileUpdateChecker
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  puts "LogStashLogger class: #{LogStashLogger.name}"

  logstash_config = {
    type: :stdout,
    formatter: LogStashLogger::Formatter::JsonLines.new
  }

  logger = LogStashLogger.new(logstash_config)
  puts "Direct LogStashLogger instance class: #{logger.class}"
  
  # config.logger = ActiveSupport::TaggedLogging.new(logger)
  logstash_logger = LogStashLogger.new(
  type: :tcp,
  host: 'logstash',
  port: 5044,
  sync: true
)
  tagged_logstash_logger = ActiveSupport::TaggedLogging.new(logstash_logger)
  config.logger = tagged_logstash_logger

  config.log_level = :debug

  puts "Config logger class: #{config.logger.class}"
  puts "Config logger formatter class: #{config.logger.formatter.class}"

  # Force Rails to use this logger
  Rails.logger = config.logger
  ActiveRecord::Base.logger = config.logger
  ActionController::Base.logger = config.logger
  ActionView::Base.logger = config.logger

  puts "Rails.logger class: #{Rails.logger.class}"
  puts "Rails.logger formatter class: #{Rails.logger.formatter.class}"

end

