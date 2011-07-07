# encoding: utf-8
#

# Defines a twitter account that can be used to communicate with or get more
# information about an entity stored in Unify.
class TwitterAccount

  LOCATIONS = {
    '0' => :personal,
    '10' => :business,
    '999' => :other
  }

  # Twitter accounts are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the twitter account.
  field :location, type: Integer
  field :username, type: String

  # Twitter accounts can be embedded as a polymorphic association named
  # 'tweetable' using the :as option on the embeds_many directive.
  embedded_in :tweetable, polymorphic: true

  # Validate that the twitter account has a location set, and that it contains a
  # valid value.
  validates :location, presence: true, inclusion: { in: LOCATIONS.keys.map(&:to_i) }

  # Validate that the twitter account has a username set.
  validates :username, presence: true

  # Returns the name of the location associated with this twitter account.
  #
  # @return [ Symbol ] A name identifying the location code for this twitter
  #   account.
  def location_name
    LOCATIONS[location.to_s]
  end
  
end
