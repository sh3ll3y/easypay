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

ActiveRecord::Schema.define(version: 2024_09_20_080302) do

  create_table "billers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "biller_id"
    t.json "plans"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["biller_id"], name: "index_billers_on_biller_id", unique: true
    t.index ["deleted_at"], name: "index_billers_on_deleted_at"
  end

  create_table "bills", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "bill_amount", precision: 10, scale: 2, null: false
    t.date "bill_date", null: false
    t.date "due_date", null: false
    t.string "status", default: "pending", null: false
    t.bigint "user_id", null: false
    t.string "description"
    t.datetime "paid_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bill_date"], name: "index_bills_on_bill_date"
    t.index ["due_date"], name: "index_bills_on_due_date"
    t.index ["status"], name: "index_bills_on_status"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "downloads", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.string "file_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_downloads_on_user_id"
  end

  create_table "repayments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.date "payment_date", null: false
    t.bigint "bill_id", null: false
    t.bigint "user_id", null: false
    t.string "payment_method", null: false
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bill_id"], name: "index_repayments_on_bill_id"
    t.index ["payment_date"], name: "index_repayments_on_payment_date"
    t.index ["payment_method"], name: "index_repayments_on_payment_method"
    t.index ["user_id"], name: "index_repayments_on_user_id"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "txn_id", null: false
    t.bigint "user_id", null: false
    t.bigint "biller_id", null: false
    t.string "mobile_number", null: false
    t.json "plan", null: false
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.index ["biller_id"], name: "index_transactions_on_biller_id"
    t.index ["status"], name: "index_transactions_on_status"
    t.index ["txn_id"], name: "index_transactions_on_txn_id", unique: true
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "credit", precision: 10, scale: 2, default: "0.0"
    t.boolean "admin", default: false
    t.datetime "deleted_at"
    t.string "language"
    t.decimal "credit_limit", precision: 10, scale: 2, default: "1000000.0"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bills", "users"
  add_foreign_key "downloads", "users"
  add_foreign_key "repayments", "bills"
  add_foreign_key "repayments", "users"
  add_foreign_key "transactions", "billers"
  add_foreign_key "transactions", "users"
end
