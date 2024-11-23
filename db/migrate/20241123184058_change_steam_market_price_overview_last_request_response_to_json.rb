class ChangeSteamMarketPriceOverviewLastRequestResponseToJson < ActiveRecord::Migration[7.2]
  def up
    change_column :steam_market_price_overviews, :last_request_response, :json
  end

  def down
    change_column :steam_market_price_overviews, :last_request_response, :string
  end
end
