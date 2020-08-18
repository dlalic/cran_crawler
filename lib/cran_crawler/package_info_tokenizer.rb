# frozen_string_literal: true

class PackageInfoTokenizer
  def initialize(input)
    @input = input
  end

  def process
    r_version = @input[/\(.*?\)/]
    r_version = r_version.tr('^0-9.', '') unless r_version.nil?
    packages = @input.split(/,\s*/).filter { |x| !x.starts_with?('R (') }
    { 'r_version' => r_version, 'packages' => packages }
  end
end
