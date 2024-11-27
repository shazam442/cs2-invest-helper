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

ActiveRecord::Schema[7.2].define(version: 2024_11_27_174222) do
  create_table "api_requests", force: :cascade do |t|
    t.integer "market", null: false
    t.string "target_url", null: false
    t.boolean "success", default: false, null: false
    t.json "response_body"
    t.integer "response_code"
    t.json "request_body", default: {}, null: false
    t.datetime "request_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skinport_listings", force: :cascade do |t|
    t.integer "tracked_item_id", null: false
    t.decimal "min_price"
    t.decimal "max_price"
    t.decimal "mean_price"
    t.decimal "median_price"
    t.decimal "suggested_price"
    t.integer "quantity"
    t.datetime "posted_on_market_at"
    t.datetime "edited_on_market_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "item_page"
    t.string "market_page"
    t.index ["tracked_item_id"], name: "index_skinport_listings_on_tracked_item_id"
  end

  create_table "steam_listings", force: :cascade do |t|
    t.integer "tracked_item_id", null: false
    t.decimal "lowest_price", precision: 8, scale: 2
    t.decimal "median_price", precision: 8, scale: 2
    t.integer "volume_sold"
    t.datetime "last_request_time"
    t.boolean "last_request_success", default: false, null: false
    t.json "last_request_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_request_response_code"
    t.index ["tracked_item_id"], name: "index_steam_listings_on_tracked_item_id"
  end

  create_table "tracked_items", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wear", null: false
    t.boolean "stattrak", default: false, null: false
    t.boolean "souvenir", default: false, null: false
  end

  add_foreign_key "skinport_listings", "tracked_items"
  add_foreign_key "steam_listings", "tracked_items"
end
