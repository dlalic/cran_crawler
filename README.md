# CranCrawler
![Ruby](https://github.com/dlalic/cran_crawler/workflows/Ruby/badge.svg)
[![CodeFactor](https://www.codefactor.io/repository/github/dlalic/cran_crawler/badge?s=704630e959ea60fd404809215ffc4c8eedc20ca2)](https://www.codefactor.io/repository/github/dlalic/cran_crawler)

A CLI tool to index CRAN packages.

## Usage

Setup:

```
bundle install
docker-compose up
rake db:create
rake db:migrate
```

To start indexing:
```
bundle exec bin/console start lib/db/config.yml
```

To run tests:
```
bundle exec rake
bundle exec cucumber
```

To (re-)generate OpenAPI client:

```
openapi-generator generate -i openapi.yaml -g ruby -o openapi
```
