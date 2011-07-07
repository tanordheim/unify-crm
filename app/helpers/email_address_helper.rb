# encoding: utf-8
#

# Helpers for the EmailAddress model class.
module EmailAddressHelper

  # Returns a collection of locations for an email address in a format ready to
  # use in a collection input element.
  def email_address_location_collection
    EmailAddress::LOCATIONS.keys.sort.map do |location|
      [I18n.t("email_addresses.location.#{EmailAddress::LOCATIONS[location]}"), location]
    end
  end

  # Returns the name of the e-mail address location.
  #
  # @param [ String ] key The key defining the location.
  #
  # @return [ String ] The name of the location.
  def email_address_location_name(key)
    I18n.t("email_addresses.location.#{key}")
  end

  # Returns the URL for an e-mail address.
  #
  # @param [ EmailAddress ] email_address The e-mail address to find the URL
  #   for.
  #
  # @return [ String ] The URL to the e-mail address.
  def email_address_path(email_address)
    url_for([email_address.emailable, email_address])
  end
  
end
