class SteamListingSyncService
  def initialize(tracked_item)
    @tracked_item = tracked_item
  end

  def sync
    data = SteamApiService.new(@tracked_item).fetch_price_overview
    return false if not data&.any?

    @tracked_item.steam_listing.update(data)
  end
end
