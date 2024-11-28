class AddLastRequestResponseCodeToSteamMarketPriceOverview < ActiveRecord::Migration[7.2]
  def change
    add_column :steam_market_price_overviews, :last_request_response_code, :integer
  end
end
