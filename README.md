# Yohoushi

yet another GrowthForecast like Graphing / Visualization tool.

## Ruby version

ruby 2.0.0

## System dependencies

mysql

## Configuration

## Database creation

    rake db:create

## Database initialization

    rake db:migrate
    rake db:seed

## How to run the test suite

    rake db:drop db:create db:migrate RAILS_ENV=test
    rspec

## Assets Precompile

    RAILS_ENV=production rake assets:precompile

## Services

Start yohoushi (the unicorn HTTP server and a serverengine worker):

    bin/yohoushi -d

Use `-d` option to daemonize.

Stop yoshoushi:

    bin/yohoushi stop

## Deployment instructions
