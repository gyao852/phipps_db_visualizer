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

ActiveRecord::Schema.define(version: 20180422211513) do

  create_table "addresses", force: :cascade do |t|
    t.text "address_id"
    t.text "lookup_id"
    t.text "address_1"
    t.text "city"
    t.text "state"
    t.text "zip"
    t.text "country"
    t.text "address_type"
    t.date "date_added"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "constituent_events", force: :cascade do |t|
    t.text "event_id"
    t.text "lookup_id"
    t.text "status"
    t.boolean "attend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "constituent_membership_records", force: :cascade do |t|
    t.text "lookup_id"
    t.text "membership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "constituents", force: :cascade do |t|
    t.text "lookup_id"
    t.text "suffix"
    t.text "title"
    t.text "name"
    t.text "last_group"
    t.text "email_id"
    t.text "phone"
    t.date "dob"
    t.boolean "do_not_email"
    t.boolean "duplicate"
    t.text "constituent_type"
    t.text "phone_notes"
  end

  create_table "contact_histories", force: :cascade do |t|
    t.text "lookup_id"
    t.text "contact_type"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donation_histories", force: :cascade do |t|
    t.text "donation_history_id"
    t.text "donation_program_id"
    t.text "lookup_id"
    t.integer "amount"
    t.date "date"
    t.text "payment_method"
    t.boolean "given_anonymously"
    t.boolean "do_not_acknowledge"
    t.text "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donation_programs", force: :cascade do |t|
    t.text "donation_program_id"
    t.text "program"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.text "event_id"
    t.text "event_name"
    t.date "start_date_time"
    t.date "end_date_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer "userid"
    t.integer "year"
    t.integer "goal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "membership_records", force: :cascade do |t|
    t.text "membership_id"
    t.text "membership_scheme"
    t.text "membership_level"
    t.text "add_ons"
    t.text "membership_level_type"
    t.text "membership_status"
    t.date "start_date"
    t.date "end_date"
    t.date "last_renewed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "unclean_addresses", force: :cascade do |t|
    t.text "address_id"
    t.text "lookup_id"
    t.text "address_1"
    t.text "city"
    t.text "state"
    t.text "zip"
    t.text "country"
    t.text "address_type"
    t.date "date_added"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_constituent_events", force: :cascade do |t|
    t.text "event_id"
    t.text "lookup_id"
    t.text "status"
    t.boolean "attend"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_constituent_membership_records", force: :cascade do |t|
    t.text "lookup_id"
    t.text "membership_id"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_constituents", force: :cascade do |t|
    t.text "lookup_id"
    t.text "suffix"
    t.text "title"
    t.text "name"
    t.text "last_group"
    t.text "email_id"
    t.text "phone"
    t.date "dob"
    t.boolean "do_not_email"
    t.boolean "duplicate"
    t.text "constituent_type"
    t.text "phone_notes"
    t.boolean "incomplete_names"
    t.boolean "invalid_emails"
    t.boolean "invalid_phones"
    t.boolean "invalid_zips"
    t.boolean "no_contact"
    t.text "duplicate_records"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_contact_histories", force: :cascade do |t|
    t.text "contact_history_id"
    t.text "lookup_id"
    t.text "contact_type"
    t.date "date"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_donation_histories", force: :cascade do |t|
    t.text "donation_history_id"
    t.text "donation_program_id"
    t.text "lookup_id"
    t.integer "amount"
    t.date "date"
    t.text "payment_method"
    t.boolean "given_anonymously"
    t.boolean "do_not_acknowledge"
    t.text "transaction_type"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_donation_programs", force: :cascade do |t|
    t.text "donation_program_id"
    t.text "program"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_events", force: :cascade do |t|
    t.text "event_id"
    t.text "event_name"
    t.date "start_date_time"
    t.date "end_date_time"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unclean_membership_records", force: :cascade do |t|
    t.text "membership_id"
    t.text "membership_scheme"
    t.text "membership_level"
    t.text "add_ons"
    t.text "membership_level_type"
    t.text "membership_status"
    t.date "start_date"
    t.date "end_date"
    t.date "last_renewed"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "fname"
    t.text "lname"
    t.text "email_id"
    t.text "password_digest"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
