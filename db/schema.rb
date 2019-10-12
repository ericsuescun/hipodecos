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

ActiveRecord::Schema.define(version: 2019_10_12_043433) do

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "tel"
    t.string "cel"
    t.string "address"
    t.boolean "god_mode"
    t.boolean "reports_only"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "branches", force: :cascade do |t|
    t.integer "entity_id"
    t.string "name"
    t.string "initials"
    t.string "code"
    t.string "mgr_name"
    t.string "mgr_email"
    t.string "mgr_tel"
    t.string "mgr_cel"
    t.string "municipality"
    t.string "department"
    t.string "address"
    t.string "entype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_branches_on_entity_id"
  end

  create_table "codevals", force: :cascade do |t|
    t.string "code"
    t.text "description"
    t.string "origin_system"
    t.string "oms_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "costs", force: :cascade do |t|
    t.integer "codeval_id"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codeval_id"], name: "index_costs_on_codeval_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.string "initials"
    t.string "code"
    t.string "mgr_name"
    t.string "mgr_email"
    t.string "mgr_tel"
    t.string "mgr_cel"
    t.string "municipality"
    t.string "department"
    t.string "address"
    t.string "entype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promoters", force: :cascade do |t|
    t.string "name"
    t.string "initials"
    t.string "code"
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
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
