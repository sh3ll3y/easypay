Rails.application.config.after_initialize do
  Rails.logger = Rails.application.config.logger
  ActiveSupport::TaggedLogging.new(Rails.logger)
end
