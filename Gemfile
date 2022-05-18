# Copyright 2019 Adevinta

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4.2'
# Added Postgres support
gem 'pg', '~> 1.3'
# In order to use UUID as ids
gem 'ar-uuid', '~> 0.2.2'
gem 'uuid', '~> 2.3.9'
# Use Puma as the app server
gem 'puma', '~> 5.6'

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
  gem 'codecov', '~> 0.6.0'
end

group :development do
  gem 'listen', '~> 3.0.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 3.0.0'
end

# manage views from migrations
gem 'scenic', '~> 1.6.0'

gem "nokogiri", ">= 1.13.6"
