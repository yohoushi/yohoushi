# Yohoushi

Yohoushi is for all users who love graphs. Documents are avialable at [gh-pages](http://yohoushi.github.io/yohoushi).

## Ruby version

* ruby >= 2.0.0

## System dependencies

* MySQL
* GrowthForecast >= 0.62

## Preparation

Install and run MySQL and GrowthForecast. Configure `config/application.yml` and `config/database.yml`. 

    bundle

## How to develop

Note that the default `RAILS_ENV` is being switched to `production`, not `development`
so that users of yohoushi can easily install and run it in production environment. 
Thus, developers must specify `RAILS_ENV=development`.


Database initialization

    RAILS_ENV=development bin/rake db:create db:migrate

Run a rails app only

    RAILS_ENV=development bin/rails s

Run a serverengine worker only

    RAILS_ENV=development bin/serverengine

Run both a rails app and a serverengine worker through `god`; Use `-d` option to daemonize.

    RAILS_ENV=development bin/yohoushi

Stop both the daemonized rails app and serverengine worker:

    RAILS_ENV=development bin/yohoushi stop

## How to run the test suite

    RAILS_ENV=test bin/rake db:drop db:create db:migrate 
    rspec

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

