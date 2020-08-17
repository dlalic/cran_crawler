# frozen_string_literal: true

class CreateSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :suggestions do |t|
      t.timestamps
      t.references :package, index: true
      t.references :version, index: true
    end
  end
end
