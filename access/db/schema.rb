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

ActiveRecord::Schema.define(version: 20150925120614) do

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "first_name_latin"
    t.string   "last_name_latin"
    t.string   "email"
    t.string   "position"
    t.string   "department"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "person_translations", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.string   "department"
  end

  add_index "person_translations", ["locale"], name: "index_person_translations_on_locale"
  add_index "person_translations", ["person_id"], name: "index_person_translations_on_person_id"

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

end
