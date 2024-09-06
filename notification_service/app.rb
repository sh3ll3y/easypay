require 'sinatra'
require_relative 'message_adapters'
require 'sinatra/streaming'
require 'kafka'
require 'json'
require 'logger'

set :server, :puma
set :bind, '0.0.0.0'
set :port, 4567
set :logger, Logger.new(STDOUT)

KAFKA_BROKERS = ENV['KAFKA_BROKERS'] || 'kafka:29092'
KAFKA_TOPIC = ENV['KAFKA_TOPIC'] || 'notification_events'

kafka = Kafka.new([KAFKA_BROKERS])

configure do
  set :server_settings, {
    threads: '0:16',
    workers: 0,
    timeout: 0
  }
end

get '/' do
  <<-HTML
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kafka Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">

    <style>
        html, body, pre {
            font-family: 'Space Mono', monospace;
        }

        html, body {
           font-family: 'Space Mono', monospace;
        }

        body {
            background-color: #333;
            color: #fff;
        }
        .card {
            background-color: #343a40;
            border-color: #dc3545;
            margin-bottom: 20px;
            height: 100%;
        }
        .card-header {
            background-color: #dc3545;
            color: #fff;
        }
        .card-body {
            display: flex;
            flex-direction: column;
        }
        .message-content {
            flex-grow: 1;
            overflow-y: auto;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Notification Service Messages</h1>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <div class="col">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">SMS Format</h5>
                    </div>
                    <div class="card-body">
                        <pre id="sms-message" class="message-content mb-0"></pre>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Push Notification Format</h5>
                    </div>
                    <div class="card-body">
                        <pre id="push-message" class="message-content mb-0"></pre>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Email Format</h5>
                    </div>
                    <div class="card-body">
                        <pre id="email-message" class="message-content mb-0"></pre>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var eventSource = new EventSource("/events");
        var smsContainer = document.getElementById("sms-message");
        var pushContainer = document.getElementById("push-message");
        var emailContainer = document.getElementById("email-message");

        eventSource.onmessage = function(e) {
            console.log("Received event:", e.data);
            var eventData = JSON.parse(e.data);
            smsContainer.textContent = eventData.sms;
            pushContainer.textContent = eventData.push;
            emailContainer.textContent = eventData.email;
        };

        eventSource.onerror = function(e) {
            console.error("EventSource failed:", e);
        };

        eventSource.onopen = function(e) {
            console.log("EventSource connection opened");
        };
    </script>
</body>
</html>
  HTML
end

get '/events', provides: 'text/event-stream' do
  content_type 'text/event-stream'
  headers 'Cache-Control' => 'no-cache'
  headers 'Connection' => 'keep-alive'
  stream(:keep_open) do |out|
    settings.logger.info "Starting event stream"
    consumer = kafka.consumer(group_id: "kafka-listener-group-#{Time.now.to_i}")
    consumer.subscribe(KAFKA_TOPIC)
    begin
      consumer.each_message do |message|
        settings.logger.info "Received message: #{message.value}"
        parsed_message = JSON.parse(message.value)
        formatted_messages = MessageFormatter.format(parsed_message)
        out << "data: #{JSON.generate(formatted_messages)}\n\n"
        settings.logger.info "Sent formatted messages to client"
        out.flush
      end
    rescue Kafka::ProcessingError => e
      settings.logger.error "Kafka processing error: #{e.class} - #{e.message}"
      settings.logger.error "Backtrace:\n#{e.backtrace.join("\n")}"
      # Attempt to reconnect or handle the error as needed
      sleep 1
      retry
    rescue JSON::ParserError => e
      settings.logger.error "JSON parsing error: #{e.class} - #{e.message}"
      settings.logger.error "Backtrace:\n#{e.backtrace.join("\n")}"
    rescue StandardError => e
      settings.logger.error "Unexpected error: #{e.class} - #{e.message}"
      settings.logger.error "Backtrace:\n#{e.backtrace.join("\n")}"
    ensure
      consumer.stop
      settings.logger.info "Kafka consumer stopped"
    end
  end
end

get '/test-events' do
  content_type 'text/event-stream'
  headers 'Cache-Control' => 'no-cache'
  headers 'Connection' => 'keep-alive'

  stream(:keep_open) do |out|
    loop do
      out << "data: #{Time.now}\n\n"
      out.flush
      sleep 1
    end
  end
end
