# encoding: utf-8
#

# Defines a physical address for an entity stored in Unify.
class Address

  LOCATIONS = {
    '0' => :work,
    '10' => :home,
    '999' => :other
  }

  # Addresses are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the address.
  field :location, type: Integer
  field :street_name, type: String
  field :zip_code, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :coordinates, type: Array, default: []
  field :time_zone, type: String

  # Addresses can be embedded as a polymorphic association named 'addressable'
  # using the :as option on the embeds_many directive.
  embedded_in :addressable, polymorphic: true

  # Validate that the address has a location set, and that it contains a valid
  # value.
  validates :location, presence: true, inclusion: { in: LOCATIONS.keys.map(&:to_i) }

  # Validate that at least one of the address fields are set.
  validate :validate_at_least_one_address_field

  # Perform geocoding on the address.
  include Geocoder::Model::Mongoid
  geocoded_by :geocoded_address_data, skip_index: true

  # Returns the name of the location associated with this address.
  #
  # @return [ Symbol ] A name identifying the location code for this address.
  def location_name
    LOCATIONS[location.to_s]
  end

  # Returns the i18n name of the location associated with this address.
  #
  # @return [ String ] The i18n name of the location.
  def i18n_location_name
    I18n.t("addresses.location.#{location_name}")
  end

  # Check if the address is in need of a geocode lookup. This is the case
  # whenever a field part of the actual address changes.
  #
  # @return [ TrueClass, FalseClass ] Returns true if the address needs a
  #   geocode lookup, false otherwise.
  def needs_geocode_lookup?
    changed_state = %w(street_name zip_code city state country).map { |field| send(:"#{field}_changed?") }
    changed_state.include?(true)
  end

  # Checks if the address has coordinates available.
  #
  # @return [ TrueClass, FalseClass ] True if there are coordinates available,
  #   false otherwise.
  def has_coordinates?
    !coordinates.blank? && coordinates.length == 2
  end

  # Returns the latitude from the coordinate set, if available.
  #
  # @return [ Float ] The latitude coordinate, or nil if no coordinates are
  #   available.
  def latitude
    coordinates.blank? || coordinates.length != 2 ? nil : to_coordinates[0]
  end
  
  # Returns the longitude from the coordinate set, if available.
  #
  # @return [ Float ] The longitude coordinate, or nil if no coordinates are
  #   available.
  def longitude
    coordinates.blank? || coordinates.length != 2 ? nil : to_coordinates[1]
  end

  # Set the time zone of the address based on the coordinates, if available.
  def set_time_zone_from_coordinates
    if has_coordinates?
      self.time_zone = Timezone::Zone.new(latlon: to_coordinates).zone
    else
      self.time_zone = nil
    end
  rescue Timezone::Error::NilZone
    self.time_zone = nil
  end
  
  private

  # Validate that at least one of the fields of the address has a value.
  def validate_at_least_one_address_field
    if street_name.blank? && zip_code.blank? && city.blank? && state.blank? && country.blank?
      errors.add_on_blank(:street_name)
    end
  end

  # Returns the address in a format used for geocoding.
  #
  # This will build a string containing all address fields, and separate them by
  # ', '.
  #
  # @return [ String ] The address in a format that can be used for geocoding.
  def geocoded_address_data
    [street_name, zip_code, city, state, country].compact.join(', ')
  end

end
