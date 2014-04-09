source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'
# gem 'sqlite3' # Use sqlite (>= 3.6.16) as the database
gem 'mysql2' # Use myql as the database

# When used sass-rails 4.0.0 with Rails4.1.0, rake assets:precompile exited with "undefined method `environment' for nil:NilClass"
# To fix this, I updated it's version ~> 4.0.2
# c.f. http://stackoverflow.com/questions/22392862/undefined-method-environment-for-nilnilclass-when-importing-bootstrap
gem 'sass-rails', '~> 4.0.2' 

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0' # compressor for JavaScript assets
gem 'therubyracer', platforms: :ruby # Embeded V8 Javascript Interpreter (required for sprockets, asset pipeline)
gem 'jquery-rails'
gem 'jquery-ui-rails'
# gem 'turbolinks'
# gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'unicorn'
gem 'god' # a process monitoring framework in ruby

gem 'slim', :require => 'slim-rails'
gem "slim-rails"
gem 'twitter-bootstrap-rails'
gem 'bootstrap-sass' # http://d.hatena.ne.jp/sandmark/20120321/1332292995
gem 'bootswatch-rails'
gem 'bootstrap-datetimepicker-rails'
gem 'font-awesome-rails' # Font-Awesome web fonts
# gem 'newrelic_rpm'

gem 'draper' # decorator(view-model)
gem 'acts_as_parameter_object' # Introduce parameter object, cf. Refactoring: Ruby Edition
gem "settingslogic"
gem 'growthforecast-client'
gem 'multiforecast-client'
gem 'acts-as-taggable-on' # tagging
gem 'ancestry', git: 'https://github.com/sonots/ancestry.git', branch: 'yohoushi' # tree structured model
gem "kaminari" # paginator
gem 'rack-streaming-proxy', require: 'rack/streaming_proxy'

group :serverengine do
  gem 'serverengine'
end

group :bin do
  gem 'thor'
end

group :development do
  gem 'yard' # document genration
  gem 'better_errors' # sophisticated error view
  gem 'binding_of_caller' # add irb/pry on better_rails view
  gem 'bullet' # warn N+1 queries
  gem 'rack-mini-profiler' # simple profiler
end

group :test do
  gem 'rspec-rails' # rails g rspec:model
  gem 'webmock', :require => false
  gem 'guard-rspec' # automatically run specs
end

group :development, :test do
  gem 'spring' # rails application preloader
  gem 'guard'

  # for debug
  gem 'byebug' # ruby 2.0 debugger
  gem 'pry'
  gem 'pry-byebug'
  gem 'tapp' # 'foo'.tapp   #=> `pp 'foo'` and return 'foo'
  gem 'gem-open' # gem open [gem]
end
