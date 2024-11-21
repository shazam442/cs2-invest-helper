class AddLastRequestTimeToTrackedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :tracked_items, :last_request_time, :datetime
  end
end
