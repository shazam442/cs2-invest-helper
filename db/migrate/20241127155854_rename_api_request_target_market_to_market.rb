class RenameApiRequestTargetMarketToMarket < ActiveRecord::Migration[7.2]
  def change
    rename_column :api_requests, :target_market, :market
  end
end
