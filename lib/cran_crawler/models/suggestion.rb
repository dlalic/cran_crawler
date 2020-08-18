# frozen_string_literal: true

class Suggestion < ActiveRecord::Base
  belongs_to :package
  belongs_to :version
end
