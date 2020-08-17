# frozen_string_literal: true

class SchemaMigration < ActiveRecord::Base
  self.primary_key = :version
end
