# FROM ruby:2.7.1

# RUN apt-get update -qq && \
#   apt-get install -y apt-utils \
#   build-essential \
#   libpq-dev \
#   vim \
#   default-mysql-client
# RUN set -ex && \
#   apt-get update -qq && \
#   apt-get install -y sudo && \
#   : "Install node.js" && \
#   curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
#   apt-get update -qq && \
#   apt-get install -y nodejs && \
#   : "Install yarn" && \
#   curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
#   echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
#   apt-get update -qq && \
#   apt-get install -y yarn

# WORKDIR /app

# ADD Gemfile .
# ADD Gemfile.lock .

# RUN gem install bunlder && bundle install -j4

# ADD . /app

# WORKDIR .

# RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile \
#   && yarn cache clean \
#   && rm -rf node_modules tmp/cache

# EXPOSE 3000

FROM ruby:2.7.2-alpine

WORKDIR /app

ENV RAILS_ENV="production"
ENV NODE_ENV="production"

# 依存パッケージのインストール
COPY Gemfile Gemfile.lock /app/
RUN apk add --no-cache -t .build-dependencies \
  build-base \
  libxml2-dev\
  libxslt-dev \
  && apk add --no-cache \
  bash \
  file \
  imagemagick \
  libpq \
  libxml2 \
  libxslt \
  nodejs \
  default-mysql-client \
  tini \
  tzdata \
  yarn \
  && gem install bundler:2.0.2 \
  && bundle install -j$(getconf _NPROCESSORS_ONLN) --deployment --without test development \
  && apk del --purge .build-dependencies

# アプリケーションコードのコピー
COPY . /app

# アセットのプリコンパイル
RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile \
  && yarn cache clean \
  && rm -rf node_modules tmp/cache

# ランタイム設定
ENV RAILS_SERVE_STATIC_FILES="true"
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
EXPOSE 3000
