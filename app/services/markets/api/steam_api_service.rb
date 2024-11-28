class SteamApiService
  def initialize(tracked_item)
    @tracked_item = tracked_item
  end

  def fetch_price_overview
    request_record = ApiRequest.create!(market: :steam, target_url: @tracked_item.steam_api_url, request_time: Time.current, request_body: {}, tracked_item_id: @tracked_item.id)
    response = HTTParty.get(@tracked_item.steam_api_url)
    request_record.update!(success: response.success?, response_code: response.code, response_body: JSON.parse(response.body))

    return {} if not response.success?

    json = JSON.parse(response.body)
    # strip of currency symbol and convert to float
    min_price = json["lowest_price"]&.gsub(/[^0-9],/, "")&.gsub(",", ".")&.to_f
    median_price = json["median_price"]&.gsub(/[^0-9],/, "")&.gsub(",", ".")&.to_f
    volume_sold = json["volume"]&.gsub(/\D/, "")&.to_i

    {
      min_price: min_price,
      median_price: median_price,
      volume_sold: volume_sold
    }
  end
end
