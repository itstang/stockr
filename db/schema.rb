# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151128214509) do

  create_table "dividends", force: :cascade do |t|
    t.string  "symbol"
    t.integer "dividend"
    t.integer "interval"
  end

  add_index "dividends", ["symbol"], name: "index_dividends_on_symbol", unique: true

  create_table "ownerships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.integer  "shares"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ownerships", ["stock_id"], name: "index_ownerships_on_stock_id"
  add_index "ownerships", ["user_id"], name: "index_ownerships_on_user_id"

  create_table "processes", force: :cascade do |t|
    t.string  "symbol"
    t.integer "news_sentiment"
    t.integer "social_sentiment"
    t.string  "name"
  end

  add_index "processes", ["symbol"], name: "index_processes_on_symbol", unique: true

  create_table "rankings", force: :cascade do |t|
    t.integer "rank"
    t.integer "interval"
  end

  add_index "rankings", ["rank"], name: "index_rankings_on_rank", unique: true

  create_table "stocks", force: :cascade do |t|
    t.string   "symbol"
    t.string   "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_id"
    t.string  "type"
    t.integer "amount"
  end

  add_index "transactions", ["transaction_id"], name: "index_transactions_on_transaction_id", unique: true

  create_table "user_makes", force: :cascade do |t|
    t.string  "email"
    t.integer "transaction_id"
  end

  add_index "user_makes", ["email"], name: "index_user_makes_on_email", unique: true
  add_index "user_makes", ["transaction_id"], name: "index_user_makes_on_transaction_id", unique: true

  create_table "user_owns", force: :cascade do |t|
    t.string  "email"
    t.string  "symbol"
    t.integer "shares"
  end

  create_table "user_watches", force: :cascade do |t|
    t.string "email"
    t.string "symbol"
  end

  add_index "user_watches", ["email"], name: "index_user_watches_on_email", unique: true
  add_index "user_watches", ["symbol"], name: "index_user_watches_on_symbol", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.decimal  "balance"
    t.integer  "rank"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
