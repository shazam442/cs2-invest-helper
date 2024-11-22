class RenameItemNameToNameAndAddWearToTrackedItems < ActiveRecord::Migration[7.2]
  def change
    rename_column :tracked_items, :item_name, :name

    # TrackedItem.wears[:no_wear] is 0
    add_column :tracked_items, :wear, :integer, default: TrackedItem.wears[:no_wear], null: false
  end
end
