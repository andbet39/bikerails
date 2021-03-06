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

ActiveRecord::Schema.define(version: 20161009121719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_index "points", ["track_id"], name: "index_points_on_track_id", using: :btree

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
    t.float    "ascention"
    t.float    "length"
    t.float    "descent"
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
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "meetings", "ride_levels"
  add_foreign_key "meetings", "ride_types"
  add_foreign_key "meetings", "tracks"
  add_foreign_key "meetings", "users"
  add_foreign_key "participations", "meetings"
  add_foreign_key "participations", "users"
  add_foreign_key "points", "tracks"
end
