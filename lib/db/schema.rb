# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_17_110239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.date "updated_at"
    t.bigint "user_id", null: false
    t.bigint "version_id", null: false
    t.index ["user_id", "version_id"], name: "index_authors_on_user_id_and_version_id", unique: true
    t.index ["user_id"], name: "index_authors_on_user_id"
    t.index ["version_id"], name: "index_authors_on_version_id"
  end

  create_table "dependencies", force: :cascade do |t|
    t.date "updated_at"
    t.bigint "package_id", null: false
    t.bigint "version_id", null: false
    t.index ["package_id", "version_id"], name: "index_dependencies_on_package_id_and_version_id", unique: true
    t.index ["package_id"], name: "index_dependencies_on_package_id"
    t.index ["version_id"], name: "index_dependencies_on_version_id"
  end

  create_table "maintainers", force: :cascade do |t|
    t.date "updated_at"
    t.bigint "user_id", null: false
    t.bigint "version_id", null: false
    t.index ["user_id", "version_id"], name: "index_maintainers_on_user_id_and_version_id", unique: true
    t.index ["user_id"], name: "index_maintainers_on_user_id"
    t.index ["version_id"], name: "index_maintainers_on_version_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", null: false
    t.string "checksum"
    t.boolean "indexed", default: false, null: false
    t.date "updated_at"
    t.index ["name"], name: "index_packages_on_name", unique: true
  end

  create_table "suggestions", force: :cascade do |t|
    t.date "updated_at"
    t.bigint "package_id", null: false
    t.bigint "version_id", null: false
    t.index ["package_id", "version_id"], name: "index_suggestions_on_package_id_and_version_id", unique: true
    t.index ["package_id"], name: "index_suggestions_on_package_id"
    t.index ["version_id"], name: "index_suggestions_on_version_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.date "updated_at"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "number", null: false
    t.string "title"
    t.text "description"
    t.string "r_version"
    t.string "license"
    t.date "published_at"
    t.date "updated_at"
    t.bigint "package_id", null: false
    t.index ["number", "package_id"], name: "index_versions_on_number_and_package_id", unique: true
    t.index ["package_id"], name: "index_versions_on_package_id"
  end

  add_foreign_key "authors", "users", on_delete: :cascade
  add_foreign_key "authors", "versions", on_delete: :cascade
  add_foreign_key "dependencies", "packages", on_delete: :cascade
  add_foreign_key "dependencies", "versions", on_delete: :cascade
  add_foreign_key "maintainers", "users", on_delete: :cascade
  add_foreign_key "maintainers", "versions", on_delete: :cascade
  add_foreign_key "suggestions", "packages", on_delete: :cascade
  add_foreign_key "suggestions", "versions", on_delete: :cascade
  add_foreign_key "versions", "packages", on_delete: :cascade
end
