# encoding: utf-8
#

# Defines an instant messenger account that can be used to contact an entity
# stored in Unify.
class InstantMessenger

  LOCATIONS = {
    '0' => :work,
    '10' => :personal,
    '999' => :other
  }

  PROTOCOLS = {
    '0' => :msn,
    '10' => :skype,
    '20' => :google,
    '30' => :aim,
    '40' => :icq,
    '50' => :jabber,
    '60' => :yahoo,
    '999' => :other
  }

  # Instant messengers are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the instant messenger.
  field :protocol, type: Integer
  field :location, type: Integer
  field :handle, type: String

  # Instant messengers can be embedded as a polymorphic association named
  # 'instant_messageable' using the :as option on the embeds_many directive.
  embedded_in :instant_messageable, polymorphic: true

  # Validate that the instant messenger has a protocol set, and that it contains
  # a valid value.
  validates :protocol, presence: true, inclusion: { in: PROTOCOLS.keys.map(&:to_i) }
  
  # Validate that the instant messenger has a location set, and that it contains
  # a valid value.
  validates :location, presence: true, inclusion: { in: LOCATIONS.keys.map(&:to_i) }

  # Validate that the instant messenger has a handle set.
  validates :handle, presence: true
  
  # Returns the name of the location associated with this instant messenger.
  #
  # @return [ Symbol ] A name identifying the location code for this instant
  #   messenger.
  def location_name
    LOCATIONS[location.to_s]
  end

  # Returns the name of the protocol associated with this instant messenger.
  #
  # @return [ Symbol ] A name identifying the protocol code for this instant
  #   messenger.
  def protocol_name
    PROTOCOLS[protocol.to_s]
  end
  
end
