class AddSteamListingReferenceToApiRequests < ActiveRecord::Migration[7.2]
  def change
    add_reference :api_requests, :tracked_item, null: true, foreign_key: true
  end
end
