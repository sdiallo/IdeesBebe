source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>=4.0.0'
gem 'devise'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'rails_12factor', group: :production
gem 'unicorn'
gem 'delayed_job_active_record'
gem 'carrierwave'
gem 'mini_magick'
gem 'cloudinary'

gem 'cancan'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'haml-rails'
gem 'simple_form'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'coveralls', require: false

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'annotate', ">=2.6.0"
  gem 'bullet'
  gem "better_errors"
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 2.0'
  gem "factory_girl_rails", "~> 4.0"
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'database_cleaner'
  gem 'selenium-webdriver', '~> 2.35.1'
end

ruby '2.0.0'
