class ChangeSteamMarketPriceOverviewToSteamListing < ActiveRecord::Migration[7.2]
  def change
    rename_table :steam_market_price_overviews, :steam_listings
  end
end
