Rails.application.config.after_initialize do
  puts "Final logger class: #{Rails.logger.class}"
  puts "Final logger formatter class: #{Rails.logger.formatter.class}"
  puts "Is LogStashLogger? #{Rails.logger.is_a?(LogStashLogger)}"
  puts "Is TaggedLogging? #{Rails.logger.is_a?(ActiveSupport::TaggedLogging)}"
  
  Rails.logger.debug({ message: "Debug message from initializer", custom_field: "test" })
  Rails.logger.info({ message: "Info message from initializer", custom_field: "test" })
  Rails.logger.warn({ message: "Warn message from initializer", custom_field: "test" })
  Rails.logger.error({ message: "Error message from initializer", custom_field: "test" })
end
