# frozen_string_literal: true

class CreateDependencies < ActiveRecord::Migration[6.0]
  def change
    create_table :dependencies do |t|
      t.timestamps
      t.references :package, index: true
      t.references :version, index: true
    end
  end
end
