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

ActiveRecord::Schema.define(version: 2020_11_02_181938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tokens", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "weight", default: "0.0", null: false
    t.decimal "frequency_in_file", default: "0.0", null: false
    t.bigint "uploaded_file_id"
    t.index ["uploaded_file_id"], name: "index_tokens_on_uploaded_file_id"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "file_name", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
  end

  add_foreign_key "tokens", "uploaded_files"
end
