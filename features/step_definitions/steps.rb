# frozen_string_literal: true

require 'vcr'
require 'cran_crawler'

When(/^I run the command line tool$/) do
  VCR.use_cassettes([{ 'name': 'packages' }, { 'name': 'package' }]) do
    CranCrawler::CLI.start(%w[start lib/db/config.yml])
  end
end

Then(/^the database contains these packages:$/) do |table|
end
