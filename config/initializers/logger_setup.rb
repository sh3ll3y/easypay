Rails.application.config.after_initialize do
  puts "Final logger class: #{Rails.logger.class}"
  puts "Final logger formatter class: #{Rails.logger.formatter.class}"
  Rails.logger.debug "Debug message from initializer"
  Rails.logger.info "Info message from initializer"
  Rails.logger.warn "Warn message from initializer"
  Rails.logger.error "Error message from initializer"
end
