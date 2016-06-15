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

ActiveRecord::Schema.define(version: 20160603105830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "browser"
    t.string   "ip_address"
    t.string   "controller"
    t.string   "action"
    t.string   "params"
    t.string   "note"
    t.boolean  "is_read"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "parent_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active"
    t.integer  "company_id"
    t.string   "price"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_active"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "value_troy_pt"
    t.string   "value_troy_pd"
    t.string   "value_troy_rh"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "stainless_steel_price"
    t.string   "email"
    t.string   "contact_number"
    t.string   "address"
  end

  add_index "companies", ["contact_number"], name: "index_companies_on_contact_number", unique: true, using: :btree

  create_table "order_details", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "price"
    t.date     "date"
    t.decimal  "quantity",   precision: 12, scale: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "unit_price"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "total_price"
    t.string   "view_order_id"
    t.boolean  "is_closed"
    t.boolean  "is_active"
    t.boolean  "is_delete"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.decimal  "quantity",           precision: 12, scale: 1
    t.boolean  "is_archive_manager"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "serial"
    t.string   "weight"
    t.string   "pt_weight"
    t.string   "pd_weight"
    t.string   "rh_weight"
    t.string   "stainless"
    t.string   "moisture"
    t.integer  "category_id"
    t.string   "category"
    t.string   "make"
    t.string   "model"
    t.string   "image_url"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "image"
    t.boolean  "is_active"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "assay_mat"
    t.string   "value_troy"
    t.string   "stainless_steel_price"
    t.string   "stainless_steel"
    t.string   "value_troy_pt"
    t.string   "value_troy_pd"
    t.string   "value_troy_rh"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "username"
    t.boolean  "is_admin"
    t.boolean  "is_active"
    t.date     "date"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role_id"
    t.integer  "company_id"
    t.integer  "parent_id"
    t.string   "value_troy_rh"
    t.string   "value_troy_pd"
    t.string   "value_troy_pt"
    t.string   "assay_mat"
    t.string   "contact_number"
    t.string   "company_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
