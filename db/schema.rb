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

ActiveRecord::Schema.define(version: 20180327095124) do

  create_table "constituents", force: :cascade do |t|
    t.integer "lookup_id"
    t.text "suffix"
    t.text "title"
    t.text "name"
    t.text "last_group"
    t.text "email_id"
    t.text "phone"
    t.date "dob"
    t.boolean "do_not_email"
    t.boolean "duplicate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donation_histories", force: :cascade do |t|
    t.integer "donation_history_id"
    t.integer "lookup_id"
    t.integer "amount"
    t.date "date"
    t.text "method"
    t.boolean "do_not_acknowledge"
    t.boolean "given_anonymously"
    t.text "transaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
