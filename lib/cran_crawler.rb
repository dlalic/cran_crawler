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
      packages.each_with_index do |package, index|
        break if ENV['CUCUMBER'] && index.positive?

        name = package.fetch('Package', :default_value)
        version = package.fetch('Version', :default_value)
        next if store.package_indexed?(name)

        begin
          package_details = crawler.retrieve_package_details(name, version)
          store.persist_package(package_details.first)
        ensure
          store.mark_package_as_not_indexed(name)
        end
      end
    end
  end
end
