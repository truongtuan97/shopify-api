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

ActiveRecord::Schema.define(version: 20161124081836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "gift_card_code"
    t.integer "price"
  end

  create_table "gift_card_useds", force: :cascade do |t|
    t.string   "gift_card_code"
    t.string   "email"
    t.datetime "time_send_email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "request_from"
  end

  create_table "gift_cards", force: :cascade do |t|
    t.string   "gift_card_code"
    t.integer  "price"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "used",           default: false
  end

  create_table "shopifies", force: :cascade do |t|
    t.string   "request_gift_card"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "sent_email"
    t.string   "hmac_header"
    t.integer  "count_hmac_header"
  end

end
