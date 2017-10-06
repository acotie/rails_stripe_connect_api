source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'sqlite3'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# necessary
gem 'stripe'
gem 'dotenv-rails'
gem 'slim-rails'
gem 'html2slim'
gem 'kaminari'
#gem 'newrelic_rpm'
#gem 'bullet'
#gem 'unicorn'
#gem 'unicorn-worker-killer'

# image upload
#gem 'carrierwave'
#gem "mini_magick"
#gem "fog-aws"

# Auth
gem 'devise'
gem 'devise_token_auth'
gem 'devise-bootstrap-views'

# API
gem 'grape'
gem 'grape-entity'
gem 'grape-kaminari'
#gem 'rack-cors'

gem 'grape-swagger'
gem 'grape-swagger-ui'
gem 'grape-swagger-rails'
gem 'grape-swagger-entity'

gem 'rails_admin'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'rspec-rails'
  gem 'factory_girl_rails'  # dummy data
  gem 'faker'               # test data
  gem 'i18n_generators'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
