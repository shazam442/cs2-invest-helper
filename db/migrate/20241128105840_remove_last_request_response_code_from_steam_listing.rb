class RemoveLastRequestResponseCodeFromSteamListing < ActiveRecord::Migration[7.2]
  def change
    remove_column :steam_listings, :last_request_response_code, :integer
  end
end
