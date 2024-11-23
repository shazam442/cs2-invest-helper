class CreateSteamMarketPriceOverviews < ActiveRecord::Migration[7.2]
  def change
    create_table :steam_market_price_overviews do |t|
      t.references :tracked_item_id, null: false, foreign_key: true
      t.decimal :lowest_price, precision: 8, scale: 2
      t.decimal :median_price, precision: 8, scale: 2
      t.integer :volume_sold
      t.datetime :last_request_time
      t.boolean :last_request_success, default: false, null: false
      t.string :last_request_response

      t.timestamps
    end

    change_table :tracked_items do |t|
      t.remove :lowest_price, :median_price, :volume_sold, :last_request_success, :last_request_time, :price_overview_json
    end
  end
end
