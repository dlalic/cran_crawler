# frozen_string_literal: true

class Version < ActiveRecord::Base
  belongs_to :package
  has_many :authors
  has_many :maintainers
  has_many :dependencies
  has_many :suggestions
end
