
class SkinportApiService
  include ApiHelper

  def fetch_web_listings
    return {} if not ApiRequest.five_minutes_passed_since_last_skinport_request?

    request_record = ApiRequest.create!(market: :skinport, target_url: skinport_api_items_url, request_time: Time.current, request_body: {})
    skinport_response = HTTParty.get(skinport_api_items_url, stream_body: true, headers: { "Accept-Encoding": "br" })
    request_record.update!(success: skinport_response.success?, response_code: skinport_response.code)

    return {} if not skinport_response.success?

    JSON.parse(skinport_response.body)
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
