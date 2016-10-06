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

ActiveRecord::Schema.define(version: 20161006084327) do

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
  end

end
