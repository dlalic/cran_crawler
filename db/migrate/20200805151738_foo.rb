# frozen_string_literal: true

class Foo < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.text :description

      t.date :timestamp
    end
  end
end
