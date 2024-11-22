class RenameItemNameToNameAndAddWearToTrackedItems < ActiveRecord::Migration[7.2]
  def change
    rename_column :tracked_items, :item_name, :name

    # 0 should be non_wear
    add_column :tracked_items, :wear, :integer
  end
end
