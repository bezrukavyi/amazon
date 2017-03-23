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

ActiveRecord::Schema.define(version: 20170321212507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.integer "author_id"
    t.integer "book_id"
    t.index ["author_id"], name: "index_authors_books_on_author_id", using: :btree
    t.index ["book_id"], name: "index_authors_books_on_book_id", using: :btree
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.text     "desc"
    t.decimal  "price",       precision: 10, scale: 2
    t.integer  "count"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "category_id"
    t.string   "avatar"
    t.json     "dimension",                            default: []
    t.index ["category_id"], name: "index_books_on_category_id", using: :btree
    t.index ["title"], name: "index_books_on_title", using: :btree
  end

  create_table "books_materials", id: false, force: :cascade do |t|
    t.integer "book_id",     null: false
    t.integer "material_id", null: false
    t.index ["book_id", "material_id"], name: "index_books_materials_on_book_id_and_material_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "books_count", default: 0
    t.index ["title"], name: "index_categories_on_title", using: :btree
  end

  create_table "corzinus_addresses", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "city"
    t.string   "zip"
    t.string   "phone"
    t.integer  "address_type"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.integer  "country_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["addressable_type", "addressable_id"], name: "index_corzinus_addresses_on_addressable_type_and_addressable_id", using: :btree
    t.index ["country_id"], name: "index_corzinus_addresses_on_country_id", using: :btree
  end

  create_table "corzinus_countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corzinus_coupons", force: :cascade do |t|
    t.integer  "discount"
    t.string   "code"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_corzinus_coupons_on_code", using: :btree
    t.index ["order_id"], name: "index_corzinus_coupons_on_order_id", using: :btree
  end

  create_table "corzinus_credit_cards", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.string   "cvv"
    t.string   "month_year"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_corzinus_credit_cards_on_person_id", using: :btree
  end

  create_table "corzinus_deliveries", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",      precision: 10, scale: 2
    t.integer  "min_days"
    t.integer  "max_days"
    t.integer  "country_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["country_id"], name: "index_corzinus_deliveries_on_country_id", using: :btree
  end

  create_table "corzinus_inventories", force: :cascade do |t|
    t.integer  "count"
    t.string   "productable_type"
    t.integer  "productable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["productable_type", "productable_id"], name: "index_corzinus_inventory_productable", using: :btree
  end

  create_table "corzinus_inventory_sales", force: :cascade do |t|
    t.integer  "start_stock"
    t.integer  "finish_stock"
    t.integer  "inventory_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["inventory_id"], name: "index_corzinus_inventory_sales_on_inventory_id", using: :btree
  end

  create_table "corzinus_inventory_supplies", force: :cascade do |t|
    t.integer  "size"
    t.datetime "arrived_at"
    t.integer  "inventory_sale_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["inventory_sale_id"], name: "index_corzinus_inventory_supplies_on_inventory_sale_id", using: :btree
  end

  create_table "corzinus_order_items", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "order_id"
    t.string   "productable_type"
    t.integer  "productable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["order_id"], name: "index_corzinus_order_items_on_order_id", using: :btree
    t.index ["productable_type", "productable_id"], name: "index_corzinus_productable", using: :btree
  end

  create_table "corzinus_orders", force: :cascade do |t|
    t.string   "state"
    t.decimal  "total_price",      precision: 10, scale: 2
    t.boolean  "use_base_address"
    t.integer  "delivery_id"
    t.integer  "credit_card_id"
    t.integer  "person_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "paid_at"
    t.index ["credit_card_id"], name: "index_corzinus_orders_on_credit_card_id", using: :btree
    t.index ["delivery_id"], name: "index_corzinus_orders_on_delivery_id", using: :btree
    t.index ["person_id"], name: "index_corzinus_orders_on_person_id", using: :btree
  end

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_materials_on_name", unique: true, using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "path"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_providers_on_user_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "grade"
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "verified",   default: false
    t.string   "state"
    t.index ["book_id"], name: "index_reviews_on_book_id", using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
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
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.string   "avatar"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "authors_books", "authors"
  add_foreign_key "authors_books", "books"
  add_foreign_key "books", "categories"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
end
