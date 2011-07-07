# encoding: utf-8
#

# Helpers for the InstantMessenger model class.
module InstantMessengerHelper

  # Returns a collection of locations for a instant messenger in a format ready
  # to use in a collection input element.
  def instant_messenger_location_collection
    InstantMessenger::LOCATIONS.keys.sort.map do |location|
      [I18n.t("instant_messengers.location.#{InstantMessenger::LOCATIONS[location]}"), location]
    end
  end

  # Returns a collection of protocols for a instant messenger in a format ready
  # to use in a collection input element.
  def instant_messenger_protocol_collection
    InstantMessenger::PROTOCOLS.keys.sort.map do |protocol|
      [I18n.t("instant_messengers.protocol.#{InstantMessenger::PROTOCOLS[protocol]}"), protocol]
    end
  end
  
  # Returns the name of the instant messenger location.
  #
  # @param [ String ] key The key defining the location.
  #
  # @return [ String ] The name of the location.
  def instant_messenger_location_name(key)
    I18n.t("instant_messengers.location.#{key}")
  end
  
  # Returns the name of the instant messenger protocol.
  #
  # @param [ String ] key The key defining the protocol.
  #
  # @return [ String ] The name of the protocol.
  def instant_messenger_protocol_name(key)
    I18n.t("instant_messengers.protocol.#{key}")
  end
  
  # Returns the URL for an instant messenger.
  #
  # @param [ InstantMessenger ] instant_messenger The instant messenger to find
  #   the URL for.
  #
  # @return [ String ] The URL to the instant messenger.
  def instant_messenger_path(instant_messenger)
    url_for([instant_messenger.instant_messageable, instant_messenger])
  end
  
end
