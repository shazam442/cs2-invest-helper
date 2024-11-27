module TrackedItemsHelper
  def is_stattrak?(name)
    name.downcase.include?("stattrak")
  end

  def is_souvenir?(name)
    # WARNING this will filter out souvenir packages
    name.downcase.include?("souvenir")
  end
end
