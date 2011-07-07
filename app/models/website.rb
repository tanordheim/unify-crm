# encoding: utf-8
#

# Defines a website that can be used to get more information about an entity
# stored in Unify.
class Website

  LOCATIONS = {
    '0' => :work,
    '10' => :personal,
    '999' => :other
  }

  # Websites are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the website.
  field :location, type: Integer
  field :url, type: String

  # Websites can be embedded as a polymorphic association named 'websiteable'
  # using the :as option on the embeds_many directive.
  embedded_in :websiteable, polymorphic: true

  # Validate that the website has a location set, and that it contains a valid
  # value.
  validates :location, presence: true, inclusion: { in: LOCATIONS.keys.map(&:to_i) }

  # Validate that the website has an url set, and that its a valid URL.
  validates :url, presence: true, format: { with: URI::regexp(%w(http https)) }
  
  # Returns the name of the location associated with this website.
  #
  # @return [ Symbol ] A name identifying the location code for this website.
  def location_name
    LOCATIONS[location.to_s]
  end
  
end
