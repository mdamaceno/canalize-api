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

ActiveRecord::Schema[8.0].define(version: 2025_08_02_212754) do
  create_table "contacts", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.date "birthdate"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_contacts_on_identifier", unique: true
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "email_addresses", force: :cascade do |t|
    t.string "email", null: false
    t.integer "contact_id", null: false
    t.integer "label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_email_addresses_on_contact_id"
    t.index ["email", "contact_id"], name: "index_email_addresses_on_email_and_contact_id", unique: true
    t.index ["label_id"], name: "index_email_addresses_on_label_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_labels_on_user_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.integer "country_code", null: false
    t.string "main", null: false
    t.integer "contact_id", null: false
    t.integer "label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_phone_numbers_on_contact_id"
    t.index ["country_code", "main", "contact_id"], name: "index_phone_numbers_on_country_code_and_main_and_contact_id", unique: true
    t.index ["label_id"], name: "index_phone_numbers_on_label_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.string "identifier", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["identifier"], name: "index_users_on_identifier", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "email_addresses", "contacts"
  add_foreign_key "email_addresses", "labels"
  add_foreign_key "labels", "users"
  add_foreign_key "phone_numbers", "contacts"
  add_foreign_key "phone_numbers", "labels"
end
