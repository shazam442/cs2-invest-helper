class SteamAPIService
  def initialize(tracked_item)
    @tracked_item = tracked_item
  end

  def self.price_overview_endpoint(tracked_item)
    "https://steamcommunity.com/market/priceoverview/?currency=3&appid=730&market_hash_name=#{tracked_item.uri_encoded_market_hash_name}"
  end

  def fetch_steam_market_price_overview
    response = HTTParty.get(self.class.price_overview_endpoint(@tracked_item))

    unless response.success?
      Rails.logger.error "price_overview_endpoint request failed with code #{response.code}: #{response.message}"
      return {
        last_request_success: false,
        response_code: response.code,
        response_message: response.message,
        info: "A 500 Internal Server Error can be the result of a bad market_hash_name"
      }
    end

    json = JSON.parse(response.body)
    # strip of currency symbol and convert to float
    lowest_price = json["lowest_price"]&.gsub(/[^0-9],/, "")&.gsub(",", ".")&.to_f
    median_price = json["median_price"]&.gsub(/[^0-9],/, "")&.gsub(",", ".")&.to_f
    volume_sold = json["volume"]&.gsub(/\D/, "")&.to_i
    success = json["success"]

    {
      lowest_price: lowest_price,
      median_price: median_price,
      volume_sold: volume_sold,
      last_request_response: json,
      last_request_success: success,
      last_request_response_code: response.code,
      last_request_time: Time.current
    }
  rescue JSON::ParserError => e
    Rails.logger.error "JSON parsing failed: #{e.message}"
    update(last_request_success: false)
    false
  rescue StandardError => e
    Rails.logger.error "Unexpected error in SteamMarketPriceOverview.update: #{e.message}"
    update(last_request_success: false)
    false
  end
end
