FROM ruby:3.1.1-buster

ARG DIR=/src
ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.3.14

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
    autoconf bison build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem update --system \
    && gem install bundler -v $BUNDLER_VERSION

RUN mkdir ${DIR}
WORKDIR ${DIR}

RUN useradd -m --shell /bin/bash --uid 1000 ruby
USER ruby

ENV EDITOR vim
ENV BUNDLE_PATH vendor/bundle

RUN bundle config --global retry 5 \
    && bundle config --global path ${BUNDLE_PATH}
