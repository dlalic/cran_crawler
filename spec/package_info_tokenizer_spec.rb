# frozen_string_literal: true

require 'rspec'

RSpec.describe PackageInfoTokenizer do
  it 'succeeds parsing dependencies' do
    input = 'R (>= 2.15.0), xtable, pbapply'
    tokenizer = PackageInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'r_version' => '2.15.0',
                 'packages' => %w[xtable pbapply] }
    expected.keys.each do |k|
      expect(result[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing suggestions' do
    input = 'xtable, pbapply'
    tokenizer = PackageInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'r_version' => nil,
                 'packages' => %w[xtable pbapply] }
    expected.keys.each do |k|
      expect(result[k]).to eq(expected[k])
    end
  end
end
