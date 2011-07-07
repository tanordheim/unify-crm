# encoding: utf-8
#

# Helpers for the Website model class.
module WebsiteHelper

  # Returns a collection of locations for a website in a format ready to use in
  # a collection input element.
  def website_location_collection
    Website::LOCATIONS.keys.sort.map do |location|
      [I18n.t("websites.location.#{Website::LOCATIONS[location]}"), location]
    end
  end

  # Returns the name of the website location.
  #
  # @param [ String ] key The key defining the location.
  #
  # @return [ String ] The name of the location.
  def website_location_name(key)
    I18n.t("websites.location.#{key}")
  end
  
  # Returns the URL for a website.
  #
  # @param [ Website ] website The website to find the URL for.
  #
  # @return [ String ] The URL to the website.
  def website_path(website)
    url_for([website.websiteable, website])
  end
  
end
