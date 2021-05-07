# Copyright 2019 Adevinta

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.6'
gem 'actionpack', '>= 5.2.4.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.13'
# Added Postgres support
gem 'pg', '~> 0.18.4'
# In order to use UUID as ids
gem 'ar-uuid', '~> 0.1.2'
gem 'uuid', '~> 2.3', '>= 2.3.8'
# Use Puma as the app server
gem 'puma', '~> 3.12', '>= 3.12.6'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Active Model Serializer
gem 'active_model_serializers', '~> 0.10.4'
# Configure environment with dotenv files
gem 'dotenv-rails', '~> 2.2', '>= 2.2.0'
# DogStatsD
gem 'dogstatsd-ruby', '~> 4.8', '>= 4.8.1', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0.6', platform: :mri
  gem 'webmock', '~> 2.3.2', platform: :mri
  gem 'simplecov', '~> 0.17.0'
  gem 'codecov', '~> 0.2.8'
end

group :development do
  gem 'listen', '~> 3.0.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.1'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

# manage views from migrations
gem 'scenic', '~> 1.4.1'

gem "nokogiri", ">= 1.11.0"
