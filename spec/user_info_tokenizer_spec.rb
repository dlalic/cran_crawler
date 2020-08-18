# frozen_string_literal: true

require 'rspec'

RSpec.describe UserInfoTokenizer do
  it 'succeeds parsing a single line' do
    input = 'Foo Bar Baz <foo@gmail.com>'
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'name' => 'Foo Bar Baz',
                 'email' => 'foo@gmail.com' }
    expected.keys.each do |k|
      expect(result.first[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing no email' do
    input = 'Foo Bar Baz'
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'name' => 'Foo Bar Baz',
                 'email' => nil }
    expected.keys.each do |k|
      expect(result.first[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing a single line with extra info' do
    input = 'Foo Bar Baz [aut, cre]'
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'name' => 'Foo Bar Baz',
                 'email' => nil }
    expected.keys.each do |k|
      expect(result.first[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing a comma separated list' do
    input = 'Foo Bar <foo@bar.com>, Bar Baz <baz@foo.com>'
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = [{ 'name' => 'Foo Bar',
                  'email' => 'foo@bar.com' },
                { 'name' => 'Bar Baz',
                  'email' => 'baz@foo.com' }]
    result.each_with_index do |item, index|
      expected[index].keys.each do |k|
        expect(item[k]).to eq(expected[index][k])
      end
    end
  end

  it 'succeeds parsing multiple lines with extra info' do
    input = 'Foo Bar [aut],
 Bar Baz [aut, cre]'
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = [{ 'name' => 'Foo Bar',
                  'email' => nil },
                { 'name' => 'Bar Baz',
                  'email' => nil }]
    result.each_with_index do |item, index|
      expected[index].keys.each do |k|
        expect(item[k]).to eq(expected[index][k])
      end
    end
  end

  it 'succeeds parsing multiple lines with orcid' do
    input = 'Foo Bar [aut, cre] (<https://orcid.org/123>),
 Bar Baz  [aut] (<https://orcid.org/456>)'
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = [{ 'name' => 'Foo Bar',
                  'email' => nil },
                { 'name' => 'Bar Baz',
                  'email' => nil }]
    result.each_with_index do |item, index|
      expected[index].keys.each do |k|
        expect(item[k]).to eq(expected[index][k])
      end
    end
  end
end
