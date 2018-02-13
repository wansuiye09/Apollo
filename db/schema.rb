# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180213064820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "json_schema_version_references", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "referenced_version_id"
    t.uuid "referencing_version_id"
    t.index ["referenced_version_id"], name: "index_json_schema_version_references_on_referenced_version_id"
    t.index ["referencing_version_id"], name: "index_json_schema_version_references_on_referencing_version_id"
  end

  create_table "json_schema_versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "json_schema_id"
    t.integer "version_number", null: false
    t.string "schema_ref", null: false
    t.json "schema", default: {}, null: false
    t.json "example", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["json_schema_id", "version_number"], name: "index_json_schema_versions_on_json_schema_id_and_version_number", unique: true
    t.index ["json_schema_id"], name: "index_json_schema_versions_on_json_schema_id"
  end

  create_table "json_schemas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "schema_ref", null: false
    t.json "schema", default: {}, null: false
    t.json "example", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "json_schema_version_references", "json_schema_versions", column: "referenced_version_id"
  add_foreign_key "json_schema_version_references", "json_schema_versions", column: "referencing_version_id"
  add_foreign_key "json_schema_versions", "json_schemas", on_delete: :cascade
end
