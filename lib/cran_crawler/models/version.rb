# frozen_string_literal: true

class Version < ActiveRecord::Base
  belongs_to :package, touch: true
  has_many :dependencies, -> { order('package.name ASC').includes(:package) }, dependent: :destroy, inverse_of: 'version'
  has_many :suggestions, -> { order('package.name ASC').includes(:package) }, dependent: :destroy, inverse_of: 'version'
end
