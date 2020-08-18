# frozen_string_literal: true

class CreateMaintainers < ActiveRecord::Migration[6.0]
  def change
    create_table :maintainers do |t|
      t.timestamps
      t.references :user
      t.references :version
      t.index %i[user_id version_id], unique: true
    end
  end
end
