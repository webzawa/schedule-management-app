FROM ruby:2.7.3

RUN apt-get update -qq && \
  apt-get install -y apt-utils \
  build-essential \
  libpq-dev \
  vim \
  default-mysql-client \
  shared-mime-info \
  graphviz
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
# # chromeの追加
# RUN apt-get update && apt-get install -y unzip && \
#   CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
#   wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
#   unzip ~/chromedriver_linux64.zip -d ~/ && \
#   rm ~/chromedriver_linux64.zip && \
#   chown root:root ~/chromedriver && \
#   chmod 755 ~/chromedriver && \
#   mv ~/chromedriver /usr/bin/chromedriver && \
#   sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
#   sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
#   apt-get update && apt-get install -y google-chrome-stable

WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .

RUN gem install bundler && bundle install -j4
# RUN gem install bundler
# RUN bundle update mimemagic
# RUN bundle install -j4

ADD . /app

WORKDIR .

RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile \
  && yarn cache clean \
  && rm -rf node_modules tmp/cache

EXPOSE 3000