# frozen_string_literal: true

class Maintainer < ActiveRecord::Base
  belongs_to :user
  belongs_to :version

  def safe_destroy
    package.maintainers.many? && destroy
  end
end
