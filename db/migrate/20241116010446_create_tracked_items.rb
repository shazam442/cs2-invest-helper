class CreateTrackedItems < ActiveRecord::Migration[7.2]
  def change
    create_table :tracked_items do |t|
      t.string :item_name

      t.timestamps
    end
  end
end
