# frozen_string_literal: true

class CreateSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :suggestions do |t|
      t.date :updated_at
      t.references :package, null: false, foreign_key: { on_delete: :cascade }, index: { unique: true }
    end
  end
end
