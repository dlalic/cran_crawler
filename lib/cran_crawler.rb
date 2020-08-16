# frozen_string_literal: true

require 'cran_crawler/version'
require 'thor'
require 'cran_crawler/crawler'

module CranCrawler
  class Error < StandardError; end
  class CLI < Thor
    desc 'start [OUTPUT]', 'Start with output file'
    def start(output)
      crawler = Crawler.new
      # crawler.download_index
    end
  end
end
