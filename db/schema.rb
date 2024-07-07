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

ActiveRecord::Schema[7.0].define(version: 2024_07_07_015639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "followers", id: :string, force: :cascade do |t|
    t.string "follower_id", limit: 36, null: false
    t.string "followed_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", id: :string, force: :cascade do |t|
    t.string "user_id", limit: 36, null: false
    t.string "post_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", id: :string, force: :cascade do |t|
    t.string "user_id", limit: 36, null: false
    t.string "notifiable_id", limit: 36, null: false
    t.string "notifiable_type", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_tags", id: :string, force: :cascade do |t|
    t.string "post_id", limit: 36, null: false
    t.string "tag_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", id: :string, force: :cascade do |t|
    t.string "user_id", limit: 36, null: false
    t.string "code", limit: 36
    t.string "content", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :string, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "code", limit: 36
    t.string "email", limit: 255, null: false
    t.string "password", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.string "avatar_url", limit: 255
    t.string "description", limit: 2500
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "followers", "users", column: "followed_id"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "users"
end
