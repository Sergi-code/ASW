# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_07_161256) do

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.integer "submit_id"
    t.string "user_id"
    t.integer "votes"
    t.string "nomautor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "votedby"
  end

  create_table "replies", force: :cascade do |t|
    t.string "text"
    t.integer "comment_id"
    t.string "user_id"
    t.integer "votes"
    t.string "nomautor"
    t.string "votedby"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "replyid"
  end

  create_table "submits", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "text"
    t.string "userpost"
    t.integer "votes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id"
    t.string "votedby"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "oauth_token"
    t.string "string"
  end

end
