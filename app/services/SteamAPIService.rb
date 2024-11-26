module SteamAPIService
  extend self

  def price_overview_endpoint(tracked_item) = tracked_item.steam_price_overview_url

  def fetch_price_overview(tracked_item)
    response = HTTParty.get(price_overview_endpoint(tracked_item))

    unless response.success?
      Rails.logger.error "price_overview_endpoint request failed with code #{response.code}: #{response.message}"
      return {
        last_request_success: false,
        last_request_response: JSON.parse(response.body),
        last_request_response_code: response.code
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
  end
end
