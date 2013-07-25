# Yohoushi

Yohoushi is for all users who love graphs.

Please see details of Yohoushi at [gh-pages](http://yohoushi.github.io/yohoushi).

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

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2013 DeNA Co., Ltd. See [LICENSE](LICENSE) for details.

