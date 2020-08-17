# frozen_string_literal: true
require 'vcr'
require 'active_record'
require 'cran_crawler'

When(/^I run the command line tool$/) do
  VCR.use_cassette('packages') do
    CranCrawler::CLI.start(%w(start lib/db/config.yml))
  end
end

Then(/^the output should contain "([^"]*)"$/) do |_arg|
  pending
end
