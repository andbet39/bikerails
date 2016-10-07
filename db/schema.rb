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

ActiveRecord::Schema.define(version: 20161007124439) do

  create_table "meetings", force: :cascade do |t|
    t.string   "title"
    t.float    "start_lat"
    t.float    "start_lng"
    t.datetime "start_time"
    t.float    "duration"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "track_id"
    t.integer  "ride_level_id"
    t.integer  "ride_type_id"
    t.text     "description"
    t.integer  "user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "meeting_id"
    t.integer  "user_id"
  end

  create_table "points", force: :cascade do |t|
    t.float    "lat"
    t.float    "lng"
    t.float    "elevation"
    t.string   "time"
    t.integer  "track_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "real_elevation"
    t.float    "distance"
    t.float    "rate"
  end

  add_index "points", ["track_id"], name: "index_points_on_track_id"

  create_table "ride_levels", force: :cascade do |t|
    t.string   "name"
    t.integer  "val"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ride_types", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "gpx_file_name"
    t.string   "gpx_content_type"
    t.integer  "gpx_file_size"
    t.datetime "gpx_updated_at"
    t.boolean  "is_elaborate"
    t.string   "polyline"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
