# encoding: utf-8
#

# Helpers for the Address model class.
module AddressHelper

  # Returns a collection of locations for an address in a format ready to use in
  # a collection input element.
  def address_location_collection
    Address::LOCATIONS.keys.sort.map do |location|
      [I18n.t("addresses.location.#{Address::LOCATIONS[location]}"), location]
    end
  end

  # Returns the name of the address location.
  #
  # @param [ String ] key The key defining the location.
  #
  # @return [ String ] The name of the location.
  def address_location_name(key)
    I18n.t("addresses.location.#{key}")
  end

  # Returns the URL for an address.
  #
  # @param [ Address ] address The address to find the URL for.
  #
  # @return [ String ] The URL to the address.
  def address_path(address)
    url_for([address.addressable, address])
  end

  # Link to the map for an address.
  #
  # @param [ Address ] address The address to link to.
  #
  # @return [ String ] The DOM for the map link.
  def link_to_map(address, *args)

    options = args.extract_options!
    options[:width] ||= 100
    options[:height] ||= 100

    image = image_tag("http://maps.googleapis.com/maps/api/staticmap?center=#{address.latitude},#{address.longitude}&zoom=11&size=#{options[:width]}x#{options[:height]}&sensor=false")
    link_to image, "http://maps.google.com/maps?q=#{address.latitude},#{address.longitude}&hl=en", class: 'thumbnail', target: :_blank

  end
  
end
