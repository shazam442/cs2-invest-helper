module MarketHelper
  def market_name(listing)
    return "steam" if listing.is_a? SteamListing
    return "skinport" if listing.is_a? SkinportListing
    "unknown market name"
  end
end
