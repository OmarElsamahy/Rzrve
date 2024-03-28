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

ActiveRecord::Schema[7.1].define(version: 2024_03_26_014755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "name"
    t.string "lookup_key"
    t.string "lat"
    t.string "long"
    t.text "full_address"
    t.string "district"
    t.string "street_information"
    t.string "landmark"
    t.boolean "is_hidden"
    t.boolean "is_default"
    t.bigint "country_id"
    t.bigint "city_id"
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["country_id"], name: "index_addresses_on_country_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "court_id", null: false
    t.bigint "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_bookings_on_court_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.bigint "country_id"
    t.string "name"
    t.string "lookup_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.string "lookup_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso_code"], name: "index_countries_on_iso_code", unique: true
    t.index ["lookup_key"], name: "index_countries_on_lookup_key", unique: true
  end

  create_table "court_availabilities", force: :cascade do |t|
    t.bigint "court_id", null: false
    t.string "day_of_week"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_court_availabilities_on_court_id"
  end

  create_table "courts", force: :cascade do |t|
    t.bigint "venue_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_courts_on_venue_id"
  end

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

  create_table "media", force: :cascade do |t|
    t.string "mediable_type"
    t.bigint "mediable_id"
    t.integer "media_type", default: 0
    t.string "file_name"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mediable_type", "mediable_id"], name: "index_media_on_mediable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
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
    t.index ["email"], name: "index_users_on_email", unique: true, where: "((status = 0) AND (email IS NOT NULL))"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "email"
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
    t.integer "profile_status"
    t.string "country_code"
    t.string "phone_number"
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_verified_at"], name: "index_vendors_on_account_verified_at"
    t.index ["country_code", "phone_number", "status"], name: "index_vendors_on_country_code_and_phone_number_and_status", unique: true, where: "(status = 0)"
    t.index ["email", "status"], name: "index_vendors_on_email_and_status", unique: true, where: "((status = 0) AND (email_verified_at IS NOT NULL))"
    t.index ["email"], name: "index_vendors_on_email", unique: true, where: "((status = 0) AND (email IS NOT NULL))"
    t.index ["reset_password_token"], name: "index_vendors_on_reset_password_token", unique: true
    t.index ["status"], name: "index_vendors_on_status"
  end

  create_table "venues", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_venues_on_city_id"
    t.index ["vendor_id"], name: "index_venues_on_vendor_id"
  end

  add_foreign_key "bookings", "courts"
  add_foreign_key "bookings", "users"
  add_foreign_key "cities", "countries"
  add_foreign_key "court_availabilities", "courts"
  add_foreign_key "courts", "venues"
  add_foreign_key "venues", "cities"
  add_foreign_key "venues", "vendors"
end
