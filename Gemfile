# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', '>= 1.4.2', :require => false
gem 'bootstrap_form'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'devise'
gem 'devise-i18n'
gem 'font-awesome-sass'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'mysql2'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'rails_12factor'
gem 'rails-i18n'
gem 'ransack'
gem 'rename'
gem 'sass-rails', '>= 6'
gem 'serviceworker-rails'
gem 'toastr-rails'
gem 'uglifier'
gem 'webpacker', '~> 4.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', :platforms => %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'pre-commit'
  gem 'bullet'
  gem 'rubocop', :require => false
  gem 'rubocop-performance', :require => false
  gem 'rubocop-rails', :require => false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', :platforms => %i[mingw mswin x64_mingw jruby]

group :production, :staging do
  gem 'dotenv-rails'
  gem 'unicorn'
end
