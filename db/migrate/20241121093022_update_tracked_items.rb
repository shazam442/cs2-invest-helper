class UpdateTrackedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :tracked_items, :volume_sold, :integer
    rename_column :tracked_items, :price_data, :price_overview_json
    change_column :tracked_items, :price_overview_json, :json
  end
end
