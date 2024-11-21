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

ActiveRecord::Schema[7.2].define(version: 2024_11_21_101807) do
  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracked_items", force: :cascade do |t|
    t.string "item_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "price_overview_json"
    t.integer "volume_sold"
    t.string "lowest_price"
    t.string "median_price"
    t.boolean "last_request_success", default: false, null: false
  end
end
