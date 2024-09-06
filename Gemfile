source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.9'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.8'
# Use sqlite3 as the database for Active Record


#custom
gem 'mysql2', '~> 0.5.3'
gem 'ffi', '~> 1.15.0'

gem 'redis', '~> 4.0'        # Redis gem to connect to the Redis container
gem 'redis-rails', '~> 5.0.2'

gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'kaminari'
gem 'sidekiq'                # Sidekiq for background job processing
gem 'sassc', '~> 2.1.0'
gem 'logstash-logger', '~> 0.26.1', require: false
gem 'blueprinter'
gem 'aws-sdk-s3', '~> 1.0'
group :development, :test do
  gem 'dotenv-rails'
end
group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails', '~> 5.2.0'
  gem 'rails-controller-testing'
end
gem 'ruby-kafka'
gem 'rack-attack'
gem 'sidekiq-cron', '~> 1.2'




gem 'elasticsearch-model', '~> 7.0'    # Integrate Elasticsearch with Rails models
gem 'elasticsearch-rails', '~> 7.0'    # Helper to integrate Elasticsearch with Rails
# gem 'redis-rails', '~> 5.0'  # To use Redis as cache store or for ActionCable
# group :development do
#   gem 'bullet', '~> 6.0'      # Detect N+1 queries and optimize performance
# end
# gem 'sqlite3'

# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
