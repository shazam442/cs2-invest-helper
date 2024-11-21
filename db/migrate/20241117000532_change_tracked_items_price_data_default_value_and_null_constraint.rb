class ChangeTrackedItemsPriceDataDefaultValueAndNullConstraint < ActiveRecord::Migration[7.2]
    # change tracked_items price_data to json field and ensure it is reversible
    def up
      change_column :tracked_items, :price_data, :json, default: "{}", null: false
      change_column :tracked_items, :item_name, :string, null: false
    end

    def down
      change_column :tracked_items, :price_data, :string, default: nil, null: true
    end
end
