# frozen_string_literal: true

require 'rspec'

RSpec.describe CranCrawler do
  it 'has a version number' do
    expect(CranCrawler::VERSION).not_to be nil
  end
end
