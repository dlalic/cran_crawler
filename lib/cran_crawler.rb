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
      store.persist_packages(packages)
      packages.each do |package|
        package_details = crawler.retrieve_package_details(package.fetch('Package'), package.fetch('Version'))
        store.persist_package(package_details.first)
      end
    end
  end
end
