FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y postgresql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY . /myapp
RUN bundle install
