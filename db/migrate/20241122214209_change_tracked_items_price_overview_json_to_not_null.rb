class ChangeTrackedItemsPriceOverviewJsonToNotNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :tracked_items, :price_overview_json, false
  end
end
