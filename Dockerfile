FROM ruby:2.2.3
MAINTAINER Yohoushi <https://github.com/yohoushi/>

RUN apt-get update && rm -rf /var/lib/apt/lists/*

ENV APP_ROOT=/usr/src/app

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY Gemfile*  $APP_ROOT/
RUN sed -i "/^gem 'mysql2'/d" Gemfile
RUN sed -i "s/^# \+\(gem \+'sqlite3'\)/\1/" Gemfile

RUN bundle install --system --without test development
ADD . $APP_ROOT
# Run sed again because above ADD . $APP_ROOT overrides Gemfile
RUN sed -i "/^gem 'mysql2'/d" Gemfile
RUN sed -i "s/^# \+\(gem \+'sqlite3'\)/\1/" Gemfile

RUN cp config/database-sqlite.yml config/database.yml 
COPY docker/application.yml config/application.yml

EXPOSE 4804
ENTRYPOINT ["./bin/yohoushi"]
