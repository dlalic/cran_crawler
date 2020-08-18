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
require 'cran_crawler/package_info_tokenizer'
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
    tokenizer = PackageInfoTokenizer.new(package['Depends'])
    package_info = tokenizer.process
    version_id = persist_version(package_info['r_version'], package)
    persist_dependencies(package_info['packages'], version_id)
    tokenizer = PackageInfoTokenizer.new(package['Suggests'])
    package_info = tokenizer.process
    persist_suggestions(package_info['packages'], version_id)
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

  def persist_dependencies(packages, version_id)
    packages = packages.map do |p|
      { package_id: Package.where(['name = ?', p]).first.id,
        version_id: version_id,
        updated_at: Time.now }
    end
    Dependency.upsert_all(packages, unique_by: :index_dependencies_on_package_id_and_version_id)
  end

  def persist_suggestions(packages, version_id)
    packages = packages.map do |p|
      { package_id: Package.where(['name = ?', p]).first.id,
        version_id: version_id,
        updated_at: Time.now }
    end
    Suggestion.upsert_all(packages, unique_by: :index_suggestions_on_package_id_and_version_id)
  end

  def persist_version(r_version, package)
    Version.upsert(
      {
        number: package.fetch('Version'),
        title: package.fetch('Title'),
        description: package.fetch('Description'),
        license: package.fetch('License'),
        r_version: r_version.to_s,
        published_at: package.fetch('Date/publication'),
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
        updated_at: Time.now
      }, returning: %w[id], unique_by: :index_users_on_name
    ).first.fetch('id', :default_value)
  end

  def persist_author(user_id, version_id)
    Author.upsert(
      {
        user_id: user_id,
        version_id: version_id,
        updated_at: Time.now
      }, unique_by: %i[user_id version_id]
    ).first.fetch('id', :default_value)
  end

  def persist_maintainer(user_id, version_id)
    Maintainer.upsert(
      {
        user_id: user_id,
        version_id: version_id,
        updated_at: Time.now
      }, unique_by: %i[user_id version_id]
    ).first.fetch('id', :default_value)
  end
end
