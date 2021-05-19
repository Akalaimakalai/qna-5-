source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# ===MY GEMS===

# Instead erb
gem 'slim-rails'
# Authentication
gem 'devise'
# Authentication through other providers (GitHub, Facebook, etc.)
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
# JS framework
gem 'jquery-rails'
# Amazon S3 cloud server
gem "aws-sdk-s3", require: false
# ENV_VARIABLES
gem 'dotenv-rails'
# Cocoon makes it easier to handle nested forms.
gem "cocoon"
# GitClient
gem "octokit", "~> 4.0"
# Skim is the Slim templating engine
gem "skim"
# Add params to views
gem 'gon'
# Authorization
gem 'cancancan'
# OAuth provider
gem 'doorkeeper'
# Serializers for worcking with json
gem 'active_model_serializers', '~> 0.10'
# Render json much more faster
gem 'oj'
# Sidekiq is a full-featured background processing framework for Ruby. Work with ActiveJob
gem 'sidekiq', '< 6'
# Sinatra is for Sidekiq's web interface
gem 'sinatra', require: false
# Whenever is a Ruby gem that provides a clear syntax for writing and deploying cron jobs.
gem 'whenever', require: false
# Sphinx is a very fast search engine
gem 'mysql2'
gem 'thinking-sphinx'
# JavaScript runtime
gem 'mini_racer'
# App server
gem 'unicorn'
# User redis for cache
gem 'redis-rails'

# ---end---

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # ===MY GEMS===

  # New test-gem
  gem 'rspec-rails', '~> 4.0.0.beta3'
  # Gem for creating test dataset
  gem 'factory_bot_rails'
  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock'
  # Upgraded byebug (binding.pry)
  gem 'pry-rails'
  gem 'pry-byebug'


  # ---end---
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # ===MY GEMS===

  # Auto opening letters from ActionMailer
  gem "letter_opener"
  # Deploy
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false

  # ---end---
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  # ===MY GEMS===

  # Test validations, associations, etc.
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  # Byebug for tests (save_and_open_page)
  gem 'launchy'
  # Instead gem 'chromedriver-helper'
  gem 'webdrivers', '~> 4.0'
  # Opening letters in tests
  gem 'capybara-email'
  # Use it in sphinx_helper.rb
  gem 'database_cleaner-active_record'

  # ---end---
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
