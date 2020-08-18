# frozen_string_literal: true

require 'vcr'
require 'cran_crawler'
require 'cran_crawler/models/package'

When(/^I run the command line tool$/) do
  VCR.use_cassettes([{ 'name': 'packages' }, { 'name': 'package' }]) do
    CranCrawler::CLI.start(%w[start lib/db/config.yml])
  end
end

Then(/^the database should contain info about the package "([^"]*)"$/) do |arg|
  package = Package.find_by(name: arg)
  expect(package).not_to be_nil
  expect(package.checksum).to eq('027ebdd8affce8f0effaecfcd5f5ade2')
  version = Version.find_by(package_id: package.id)
  expect(version.number).to eq('1.0.0')
  expect(version.title).to start_with('Accurate, Adaptable, and Accessible')
  expect(version.description).to start_with('Supplies tools for tabulating and analyzing the results')
  expect(version.r_version).to eq('2.15.0')
  expect(version.license).to eq('GPL (>= 2)')
  expect(version.published_at).to eq('2015-08-16'.to_date)
  dependencies = Package.where(id: version.dependencies.map(&:package_id)).order('name ASC').map(&:name)
  expect(dependencies).to eq(%w[pbapply xtable])
  suggestions = Package.where(id: version.suggestions.map(&:package_id)).order('name ASC').map(&:name)
  expect(suggestions).to eq(%w[e1071 randomForest])
  authors = User.where(id: version.authors.map(&:user_id))
  # Exact matching is omitted to obfuscate real people's names and emails
  expect(authors.first.name).not_to be_nil
  expect(authors.first.email).not_to be_nil
  maintainers = User.where(id: version.maintainers.map(&:user_id))
  # Exact matching is omitted to obfuscate real people's names and emails
  expect(maintainers.first.name).not_to be_nil
  expect(maintainers.first.email).not_to be_nil
end
