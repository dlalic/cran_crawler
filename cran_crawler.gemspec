# frozen_string_literal: true

require_relative 'lib/cran_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = 'cran_crawler'
  spec.version       = CranCrawler::VERSION
  spec.authors       = ['Dunja Lalic']
  spec.email         = ['dunja.lalic@gmail.com']

  spec.summary       = 'CRAN crawler'
  spec.description   = 'Index all the available packages in CRAN, with versions, authors and maintainers'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
  spec.add_dependency 'activerecord-import'
  spec.add_dependency 'deb822'
  spec.add_dependency 'pg'
  spec.add_dependency 'semverse'
  spec.add_dependency 'thor'
end
