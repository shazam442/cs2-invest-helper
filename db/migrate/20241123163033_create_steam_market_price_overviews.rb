class CreateSteamMarketPriceOverviews < ActiveRecord::Migration[7.2]
  def change
    create_table :steam_market_price_overviews do |t|
      t.references :tracked_item, null: false, foreign_key: true
      t.decimal :lowest_price, precision: 8, scale: 2
      t.decimal :median_price, precision: 8, scale: 2
      t.integer :volume_sold
      t.datetime :last_request_time
      t.boolean :last_request_success, default: false, null: false
      t.string :last_request_response

      t.timestamps
    end

    remove_column :tracked_items, :lowest_price, :decimal
    remove_column :tracked_items, :median_price, :decimal
    remove_column :tracked_items, :volume_sold, :integer
    remove_column :tracked_items, :last_request_success, :boolean
    remove_column :tracked_items, :last_request_time, :datetime
    remove_column :tracked_items, :price_overview_json, :json
  end
end
