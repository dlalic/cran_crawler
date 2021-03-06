# frozen_string_literal: true

class CreateMaintainers < ActiveRecord::Migration[6.0]
  def change
    create_table :maintainers do |t|
      t.date :updated_at
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :version, null: false, foreign_key: { on_delete: :cascade }
      t.index %i[user_id version_id], unique: true
    end
  end
end
