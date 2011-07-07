# encoding: utf-8
#

# Helpers for the PhoneNumber model class.
module PhoneNumberHelper

  # Returns a collection of locations for a phone number in a format ready to
  # use in a collection input element.
  def phone_number_location_collection
    PhoneNumber::LOCATIONS.keys.sort.map do |location|
      [I18n.t("phone_numbers.location.#{PhoneNumber::LOCATIONS[location]}"), location]
    end
  end

  # Returns the name of the phone number location.
  #
  # @param [ String ] key The key defining the location.
  #
  # @return [ String ] The name of the location.
  def phone_number_location_name(key)
    I18n.t("phone_numbers.location.#{key}")
  end

  # Returns the URL for a phone number.
  #
  # @param [ PhoneNumer ] phone_number The phone number to find the URL for.
  #
  # @return [ String ] The URL to the phone number.
  def phone_number_path(phone_number)
    url_for([phone_number.phoneable, phone_number])
  end
  
end
