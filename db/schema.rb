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

ActiveRecord::Schema.define(version: 2019_10_11_211416) do

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "tel"
    t.string "cel"
    t.string "address"
    t.boolean "god_mode"
    t.boolean "reports_only"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email2"
    t.string "tel"
    t.string "cel"
    t.date "birth_date"
    t.date "join_date"
    t.boolean "active"
    t.date "deactivation_date"
    t.integer "last_admin_id"
    t.text "notes"
    t.integer "role_id"
    t.integer "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
