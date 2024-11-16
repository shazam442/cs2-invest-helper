class AddPriceDataToTrackedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :tracked_items, :price_data, :string
  end
end
