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

ActiveRecord::Schema.define(version: 3) do

  create_table "google_finance_objects", force: :cascade do |t|
    t.string   "owner_instrument_type"
    t.integer  "owner_instrument_id"
    t.integer  "open"
    t.integer  "mktcap"
    t.integer  "shares"
    t.integer  "pe"
    t.integer  "eps"
    t.integer  "beta"
    t.float    "inst_own"
    t.string   "range"
    t.string   "one_year"
    t.string   "vol_per_avg"
    t.string   "div_per_yield"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["owner_instrument_type", "owner_instrument_id"], name: "index_owner_instrument_on_google_finance_object"
  end

  create_table "nasdaq_instruments", force: :cascade do |t|
    t.string   "name"
    t.string   "symbol"
    t.string   "exchange"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "xetra_instruments", force: :cascade do |t|
    t.string   "name"
    t.string   "isin"
    t.string   "symbol"
    t.string   "exchange"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
