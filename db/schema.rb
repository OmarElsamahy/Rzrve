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

ActiveRecord::Schema[7.1].define(version: 2024_03_15_213858) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.string "authenticable_type"
    t.bigint "authenticable_id"
    t.text "fcm_token"
    t.integer "device_type", default: 0
    t.boolean "logged_out", default: true
    t.string "locale", default: "en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticable_type", "authenticable_id"], name: "index_devices_on_authenticable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "verification_code"
    t.datetime "verification_code_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "unconfirmed_email"
    t.string "unconfirmed_country_code"
    t.string "unconfirmed_phone_number"
    t.datetime "phone_number_verified_at", precision: nil
    t.datetime "email_verified_at", precision: nil
    t.datetime "account_verified_at", precision: nil
    t.string "name"
    t.integer "status"
    t.string "country_code"
    t.string "phone_number"
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_verified_at"], name: "index_users_on_account_verified_at"
    t.index ["country_code", "phone_number", "status"], name: "index_users_on_country_code_and_phone_number_and_status", unique: true, where: "(status = 0)"
    t.index ["email", "status"], name: "index_users_on_email_and_status", unique: true, where: "((status = 0) AND (email_verified_at IS NOT NULL))"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(status = 0)"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

end
