class BaseSkinportService
  def skinport_listings_file_path = File.join(Dir.pwd, "app/services/skinport_items_response.json")

  def items_endpoint_url = "https://api.skinport.com/v1/items?app_id=730&currency=EUR"

  def to_json_file(json_data)
    File.open(skinport_listings_file_path, "w") do |file|
      file.write(JSON.pretty_generate(json_data))
    end
  end

  def is_stattrak?(name)
    name.downcase.include?("stattrak")
  end

  def is_souvenir?(name)
    # WARNING this will filter out souvenir packages
    name.downcase.include?("souvenir")
  end
end
