# encoding: utf-8
#

# Defines a phone number that can be used to contact an entity stored in Unify.
class PhoneNumber

  LOCATIONS = {
    '0' => :work,
    '10' => :mobile,
    '20' => :fax,
    '30' => :pager,
    '40' => :home,
    '50' => :skype,
    '999' => :other
  }

  # Phone numbers are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the phone number.
  field :location, type: Integer
  field :number, type: String

  # Phone numbers can be embedded as a polymorphic association named
  # 'phoneable' using the :as option on the embeds_many directive.
  embedded_in :phoneable, polymorphic: true

  # Validate that the phone number has a location set, and that it contains a
  # valid value.
  validates :location, presence: true, inclusion: { in: LOCATIONS.keys.map(&:to_i) }

  # Validate that the phone number has a number set.
  validates :number, presence: true
  
  # Returns the name of the location associated with this phone number.
  #
  # @return [ Symbol ] A name identifying the location code for this phone
  #   number.
  def location_name
    LOCATIONS[location.to_s]
  end
  
end
