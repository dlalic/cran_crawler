# frozen_string_literal: true

class Dependency < ActiveRecord::Base
  belongs_to :package, optional: true
  belongs_to :version

  def self.unresolved(package)
    where(unresolved_name: nil, package_id: package.id)
  end

  def self.mark_unresolved_for(package)
    unresolved(package).update_all(unresolved_name: package.name, package_id: nil)
  end

  def self.development
    where(scope: 'development')
  end

  def self.runtime
    where(scope: 'runtime')
  end

  def name
    unresolved_name || package&.name
  end
end
