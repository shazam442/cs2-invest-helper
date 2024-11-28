class AddStattrakAndSouvenirToTrackedItem < ActiveRecord::Migration[7.2]
  def change
    add_column :tracked_items, :stattrak, :boolean, default: false, null: false
    add_column :tracked_items, :souvenir, :boolean, default: false, null: false
  end
end
