class RemoveLastRequestTimeFromSteamListing < ActiveRecord::Migration[7.2]
  def change
    remove_column :steam_listings, :last_request_time, :datetime
    remove_column :steam_listings, :last_request_success, :boolean
    remove_column :steam_listings, :last_request_response, :json

    rename_column :steam_listings, :lowest_price, :min_price
  end
end
