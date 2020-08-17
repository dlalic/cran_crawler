require 'activerecord-import'
require 'cran_crawler/models/package'

class Store
  def persist_packages(packages)
    records = packages.map { |package| Package.new(name: package.fetch('Package'), checksum: package.fetch('Md5sum')) }
    Package.import records, on_duplicate_key_update: [:name]
  end

  def persist_package(package)

  end
end