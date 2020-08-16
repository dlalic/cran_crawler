FROM ruby:2.7
RUN apt-get update -qq
RUN mkdir /myapp
WORKDIR /myapp
COPY . /myapp
RUN bundle install
