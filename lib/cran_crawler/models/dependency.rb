# frozen_string_literal: true

class Dependency < ActiveRecord::Base
  belongs_to :package
  belongs_to :version
end
