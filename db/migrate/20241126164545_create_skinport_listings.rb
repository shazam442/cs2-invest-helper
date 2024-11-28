class CreateSkinportListings < ActiveRecord::Migration[7.2]
  def change
    create_table :skinport_listings do |t|
      # add reference to tracked_item
      t.references :tracked_item, null: false, foreign_key: true
      t.decimal :min_price
      t.decimal :max_price
      t.decimal :mean_price
      t.decimal :median_price
      t.decimal :suggested_price
      t.integer :quantity
      t.datetime :posted_on_market_at
      t.datetime :edited_on_market_at
      t.datetime :last_request_time
      t.datetime :last_request_success

      t.timestamps
    end
  end
end
