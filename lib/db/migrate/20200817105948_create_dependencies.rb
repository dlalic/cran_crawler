# frozen_string_literal: true

class CreateDependencies < ActiveRecord::Migration[6.0]
  def change
    create_table :dependencies do |t|
      t.timestamps
      t.references :package, null: false
      t.references :version, null: false
      t.index %i[package_id version_id], unique: true
    end
  end
end
