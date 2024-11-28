module ViewHelper
  def steam_icon_url
    "https://upload.wikimedia.org/wikipedia/commons/8/83/Steam_icon_logo.svg"
  end

  def skinport_icon_url
    "https://skinport.com/static/android-chrome-192x192.png"
  end

  def rick_astley_url
    "https://www.silicon.co.uk/wp-content/uploads/2021/07/rickroll-00003.png"
  end

  def get_new_form_wear_options
    wear_display_names = {
      factory_new: "Factory New",
      minimal_wear: "Minimal Wear",
      field_tested: "Field-Tested",
      well_worn: "Well-Worn",
      battle_scarred: "Battle-Scarred"
    }
    wear_display_names.map do |wear, display_name|
      [ display_name, wear ]
    end
  end

  def get_market_icon_for(tracked_item)
    market = tracked_item.intermarket_min_price_market_name
    return steam_icon_url if market == "steam"
    return skinport_icon_url if market == "skinport"

    rick_astley_url
  end
end
