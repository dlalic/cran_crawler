# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_817_110_239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'authors', force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'user_id'
    t.bigint 'version_id'
    t.index ['user_id'], name: 'index_authors_on_user_id'
    t.index ['version_id'], name: 'index_authors_on_version_id'
  end

  create_table 'dependencies', force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'package_id'
    t.bigint 'version_id'
    t.index ['package_id'], name: 'index_dependencies_on_package_id'
    t.index ['version_id'], name: 'index_dependencies_on_version_id'
  end

  create_table 'maintainers', force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'user_id'
    t.bigint 'version_id'
    t.index ['user_id'], name: 'index_maintainers_on_user_id'
    t.index ['version_id'], name: 'index_maintainers_on_version_id'
  end

  create_table 'packages', force: :cascade do |t|
    t.string 'name'
    t.string 'checksum'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'index_packages_on_name'
  end

  create_table 'suggestions', force: :cascade do |t|
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'package_id'
    t.bigint 'version_id'
    t.index ['package_id'], name: 'index_suggestions_on_package_id'
    t.index ['version_id'], name: 'index_suggestions_on_version_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.text 'email'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'versions', force: :cascade do |t|
    t.string 'number'
    t.string 'title'
    t.string 'description'
    t.string 'required_r_needed'
    t.string 'license'
    t.date 'published_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'package_id'
    t.index ['package_id'], name: 'index_versions_on_package_id'
  end
end