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

ActiveRecord::Schema.define(version: 2019_11_07_221345) do

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

  create_table "autos", force: :cascade do |t|
    t.integer "diagcode_id"
    t.integer "user_id"
    t.integer "admin_id"
    t.string "title"
    t.text "body"
    t.string "param1"
    t.string "param2"
    t.string "param3"
    t.string "param4"
    t.string "param5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagcode_id"], name: "index_autos_on_diagcode_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.string "block_tag"
    t.boolean "stored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["inform_id"], name: "index_blocks_on_inform_id"
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
    t.string "name"
    t.string "code"
    t.text "description"
    t.string "origin_system"
    t.string "ref_code"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "user_id"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  end

  create_table "costs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "base"
    t.decimal "factor"
  end

  create_table "diagcodes", force: :cascade do |t|
    t.integer "admin_id"
    t.string "organ"
    t.string "feature1"
    t.string "feature2"
    t.string "feature3"
    t.string "feature4"
    t.string "feature5"
    t.text "description"
    t.string "pss_code"
    t.string "who_code"
    t.decimal "score"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diagnostics", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_diagnostics_on_inform_id"
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
    t.integer "cost_id"
    t.integer "rate_id"
  end

  create_table "factors", force: :cascade do |t|
    t.integer "codeval_id"
    t.integer "rate_id"
    t.decimal "factor"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codeval_id"], name: "index_factors_on_codeval_id"
    t.index ["rate_id"], name: "index_factors_on_rate_id"
  end

  create_table "informs", force: :cascade do |t|
    t.integer "patient_id"
    t.integer "user_id"
    t.integer "physician_id"
    t.string "tag_code"
    t.date "receive_date"
    t.date "delivery_date"
    t.date "user_review_date"
    t.string "prmtr_auth_code"
    t.string "zone_type"
    t.string "pregnancy_status"
    t.string "status"
    t.string "regime"
    t.integer "promoter_id"
    t.integer "entity_id"
    t.integer "branch_id"
    t.decimal "copayment"
    t.decimal "cost"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice"
    t.string "inf_status"
    t.index ["patient_id"], name: "index_informs_on_patient_id"
  end

  create_table "macros", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_macros_on_inform_id"
  end

  create_table "micros", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_micros_on_inform_id"
  end

  create_table "obcodes", force: :cascade do |t|
    t.integer "admin_id"
    t.string "title"
    t.string "process"
    t.decimal "score"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "objections", force: :cascade do |t|
    t.string "objectionable_type"
    t.integer "objectionable_id"
    t.integer "user_id"
    t.integer "obcode_id"
    t.integer "responsible_user_id"
    t.integer "close_user_id"
    t.date "close_date"
    t.text "description"
    t.boolean "closed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["objectionable_type", "objectionable_id"], name: "index_objections_on_objectionable_type_and_objectionable_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "id_number"
    t.string "id_type"
    t.date "birth_date"
    t.integer "age_number"
    t.string "age_type"
    t.string "name1"
    t.string "name2"
    t.string "lastname1"
    t.string "lastname2"
    t.string "sex"
    t.string "gender"
    t.string "address"
    t.string "email"
    t.string "tel"
    t.string "cel"
    t.string "occupation"
    t.string "residence_code"
    t.string "municipality"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "physicians", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.string "name"
    t.string "lastname"
    t.string "tel"
    t.string "cel"
    t.string "email"
    t.string "study1"
    t.string "study2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_physicians_on_inform_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "imageable_type"
    t.integer "imageable_id"
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "promoters", force: :cascade do |t|
    t.string "name"
    t.string "initials"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "regime"
  end

  create_table "rates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "factor"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "admin_id"
    t.string "name"
    t.text "description"
    t.decimal "rate"
    t.decimal "time"
    t.decimal "health_care_rate"
    t.decimal "pension_rate"
    t.decimal "parafiscal_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.string "specimen_tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sample_tag"
    t.index ["inform_id"], name: "index_samples_on_inform_id"
  end

  create_table "slides", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.string "slide_tag"
    t.boolean "stored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["inform_id"], name: "index_slides_on_inform_id"
  end

  create_table "studies", force: :cascade do |t|
    t.integer "inform_id"
    t.integer "user_id"
    t.integer "codeval_id"
    t.integer "factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_studies_on_inform_id"
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

  create_table "values", force: :cascade do |t|
    t.integer "codeval_id"
    t.integer "cost_id"
    t.decimal "value"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codeval_id"], name: "index_values_on_codeval_id"
    t.index ["cost_id"], name: "index_values_on_cost_id"
  end

end
