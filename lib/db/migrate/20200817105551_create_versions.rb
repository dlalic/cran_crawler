# frozen_string_literal: true

class CreateVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :versions do |t|
      t.string :number, null: false
      t.string :title
      t.text :description
      t.string :r_version
      t.string :license
      t.date :published_at
      t.date :updated_at
      t.references :package, null: false, foreign_key: { on_delete: :cascade }
      t.index %i[number package_id], unique: true
    end
  end
end
