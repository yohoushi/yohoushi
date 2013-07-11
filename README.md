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

## Start Services

Start yohoushi (the unicorn HTTP server and a serverengine worker): Use `-d` option to daemonize.

    bin/yohoushi -d

Stop yohoushi:

    bin/yohoushi stop

TROUBLESHOOTING:

When `stop` command does not work well, please try to `start` yohoushi and send `stop` again. 
Yohoushi is using a process management gem named `god`, but I am experiencing with this trouble sometimes. 
I will send a pull request to `god` if I find a solution for this.
