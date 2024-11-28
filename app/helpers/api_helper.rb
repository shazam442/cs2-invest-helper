# app/helpers/api_helper.rb
module ApiHelper
  def skinport_api_items_url
    "https://api.skinport.com/v1/items?app_id=730&currency=EUR"
  end

  def steam_api_price_overview_url(tracked_item)
    "https://steamcommunity.com/market/priceoverview/?currency=3&appid=730&market_hash_name=#{tracked_item.uri_encoded_market_hash_name}"
  end

  def steam_market_url(tracked_item)
    "https://steamcommunity.com/market/listings/730/#{tracked_item.uri_encoded_market_hash_name}"
  end

  def steam_market_image_url(tracked_item)
    "https://api.steamapis.com/image/item/730/#{tracked_item.uri_encoded_market_hash_name}"
  end

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
end
