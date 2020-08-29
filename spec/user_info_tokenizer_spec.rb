# frozen_string_literal: true

require 'rspec'
require 'faker'

RSpec.describe UserInfoTokenizer do
  it 'succeeds parsing a single line' do
    name = Faker::Name.name
    email = Faker::Internet.email
    input = "#{name} <#{email}>"
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'name' => name,
                 'email' => email }
    expected.keys.each do |k|
      expect(result.first[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing no email' do
    input = Faker::Name.name
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'name' => input,
                 'email' => nil }
    expected.keys.each do |k|
      expect(result.first[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing a single line with extra info' do
    name = Faker::Name.name
    input = "#{name} [aut, cre]"
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = { 'name' => name,
                 'email' => nil }
    expected.keys.each do |k|
      expect(result.first[k]).to eq(expected[k])
    end
  end

  it 'succeeds parsing a comma separated list' do
    input = []
    expected = []
    rand(2...100).times do
      name = Faker::Name.name
      email = Faker::Internet.email
      input.append("#{name} <#{email}>")
      expected.append({ 'name' => name,
                        'email' => email })
    end
    input = input.join(', ')
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    result.each_with_index do |item, index|
      expected[index].keys.each do |k|
        expect(item[k]).to eq(expected[index][k])
      end
    end
  end

  it 'succeeds parsing multiple lines with extra info' do
    name1 = Faker::Name.name
    name2 = Faker::Name.name
    input = "#{name1} [aut],
 #{name2} [aut, cre]"
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = [{ 'name' => name1,
                  'email' => nil },
                { 'name' => name2,
                  'email' => nil }]
    result.each_with_index do |item, index|
      expected[index].keys.each do |k|
        expect(item[k]).to eq(expected[index][k])
      end
    end
  end

  it 'succeeds parsing multiple lines with orcid' do
    name1 = Faker::Name.name
    name2 = Faker::Name.name
    input = "#{name1} [aut, cre] (<https://orcid.org/123>),
 #{name2}  [aut] (<https://orcid.org/456>)"
    tokenizer = UserInfoTokenizer.new(input)
    result = tokenizer.process
    expected = [{ 'name' => name1,
                  'email' => nil },
                { 'name' => name2,
                  'email' => nil }]
    result.each_with_index do |item, index|
      expected[index].keys.each do |k|
        expect(item[k]).to eq(expected[index][k])
      end
    end
  end
end
