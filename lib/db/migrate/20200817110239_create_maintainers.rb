# frozen_string_literal: true

class CreateMaintainers < ActiveRecord::Migration[6.0]
  def change
    create_table :maintainers do |t|
      t.timestamps
      t.references :user, index: true
      t.references :version, index: true
    end
  end
end
