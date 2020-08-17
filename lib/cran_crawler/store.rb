# frozen_string_literal: true

require 'activerecord-import'
require 'cran_crawler/models/package'
require 'semverse'

class Store
  def persist_packages(packages)
    records = packages.map { |package| Package.new(name: package.fetch('Package'), checksum: package.fetch('Md5sum')) }
    Package.import records, batch_size: 1000, on_duplicate_key_update: { conflict_target: [:name], columns: [:checksum] }
  end

  def persist_package(package)
    return if package.fetch('Type') != 'Package'

    # TODO: author
    # author = package.fetch('Author')
    # maintainer = package.fetch('Maintainer')
    #
    # User.upsert({ name: author })
    #
    # # TODO: filter 'Type' => 'Package'
    Version.upsert({
                     name: package.fetch('Version'),
                     title: package.fetch('Title'),
                     description: package.fetch('Description'),
                     license: package.fetch('License'),
                     required_r_needed: package.fetch('License'),
                     published_at: package.fetch('Date/publication')
                   })
  end
end
