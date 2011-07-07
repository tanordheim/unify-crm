# encoding: utf-8
#

# Defines a phone number that can be used to contact an entity stored in Unify.
class EmailAddress

  LOCATIONS = {
    '0' => :work,
    '10' => :home,
    '999' => :other
  }

  # Email addresses are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the email address.
  field :location, type: Integer
  field :address, type: String

  # Email addresses can be embedded as a polymorphic association named
  # 'emailable' using the :as option on the embeds_many directive.
  embedded_in :emailable, polymorphic: true

  # Validate that the email address has a location set, and that it contains a
  # valid value.
  validates :location, presence: true, inclusion: { in: LOCATIONS.keys.map(&:to_i) }

  # Validate that the email address has an address set.
  validates :address, presence: true

  # Returns the name of the location associated with this e-mail address.
  #
  # @return [ Symbol ] A name identifying the location code for this e-mail
  #   address.
  def location_name
    LOCATIONS[location.to_s]
  end
  
end
