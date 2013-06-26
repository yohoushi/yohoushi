source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.0.rc2'
gem 'mysql2'
gem 'sass-rails', '~> 4.0.0.rc2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0' # compressor for JavaScript assets
gem 'therubyracer', platforms: :ruby # Embeded V8 Javascript Interpreter (required for sprockets, asset pipeline)
gem 'jquery-rails'
gem 'jquery-ui-rails'
# gem 'turbolinks'
# gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'unicorn'

gem 'slim', :require => 'slim-rails'
gem "slim-rails"
gem 'twitter-bootstrap-rails'
gem 'bootstrap-sass' # http://d.hatena.ne.jp/sandmark/20120321/1332292995
gem 'bootswatch-rails'
gem 'bootstrap-datetimepicker-rails'
gem 'newrelic_rpm'

gem 'draper' # decorator(view-model)
gem "settingslogic"
gem 'growthforecast-client', git: 'https://github.com/sonots/growthforecast-client.git', branch: 'more_api'
gem 'multiforecast-client', git: 'https://github.com/sonots/multiforecast-client.git'
gem 'acts-as-taggable-on' # tagging
gem 'ancestry', git: 'https://github.com/sonots/ancestry.git', branch: 'sonots' # tree structured model
gem 'ancestry-treeview' # an extensional ancestry gem created just for yohoushi

group :worker do
  gem 'serverengine'
end

group :bin do
  gem 'thor'
end

group :development do
  gem 'capistrano'
  gem 'foreman'
  gem 'yard' # document genration
  gem 'better_errors' # sophisticated error view
  gem 'binding_of_caller' # add irb/pry on better_rails view
  gem 'bullet' # warn N+1 queries
end

group :development, :test do
  gem 'spring' # rails application preloader
  gem 'rspec-rails' # rails g rspec:model
  gem 'guard'
  gem 'guard-rspec'
  gem 'fabrication'
  gem 'webmock', :require => false

  # for debug
  gem 'debugger2', '~> 1.0.0.beta1'
  gem 'pry'
  gem 'pry-nav'
  gem 'ir_b', :require => 'ir_b/pry' # `ir b` instead of `binding.pry` (short)
  gem 'tapp' # 'foo'.tapp   #=> `pp 'foo'` and return 'foo'
  gem 'gem-open' # gem open [gem]

  # metrics
  gem 'simplecov-rcov', :require => false
end
