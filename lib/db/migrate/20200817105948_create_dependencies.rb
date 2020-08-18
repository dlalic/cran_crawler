# frozen_string_literal: true

class CreateDependencies < ActiveRecord::Migration[6.0]
  def change
    create_table :dependencies do |t|
      t.date :updated_at
      t.references :package, null: false, foreign_key: { on_delete: :cascade }
      t.references :version, null: false, foreign_key: { on_delete: :cascade }
      t.index %i[package_id version_id], unique: true
    end
  end
end
