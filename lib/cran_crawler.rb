# frozen_string_literal: true

require 'cran_crawler/version'
require 'thor'
require 'cran_crawler/crawler'
require 'active_record'
require 'cran_crawler/store'

module CranCrawler
  class Error < StandardError; end
  class CLI < Thor
    desc 'start [CONFIG]', 'Start with configuration'
    def start(config)
      yaml = YAML.load_file(config)
      ActiveRecord::Base.establish_connection(yaml['development'])
      crawler = Crawler.new
      packages = crawler.retrieve_all_packages
      store = Store.new
      results = store.persist_packages(packages)
      results
    end
  end
end
