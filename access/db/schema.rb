# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151012182419) do

  create_table "alternative_emails", force: :cascade do |t|
    t.integer  "person_id",                          null: false
    t.string   "email",                              null: false
    t.boolean  "verified",           default: false, null: false
    t.string   "verification_token"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "alternative_emails", ["person_id"], name: "index_alternative_emails_on_person_id"

  create_table "organization_translations", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.text     "description"
  end

  add_index "organization_translations", ["locale"], name: "index_organization_translations_on_locale"
  add_index "organization_translations", ["organization_id"], name: "index_organization_translations_on_organization_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "domain"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "first_name_latin"
    t.string   "last_name_latin"
    t.string   "email"
    t.boolean  "verified",            default: false, null: false
    t.string   "verification_token"
    t.string   "phone_number"
    t.string   "department"
    t.integer  "position_id"
    t.integer  "scientific_field_id"
    t.integer  "organization_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "people", ["organization_id"], name: "index_people_on_organization_id"
  add_index "people", ["position_id"], name: "index_people_on_position_id"
  add_index "people", ["scientific_field_id"], name: "index_people_on_scientific_field_id"

  create_table "person_editable_fields", force: :cascade do |t|
    t.boolean  "first_name_editable"
    t.boolean  "last_name_editable"
    t.boolean  "first_name_latin_editable"
    t.boolean  "last_name_latin_editable"
    t.boolean  "email_editable"
    t.boolean  "verified_editable"
    t.boolean  "verification_token_editable"
    t.boolean  "phone_number_editable"
    t.boolean  "department_editable"
    t.boolean  "position_id_editable"
    t.boolean  "scientific_field_id_editable"
    t.boolean  "organization_id_editable"
    t.integer  "person_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "person_editable_fields", ["person_id"], name: "index_person_editable_fields_on_person_id"

  create_table "person_translations", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "department"
  end

  add_index "person_translations", ["locale"], name: "index_person_translations_on_locale"
  add_index "person_translations", ["person_id"], name: "index_person_translations_on_person_id"

  create_table "position_translations", force: :cascade do |t|
    t.integer  "position_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  add_index "position_translations", ["locale"], name: "index_position_translations_on_locale"
  add_index "position_translations", ["position_id"], name: "index_position_translations_on_position_id"

  create_table "positions", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "scientific_field_translations", force: :cascade do |t|
    t.integer  "scientific_field_id", null: false
    t.string   "locale",              null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "description"
  end

  add_index "scientific_field_translations", ["locale"], name: "index_scientific_field_translations_on_locale"
  add_index "scientific_field_translations", ["scientific_field_id"], name: "index_scientific_field_translations_on_scientific_field_id"

  create_table "scientific_fields", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 1073741823
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
