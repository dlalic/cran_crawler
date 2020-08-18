# frozen_string_literal: true

require 'cran_crawler/models/package'
require 'cran_crawler/models/version'
require 'cran_crawler/models/user'
require 'cran_crawler/models/author'
require 'cran_crawler/models/maintainer'
require 'cran_crawler/models/dependency'
require 'cran_crawler/models/suggestion'
require 'cran_crawler/user_info_tokenizer'
require 'cran_crawler/package_info_tokenizer'

class Store
  def initialize(logger = Logger.new(STDOUT))
    @logger = logger
  end

  def persist_packages(packages)
    records = packages.map do |p|
      { name: p.fetch('Package'),
        checksum: p.fetch('Md5sum'),
        updated_at: Time.now }
    end
    Package.upsert_all(records, returning: false, unique_by: :name)
  end

  def package_indexed?(name)
    Package.where(name: name).pluck(:indexed).first
  end

  def mark_package_as_not_indexed(name)
    Package.where(name: name).first.update(indexed: false)
  end

  def persist_package(package)
    # 'Type' is not always present
    return if package.fetch('Type', nil) != 'Package'

    result = parse_dependencies(package)
    version_id = persist_version(result['r_version'], package)
    persist_dependencies(result['packages'], version_id)
    handle_suggestions(package, version_id)
    handle_authors(package, version_id)
    handle_maintainers(package, version_id)
  end

  private

  def parse_dependencies(package)
    depends = package.fetch('Depends', nil)
    return { 'r_version' => nil, 'packages' => [] } if depends.nil?

    tokenizer = PackageInfoTokenizer.new(depends)
    tokenizer.process
  end

  def handle_suggestions(package, version_id)
    suggests = package.fetch('Suggests', nil)
    return if suggests.nil?

    tokenizer = PackageInfoTokenizer.new(suggests)
    result = tokenizer.process
    persist_suggestions(result['packages'], version_id)
  end

  def handle_authors(package, version_id)
    tokenizer = UserInfoTokenizer.new(package.fetch('Author'))
    tokenizer.process.each do |r|
      user_id = persist_user(r['name'], r['email'])
      persist_author(user_id, version_id)
    end
  end

  def handle_maintainers(package, version_id)
    tokenizer = UserInfoTokenizer.new(package.fetch('Maintainer'))
    tokenizer.process.each do |r|
      user_id = persist_user(r['name'], r['email'])
      persist_maintainer(user_id, version_id)
    end
  end

  def persist_dependencies(packages, version_id)
    packages = packages.map do |p|
      { package_id: Package.find_or_create_by(name: p).id,
        version_id: version_id,
        updated_at: Time.now }
    end
    Dependency.upsert_all(packages, unique_by: :index_dependencies_on_package_id_and_version_id) unless packages.empty?
  end

  def persist_suggestions(packages, version_id)
    packages = packages.map do |p|
      { package_id: Package.find_or_create_by(name: p).id,
        version_id: version_id,
        updated_at: Time.now }
    end
    Suggestion.upsert_all(packages, unique_by: :index_suggestions_on_package_id_and_version_id) unless packages.empty?
  end

  def persist_version(r_version, package)
    Version.upsert(
      {
        number: package.fetch('Version'),
        title: package.fetch('Title'),
        description: package.fetch('Description'),
        license: package.fetch('License'),
        r_version: r_version,
        published_at: package.fetch('Date/publication'),
        updated_at: Time.now,
        package_id: Package.find_or_create_by(name: package.fetch('Package')).id
      }, returning: %w[id], unique_by: :index_versions_on_number_and_package_id
    ).first.fetch('id')
  end

  def persist_user(name, email = nil)
    User.upsert(
      {
        name: name,
        email: email,
        updated_at: Time.now
      }, returning: %w[id], unique_by: :index_users_on_name
    ).first.fetch('id')
  end

  def persist_author(user_id, version_id)
    Author.upsert(
      {
        user_id: user_id,
        version_id: version_id,
        updated_at: Time.now
      }, unique_by: %i[user_id version_id]
    ).first.fetch('id')
  end

  def persist_maintainer(user_id, version_id)
    Maintainer.upsert(
      {
        user_id: user_id,
        version_id: version_id,
        updated_at: Time.now
      }, unique_by: %i[user_id version_id]
    ).first.fetch('id')
  end
end
