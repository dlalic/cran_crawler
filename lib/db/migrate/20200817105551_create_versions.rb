# frozen_string_literal: true

class CreateVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :versions do |t|
      t.string :number
      t.string :title
      t.string :description
      t.string :required_r_needed
      t.string :license
      t.date :published_at
      t.timestamps
      t.references :package, index: true
    end
  end
end
