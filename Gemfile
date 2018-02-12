ruby '2.5.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.0'
# Use Puma/Passenger as the app server
gem 'puma', '~> 3.0'
# Use Redis for caching
gem 'redis', '~> 3.0'
gem 'redis-rails', '~> 5.0'
# Use Sidekiq fo background jobs
gem 'sidekiq', '~> 5.1'
# Use Pry instead of IRB
gem 'pry', '~> 0.11.0', require: false
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# JSON
gem 'multi_json', '~> 1.0'
gem 'oj', '~> 3.0'
gem 'json-schema', '~> 2.8'
gem 'jsonapi-resources', '~> 0.9.0'

# Use Ember on the frontend
gem 'ember-cli-rails', '~> 0.10.0'

group :development, :test do
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug', '~> 3.5.0'
  gem 'dotenv-rails', '~> 2.2.0'
  gem 'factory_bot_rails', '~> 4.8.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end
