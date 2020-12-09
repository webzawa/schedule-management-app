FROM ruby:2.7.1

RUN apt-get update -qq && \
  apt-get install -y apt-utils \
  build-essential \
  libpq-dev \
  vim \
  default-mysql-client 
RUN set -ex && \
  apt-get update -qq && \
  apt-get install -y sudo && \
  : "Install node.js" && \
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
  apt-get update -qq && \
  apt-get install -y nodejs && \
  : "Install yarn" && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y yarn

WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install -j4

RUN RAILS_ENV=production bundle exec rails assets:precompile

RUN RAILS_ENV=production bundle exec bin/webpack

RUN RAILS_ENV=production bundle bundle exec rake webpacker:install

RUN RAILS_ENV=production bundle bundle exec rake webpacker:compile

ADD . /app

EXPOSE 3000