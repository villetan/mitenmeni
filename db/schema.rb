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

ActiveRecord::Schema.define(version: 20160501151523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendships", primary_key: "friendship_id", force: :cascade do |t|
    t.integer "friend_a_id"
    t.integer "friend_b_id"
    t.string  "status",      limit: 20, null: false
  end

  create_table "ratings", primary_key: "rating_id", force: :cascade do |t|
    t.integer "user_id"
    t.integer "score"
    t.string  "place_id", limit: 255
    t.string  "comment",  limit: 1000
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "username",           limit: 30, null: false
    t.string "password_salt",      limit: 64
    t.string "password_encrypted", limit: 64
  end

  add_index "users", ["username"], name: "users_username_key", unique: true, using: :btree

  add_foreign_key "friendships", "users", column: "friend_a_id", primary_key: "user_id", name: "friendship_friend_a_id_fkey"
  add_foreign_key "friendships", "users", column: "friend_b_id", primary_key: "user_id", name: "friendship_friend_b_id_fkey"
  add_foreign_key "ratings", "users", primary_key: "user_id", name: "ratings_user_id_fkey"
end
