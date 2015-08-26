source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
# gem 'sqlite3' # Use sqlite (>= 3.6.16) as the database
gem 'mysql2', '~> 0.3.13' # Use myql as the database

# On upgrading rails 4.2.4, e fixed sass-rails' version because we got an error
# `NameError: uninitialized constant Sass::Script` on travis.
# ref. https://github.com/rails/sass-rails/issues/315
#      http://stackoverflow.com/questions/29716284/uninitialized-constant-sassscript-nameerror
gem 'sass-rails', '~> 5.0.3'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0' # compressor for JavaScript assets
gem 'therubyracer', platforms: :ruby # Embeded V8 Javascript Interpreter (required for sprockets, asset pipeline)
gem 'jquery-rails'
gem 'jquery-ui-rails'
# gem 'turbolinks'
# gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'unicorn'
gem 'god' # a process monitoring framework in ruby

gem 'slim', :require => 'slim-rails'
gem 'slim-rails'

gem 'bootstrap-sass' # http://d.hatena.ne.jp/sandmark/20120321/1332292995
gem 'bootswatch-rails'
gem 'bootstrap-datetimepicker-rails'
gem 'font-awesome-rails' # Font-Awesome web fonts
# gem 'newrelic_rpm'

gem 'acts-as-taggable-on', git: 'https://github.com/yohoushi/acts-as-taggable-on.git', branch: 'yohoushi'

gem 'draper' # decorator(view-model)
gem 'acts_as_parameter_object' # Introduce parameter object, cf. Refactoring: Ruby Edition
gem "settingslogic"
gem 'growthforecast-client'
gem 'multiforecast-client'
gem 'ancestry', git: 'https://github.com/yohoushi/ancestry.git', branch: 'yohoushi' # tree structured model
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
  gem 'web-console', '~> 2.0' # sophisticated error view
  gem 'binding_of_caller' # add irb/pry on better_rails view
  gem 'bullet' # warn N+1 queries
  gem 'rack-mini-profiler' # simple profiler
end

group :test do
  # c.f. http://stackoverflow.com/questions/16867707/rails-4-and-rspec-undefined-method-assertions-in-routing-spec
  gem 'rspec-rails', '~> 3.0' # rails g rspec:model
  gem 'rspec-its'
  gem 'rspec-activemodel-mocks'
  gem 'webmock', :require => false
  gem 'guard-rspec' # automatically run specs
  gem 'autodoc'
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
