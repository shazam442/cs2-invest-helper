class AddLowestPriceAndLastRequestToTrackedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :tracked_items, :lowest_price, :string
    add_column :tracked_items, :median_price, :string
    add_column :tracked_items, :last_request_success, :boolean, default: false, null: false
  end
end
