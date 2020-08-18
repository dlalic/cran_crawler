# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.timestamps
      t.references :user, null: false
      t.references :version, null: false
      t.index %i[user_id version_id], unique: true
    end
  end
end
