# frozen_string_literal: true

class Maintainer < ActiveRecord::Base
  belongs_to :user
  belongs_to :version
end
