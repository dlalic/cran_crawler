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
      logger = Logger.new(STDOUT)
      crawler = Crawler.new(logger: logger)
      store = Store.new(logger)
      packages = crawler.retrieve_all_packages
      # There seem to be packages with same name (and sometimes the same version, with only R version different)
      packages = packages.uniq { |p| [p['Package']] }
      store.persist_packages(packages)
      packages.each_with_index do |package, index|
        break if ENV['CUCUMBER'] && index.positive?

        name = package.fetch('Package')
        version = package.fetch('Version')
        next if store.package_indexed?(name)

        begin
          logger.info "Retrieving package details: #{name} #{version}"
          package_details = crawler.retrieve_package_details(name, version)
          store.persist_package(package_details.first)
        ensure
          store.mark_package_as_not_indexed(name)
        end
      end
    end
  end
end
