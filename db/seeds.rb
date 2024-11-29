# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a TrackedItem
items = [
  TrackedItem.find_or_initialize_by(name: "M9 Bayonet | Tiger Tooth", wear: :factory_new, item_type: :knife),
  TrackedItem.find_or_initialize_by(name: "AWP | Dragon Lore", wear: :minimal_wear),
  TrackedItem.find_or_initialize_by(name: "Nova | Wurst Hölle", wear: :factory_new),
  TrackedItem.find_or_initialize_by(name: "M249 | Humidor", wear: :factory_new),
  TrackedItem.find_or_initialize_by(name: "M4A1-S | Leaded Glass", wear: :field_tested),
  TrackedItem.find_or_initialize_by(name: "M4A4 | The Emperor", wear: :field_tested),
  TrackedItem.find_or_initialize_by(name: "AK-47 | The Empress", wear: :field_tested),
  TrackedItem.find_or_initialize_by(name: "AWP | The Prince", wear: :field_tested),
  TrackedItem.find_or_initialize_by(name: "AWP | The Princess", wear: :field_tested)
]

items.each do |tracked_item|
  tracked_item.steam_listing ||= SteamListing.new
  tracked_item.skinport_listing ||= SkinportListing.new
  tracked_item.save!
end
