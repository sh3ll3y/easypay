Rails.application.config.after_initialize do
  puts "Logger class: #{Rails.logger.class}"
  Rails.logger.debug "This is a debug message from initializer"
  Rails.logger.info "This is an info message from initializer"
  Rails.logger.warn "This is a warn message from initializer"
  Rails.logger.error "This is an error message from initializer"
end
