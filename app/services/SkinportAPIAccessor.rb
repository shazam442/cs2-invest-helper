
module SkinportAPIAccessor
  extend self

  def items_endpoint_url = "https://api.skinport.com/v1/items?app_id=730&currency=EUR"

  def response_file_path = File.join(Dir.pwd, "app/services/skinport_items_response.json")

  def sync_items_to_file
    return false if not five_minutes_passed_since_last_request?

    request_record = ApiRequest.create!(market: :skinport, target_url: items_endpoint_url, request_time: Time.current, request_body: {})
    skinport_response = HTTParty.get(items_endpoint_url, stream_body: true, headers: { "Accept-Encoding": "br" })
    request_record.update!(success: skinport_response.success?, response_body: skinport_response.body, response_code: skinport_response.code)

    return false if not skinport_response.success?

    json_data = JSON.parse(skinport_response.body)

    # Save to a JSON file

    File.open(response_file_path, "w") do |file|
      file.write(JSON.pretty_generate(json_data))
    end

    true
  end

  def  five_minutes_passed_since_last_request?
    last_request_time = ApiRequest.to_skinport.last&.request_time

    return true if last_request_time.nil?
    last_request_time < 5.minutes.ago
  end

  ### SAMPLE_RESPONSE
  #   {
  #     "market_hash_name": "AK-47 | Aquamarine Revenge (Battle-Scarred)",
  #     "currency": "EUR",
  #     "suggested_price": 13.18,
  #     "item_page": "https://skinport.com/item/csgo/ak-47-aquamarine-revenge-battle-scarred",
  #     "market_page": "https://skinport.com/market/730?cat=Rifle&item=Aquamarine+Revenge",
  #     "min_price": 11.33,
  #     "max_price": 18.22,
  #     "mean_price": 12.58,
  #     "median_price": 13.37,
  #     "quantity": 25,
  #     "created_at": 1535988253,
  #     "updated_at": 1568073728
  #   },
  #   {
  #     "market_hash_name": "★ M9 Bayonet | Fade (Factory New)",
  #     "currency": "EUR",
  #     "suggested_price": 319.11,
  #     "item_page": "https://skinport.com/item/csgo/m9-bayonet-fade-factory-new",
  #     "market_page": "https://skinport.com/market/730?cat=Knife&item=Fade",
  #     "min_price": null,
  #     "max_price": null,
  #     "mean_price": null,
  #     "median_price": null,
  #     "quantity": 0,
  #     "created_at": 1535988302,
  #     "updated_at": 1568073725
  #   }
  # ]
end
