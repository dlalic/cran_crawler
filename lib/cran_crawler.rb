require 'cran_crawler/version'
require 'thor'
require 'active_record'
require 'cran_crawler/crawler'

module CranCrawler
  class Error < StandardError; end
  class CLI < Thor
    # config_path = File.join(File.dirname(__FILE__), '../db/config.yml')
    # config = YAML.safe_load(File.open(config_path))
    # ActiveRecord::Base.establish_connection(config['development'])
    # crawler = Crawler.new
    # crawler.download_index
  end
end
