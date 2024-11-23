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

ActiveRecord::Schema[7.2].define(version: 2024_11_23_163033) do
  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "steam_market_price_overviews", force: :cascade do |t|
    t.integer "tracked_item_id_id", null: false
    t.decimal "lowest_price", precision: 8, scale: 2
    t.decimal "median_price", precision: 8, scale: 2
    t.integer "volume_sold"
    t.datetime "last_request_time"
    t.boolean "last_request_success", default: false, null: false
    t.string "last_request_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tracked_item_id_id"], name: "index_steam_market_price_overviews_on_tracked_item_id_id"
  end

  create_table "tracked_items", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wear", null: false
  end

  add_foreign_key "steam_market_price_overviews", "tracked_item_ids"
end
