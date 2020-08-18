# frozen_string_literal: true

class UserInfoTokenizer
  def initialize(input)
    @input = input
  end

  def process
    @input.lines.map do |line|
      name = line.gsub(/\[(.*)\]/, '')
      name = name.chomp.sub(' ,', '')
      email = line[/\<(.*?)\>/m, 1]
      name = name.sub(email, '').sub(' <>', '') unless email.nil?
      name = name.delete_prefix(' ')
      name = name.delete_suffix(' ')
      { 'email' => email, 'name' => name }
    end
  end
end
