class ChangeTrackedItemsPriceOverviewJsonToJsonb < ActiveRecord::Migration[7.2]
  def change
    change_column :tracked_items, :price_overview_json, :jsonb
  end
end
