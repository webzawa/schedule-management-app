# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'

gem 'bootstrap-sass'
gem 'jquery-rails'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', :require => false

gem 'coffee-rails'
# gem 'jquery-turbolinks'
gem 'uglifier'

# gem 'jquery-ui-rails'
# gem 'bootstrap_form'
# gem 'bootstrap-datetimepicker-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', :platforms => %i[mri mingw x64_mingw]
  gem 'mysql2'
  # N+1問題検知用
  gem 'bullet'

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'pre-commit'
  gem 'rubocop', :require => false
  gem 'rubocop-performance', :require => false
  gem 'rubocop-rails', :require => false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # gem "onkcop", require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'guard'
  gem 'guard-minitest'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rails-controller-testing'
  gem 'webdrivers'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => %i[mingw mswin x64_mingw jruby]

gem 'bootstrap_form'
gem 'devise'
gem 'devise-i18n'
gem 'font-awesome-sass'
gem 'rails_12factor'
gem 'rails-i18n'
gem 'ransack'
gem 'toastr-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'rename'
