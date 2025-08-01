# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_31_155148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kanjis", force: :cascade do |t|
    t.string "character"
    t.string "meanings", default: [], array: true
    t.string "onyomi", default: [], array: true
    t.string "kunyomi", default: [], array: true
    t.string "name_readings", default: [], array: true
    t.string "notes", default: [], array: true
    t.string "heisig_en"
    t.integer "stroke_count"
    t.integer "grade"
    t.integer "jlpt_level"
    t.integer "freq_mainichi_shinbun"
    t.string "unicode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_kanjis", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "kanji_id", null: false
    t.datetime "last_reviewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kanji_id"], name: "index_user_kanjis_on_kanji_id"
    t.index ["user_id"], name: "index_user_kanjis_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "user_kanjis", "kanjis"
  add_foreign_key "user_kanjis", "users"
end
