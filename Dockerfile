FROM ruby:1.9

RUN apt-get update \
    && apt-get -y install \
         imagemagick \
         libmagickwand-dev \
         qt4-default \
         qt4-qmake \
         vim \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config

RUN mkdir /app
WORKDIR /app

COPY Gemfile* /app
RUN bundle install

COPY . /app/