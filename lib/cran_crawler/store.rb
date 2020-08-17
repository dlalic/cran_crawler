# frozen_string_literal: true

require 'activerecord-import'
require 'cran_crawler/models/package'
require 'cran_crawler/models/version'
require 'cran_crawler/models/user'
require 'cran_crawler/models/author'
require 'cran_crawler/models/maintainer'
require 'cran_crawler/models/dependency'
require 'cran_crawler/models/suggestion'
require 'semantic'

class Store
  def persist_packages(packages)
    records = packages.map { |package| Package.new(name: package.fetch('Package'), checksum: package.fetch('Md5sum')) }
    Package.import records, batch_size: 1000, on_duplicate_key_update: { conflict_target: [:name], columns: [:checksum] }
  end

  def all_packages
    Package.all.where(indexed: false)
  end

  def persist_package(package)
    return if package.fetch('Type') != 'Package'

    # TODO: extract this and support proper semver
    r_version = package['Depends'][/\(.*?\)/].tr('^0-9.', '')
    version = Version.upsert(
      {
        number: package.fetch('Version'),
        title: package.fetch('Title'),
        description: package.fetch('Description'),
        license: package.fetch('License'),
        r_version: r_version.to_s,
        published_at: package.fetch('Date/publication'),
        created_at: Time.now,
        updated_at: Time.now,
        package: ...
      }
    )
    author = package.fetch('Author')
    User.upsert({ name: author, version: version, created_at: Time.now, updated_at: Time.now })
    maintainer = package.fetch('Maintainer')
    User.upsert({ name: maintainer, version: version, created_at: Time.now, updated_at: Time.now })
  end
end
