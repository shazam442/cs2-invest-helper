# app/helpers/api_helper.rb
module ApiHelper
  def skinport_api_items_url
    "https://api.skinport.com/v1/items?app_id=730&currency=EUR"
  end

  def skinport_market_url(tracked_item)
    url = tracked_item.skinport_listing.market_page || rickroll_url
    params = {
      sort: :price,
      order: :asc,
      stattrak: tracked_item.stattrak ? 1 : 0,
      souvenir: tracked_item.souvenir ? 1 : 0,
      exterior: skinport_wear_code(tracked_item.wear)
    }
    params.each do |key, value|
      url += "&#{key}=#{value}"
    end
    url
  end

  def steam_api_price_overview_url(tracked_item)
    "https://steamcommunity.com/market/priceoverview/?currency=3&appid=730&market_hash_name=#{tracked_item.uri_encoded_market_hash_name}"
  end

  def steam_market_url(tracked_item)
    "https://steamcommunity.com/market/listings/730/#{tracked_item.uri_encoded_market_hash_name}"
  end

  def min_price_market_url(tracked_item)
    min_price_market_name = tracked_item.intermarket_min_price_market_name
    return steam_market_url(tracked_item) if min_price_market_name == "steam"
    return skinport_market_url(tracked_item) if min_price_market_name == "skinport"

    rickroll_url
  end

  def steam_market_image_url(tracked_item)
    "https://api.steamapis.com/image/item/730/#{tracked_item.uri_encoded_market_hash_name}"
  end

  def rickroll_url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

  def skinport_listings_file_path
    File.join(Dir.pwd, "app/services/markets/skinport_items_response.json")
  end

  def to_json_file(json_data, file_path)
    File.open(file_path, "w") do |file|
      file.write(JSON.pretty_generate(json_data))
    end
  end

  def is_stattrak?(name)
    name.downcase.include?("stattrak")
  end

  def is_souvenir?(name)
    name.downcase.include?("souvenir")
  end

  private

  def skinport_wear_code(wear)
    { factory_new: 2, minimal_wear: 4, field_tested: 3, well_worn: 5, battle_scarred: 1 }[wear.to_sym]
  end
end
