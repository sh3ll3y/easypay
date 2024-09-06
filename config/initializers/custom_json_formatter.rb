class CustomJsonFormatter < LogStashLogger::Formatter::JsonLines
  def call(severity, time, progname, message)
    super(severity, time, progname, message).merge!(
      "custom_timestamp" => Time.now.iso8601
    )
  end
end
