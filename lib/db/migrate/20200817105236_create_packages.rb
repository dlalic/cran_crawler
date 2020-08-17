# frozen_string_literal: true

class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name, index: true
      t.string :checksum
      t.timestamps
    end
  end
end
