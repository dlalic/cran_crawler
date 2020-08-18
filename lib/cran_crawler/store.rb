# frozen_string_literal: true

require 'activerecord-import'
require 'cran_crawler/models/package'
require 'cran_crawler/models/version'
require 'cran_crawler/models/user'
require 'cran_crawler/models/author'
require 'cran_crawler/models/maintainer'
require 'cran_crawler/models/dependency'
require 'cran_crawler/models/suggestion'
require 'cran_crawler/user_info_tokenizer'
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
    # return if package.fetch('Type', :default_value) != 'Package'
    version_id = persist_version(package)
    author = package.fetch('Author')
    tokenizer = UserInfoTokenizer.new(author)
    tokenizer.process.each do |r|
      user_id = persist_user(r['name'], r['email'])
      persist_author(user_id, version_id)
    end
    maintainer = package.fetch('Maintainer')
    tokenizer = UserInfoTokenizer.new(maintainer)
    tokenizer.process.each do |r|
      user_id = persist_user(r['name'], r['email'])
      persist_maintainer(user_id, version_id)
    end
  end

  private

  def persist_version(package)
    r_version = package['Depends'][/\(.*?\)/].tr('^0-9.', '')
    Version.upsert(
      {
        number: package.fetch('Version'),
        title: package.fetch('Title'),
        description: package.fetch('Description'),
        license: package.fetch('License'),
        r_version: r_version.to_s,
        published_at: package.fetch('Date/publication'),
        created_at: Time.now,
        updated_at: Time.now,
        package_id: Package.where(['name = ?', package.fetch('Package')]).first.id
      }, returning: %w[id], unique_by: :index_versions_on_number_and_package_id
    ).first.fetch('id', :default_value)
  end

  def persist_user(name, email = nil)
    User.upsert(
      {
        name: name,
        email: email,
        created_at: Time.now,
        updated_at: Time.now
      }, returning: %w[id], unique_by: :index_users_on_name
    ).first.fetch('id', :default_value)
  end

  def persist_author(user_id, version_id)
    Author.upsert(
      {
        user_id: user_id,
        version_id: version_id,
        created_at: Time.now,
        updated_at: Time.now
      }, unique_by: %i[user_id version_id]
    ).first.fetch('id', :default_value)
  end

  def persist_maintainer(user_id, version_id)
    Maintainer.upsert(
      {
        user_id: user_id,
        version_id: version_id,
        created_at: Time.now,
        updated_at: Time.now
      }, unique_by: %i[user_id version_id]
    ).first.fetch('id', :default_value)
  end
end
