# frozen_string_literal: true

class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :checksum
      t.boolean :indexed, default: false, null: false
      t.timestamps
      t.index :name, unique: true
    end
  end
end
