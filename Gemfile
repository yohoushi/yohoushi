source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.rc1'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

ruby '2.0.0'
gem "settingslogic"
gem 'slim', :require => 'slim-rails'
gem "slim-rails", "~> 1.1.0"
gem 'growthforecast-client', git: 'https://github.com/sonots/growthforecast-client.git', branch: 'more_api'
gem 'multiforecast-client', git: 'git@github.dena.jp:dena/multiforecast-client.git'
# http://d.hatena.ne.jp/sandmark/20120321/1332292995
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'acts-as-taggable-on'
gem 'ancestry'

group :development do
  gem 'twitter-bootstrap-rails'
  gem 'capistrano'
  gem 'foreman'
end

group :development, :test do
  gem 'spring'
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'fabrication'
  gem 'webmock', :require => false

  # for debug
  gem 'debugger2', '~> 1.0.0.beta1'
  gem 'pry'
  gem 'pry-nav'
  gem 'ir_b'
  gem 'tapp'
  gem 'gem-open'

  # metrics
  gem 'simplecov-rcov', :require => false
end
