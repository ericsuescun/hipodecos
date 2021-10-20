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

ActiveRecord::Schema.define(version: 2021_10_20_161144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "automatics", force: :cascade do |t|
    t.string "organ"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auto_type"
    t.integer "user_id"
  end

  create_table "autos", force: :cascade do |t|
    t.bigint "diagcode_id"
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
    t.bigint "inform_id"
    t.integer "user_id"
    t.string "block_tag"
    t.boolean "stored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "organ_code"
    t.integer "fragment"
    t.string "slide_tag"
    t.boolean "verified", default: false
    t.index ["inform_id"], name: "index_blocks_on_inform_id"
  end

  create_table "branches", force: :cascade do |t|
    t.bigint "entity_id"
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

  create_table "citocodes", force: :cascade do |t|
    t.integer "admin_id"
    t.string "cito_code"
    t.text "description"
    t.string "result_type"
    t.decimal "score"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "commentable_id"
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

  create_table "cytologies", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "pregnancies"
    t.string "last_mens"
    t.string "prev_appo"
    t.date "sample_date"
    t.string "last_result"
    t.string "birth_control"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "suggestion"
    t.text "neck_aspect"
    t.string "hysterectomy"
    t.index ["inform_id"], name: "index_cytologies_on_inform_id"
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
    t.integer "organ_code"
  end

  create_table "diagnostics", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "diagcode_id"
    t.string "pss_code"
    t.string "who_code"
    t.string "result"
    t.string "cyto_status"
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
    t.string "tax_id"
  end

  create_table "factors", force: :cascade do |t|
    t.bigint "codeval_id"
    t.bigint "rate_id"
    t.decimal "factor"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cost_id"
    t.decimal "price"
    t.index ["codeval_id"], name: "index_factors_on_codeval_id"
    t.index ["rate_id"], name: "index_factors_on_rate_id"
  end

  create_table "informs", force: :cascade do |t|
    t.bigint "patient_id"
    t.integer "user_id"
    t.integer "physician_id"
    t.string "tag_code"
    t.date "receive_date"
    t.datetime "delivery_date"
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
    t.integer "pathologist_id"
    t.integer "pathologist_review_id"
    t.integer "administrative_review_id"
    t.integer "p_age"
    t.string "p_age_type"
    t.string "p_address"
    t.string "p_email"
    t.string "p_tel"
    t.string "p_cel"
    t.string "p_occupation"
    t.string "p_residence_code"
    t.string "p_municipality"
    t.string "p_department"
    t.string "inf_type"
    t.integer "cytologist"
    t.datetime "download_date"
    t.date "invoice_date"
    t.integer "consecutive"
    t.index ["patient_id"], name: "index_informs_on_patient_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_code"
    t.date "init_date"
    t.date "final_date"
    t.date "invoice_date"
    t.integer "entity_id"
    t.string "inf_type"
    t.decimal "value"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "macros", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_macros_on_inform_id"
  end

  create_table "micros", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cyto_status"
    t.index ["inform_id"], name: "index_micros_on_inform_id"
  end

  create_table "municipalities", force: :cascade do |t|
    t.string "code"
    t.string "municipality"
    t.string "department"
    t.integer "order"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "objectionable_id"
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

  create_table "oldcitos", force: :cascade do |t|
    t.string "clave"
    t.string "numero"
    t.date "fecharec"
    t.date "fecha"
    t.string "apellido"
    t.string "apellido2"
    t.string "nombre"
    t.string "nombre2"
    t.string "identif"
    t.string "cedula"
    t.string "historia"
    t.string "uniedad"
    t.string "edad"
    t.string "sexo"
    t.string "clinica"
    t.string "entidad"
    t.string "entad"
    t.string "codval1"
    t.string "por1"
    t.string "saldo"
    t.string "dnombre"
    t.string "dapellido"
    t.string "oficina"
    t.string "telefono"
    t.text "diag"
    t.text "notas"
    t.text "sugerencia"
    t.string "citologa"
    t.string "patologo"
    t.string "celsup"
    t.string "celint"
    t.string "celpara"
    t.string "plega"
    t.string "agrupa"
    t.string "prestador"
    t.string "factura"
    t.string "autoriz"
    t.string "usuario"
    t.string "ocupacion"
    t.string "residencia"
    t.string "zona"
    t.string "emb"
    t.string "estado"
    t.string "embarazo"
    t.string "fum"
    t.string "citprev"
    t.string "codigo"
    t.string "codcito"
    t.string "vinculado"
    t.string "secretaria"
    t.string "secretauno"
    t.date "fecha1"
    t.date "fechato"
    t.string "resultado"
    t.string "imprimir"
    t.string "revisor"
    t.date "fechanac"
    t.string "sincroniza"
    t.date "fsincro"
    t.string "planifica"
    t.string "muestra"
    t.string "colade"
    t.string "colinad"
    t.string "montade"
    t.string "montainad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
  end

  create_table "oldrecords", force: :cascade do |t|
    t.string "clave"
    t.string "numero"
    t.date "fecharec"
    t.date "fecha"
    t.string "apellido"
    t.string "apellido2"
    t.string "nombre"
    t.string "nombre2"
    t.string "identif"
    t.string "cedula"
    t.string "historia"
    t.string "uniedad"
    t.string "edad"
    t.string "sexo"
    t.string "clinica"
    t.string "entidad"
    t.string "entad"
    t.string "codval1"
    t.string "por1"
    t.string "codval2"
    t.string "por2"
    t.string "codval3"
    t.string "por3"
    t.string "saldo"
    t.text "descr"
    t.text "diagnostic"
    t.string "codigo"
    t.string "codigo1"
    t.string "codigo2"
    t.string "codigo3"
    t.string "codigo4"
    t.string "codigo5"
    t.string "prestador"
    t.string "factura"
    t.string "autoriz"
    t.string "usuario"
    t.string "ocupacion"
    t.string "residencia"
    t.string "zona"
    t.string "emb"
    t.string "estado"
    t.string "telefono"
    t.string "dnombre"
    t.string "dapellido"
    t.string "oficina"
    t.string "bloque"
    t.string "patologo"
    t.string "secretaria"
    t.string "tipo"
    t.string "imprimir"
    t.string "secretauno"
    t.date "fecha1"
    t.string "firma"
    t.string "rango"
    t.string "dx"
    t.string "revisor"
    t.string "tiempo"
    t.string "sincroniza"
    t.date "fsincro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
  end

  create_table "organs", force: :cascade do |t|
    t.integer "admin_id"
    t.string "organ"
    t.string "organ_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "part"
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
    t.string "email", default: "", null: false
    t.string "tel"
    t.string "cel"
    t.string "occupation"
    t.string "residence_code"
    t.string "municipality"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_patients_on_reset_password_token", unique: true
  end

  create_table "physicians", force: :cascade do |t|
    t.bigint "inform_id"
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
    t.bigint "imageable_id"
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
    t.boolean "enabled"
  end

  create_table "rates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "factor"
    t.integer "cost_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.string "tag"
    t.text "description"
    t.integer "samples"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inform_id"], name: "index_recipients_on_inform_id"
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
    t.bigint "inform_id"
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.string "recipient_tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sample_tag"
    t.string "organ_code"
    t.integer "fragment"
    t.string "slide_tag"
    t.boolean "included", default: false
    t.boolean "blocked", default: false
    t.index ["inform_id"], name: "index_samples_on_inform_id"
  end

  create_table "scripts", force: :cascade do |t|
    t.bigint "automatic_id"
    t.string "script_type"
    t.text "description"
    t.string "organ"
    t.integer "param1"
    t.integer "param2"
    t.integer "script_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "diagnostic"
    t.string "pss_code"
    t.string "who_code"
    t.text "suggestion"
    t.index ["automatic_id"], name: "index_scripts_on_automatic_id"
  end

  create_table "slides", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.string "slide_tag"
    t.boolean "stored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.boolean "colored", default: false
    t.boolean "tagged", default: false
    t.boolean "covered", default: false
    t.index ["inform_id"], name: "index_slides_on_inform_id"
  end

  create_table "studies", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.integer "codeval_id"
    t.integer "factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost"
    t.decimal "price"
    t.decimal "margin"
    t.text "price_description"
    t.index ["inform_id"], name: "index_studies_on_inform_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.bigint "inform_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cyto_status"
    t.index ["inform_id"], name: "index_suggestions_on_inform_id"
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
    t.string "emergency_contact"
    t.string "emergency_tel"
    t.string "emergency_cel"
    t.string "cvfile"
    t.string "signfile"
    t.string "contract"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "values", force: :cascade do |t|
    t.bigint "codeval_id"
    t.bigint "cost_id"
    t.decimal "value"
    t.text "description"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codeval_id"], name: "index_values_on_codeval_id"
    t.index ["cost_id"], name: "index_values_on_cost_id"
  end

  add_foreign_key "autos", "diagcodes"
  add_foreign_key "blocks", "informs"
  add_foreign_key "branches", "entities"
  add_foreign_key "cytologies", "informs"
  add_foreign_key "diagnostics", "informs"
  add_foreign_key "factors", "codevals"
  add_foreign_key "factors", "rates"
  add_foreign_key "informs", "patients"
  add_foreign_key "macros", "informs"
  add_foreign_key "micros", "informs"
  add_foreign_key "physicians", "informs"
  add_foreign_key "recipients", "informs"
  add_foreign_key "samples", "informs"
  add_foreign_key "scripts", "automatics"
  add_foreign_key "slides", "informs"
  add_foreign_key "studies", "informs"
  add_foreign_key "suggestions", "informs"
  add_foreign_key "values", "codevals"
  add_foreign_key "values", "costs"
end
