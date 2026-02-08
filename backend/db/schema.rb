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

ActiveRecord::Schema[8.1].define(version: 2026_02_08_084024) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.bigint "event_id", null: false
    t.datetime "start_time"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_candidates_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "password_digest"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url_token"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "start_time", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["candidate_id"], name: "index_responses_on_candidate_id"
    t.index ["user_id", "candidate_id", "start_time"], name: "unique_user_response", unique: true
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "comment"
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_users_on_event_id"
  end

  add_foreign_key "candidates", "events"
  add_foreign_key "responses", "candidates"
  add_foreign_key "responses", "users"
  add_foreign_key "users", "events"
end
