# frozen_string_literal: true

class UserInfoTokenizer
  def initialize(input)
    @input = input
  end

  def process
    if @input.lines.count == 1
      sanitized = @input.gsub(/\[(.*)\]/, '')
      sanitized.split(',').map(&method(:process_item))
    else
      @input.lines.map(&method(:process_item))
    end
  end

  private

  def process_item(item)
    item = item.gsub(/\(\<http(.*)\>\)/, '')
    name = item.gsub(/\[(.*)\]/, '')
    name = name.chomp.sub(' ,', '')
    email = item[/\<(.*?)\>/m, 1]
    name = name.sub(email, '').sub(' <>', '') unless email.nil?
    name = name.delete_prefix(' ')
    name = name.delete_suffix(',')
    name = name.delete_suffix(' ') while name.end_with?(' ')
    { 'email' => email, 'name' => name }
  end
end
