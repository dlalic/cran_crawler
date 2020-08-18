# frozen_string_literal: true

class Author < ActiveRecord::Base
  belongs_to :user
  belongs_to :version
end
