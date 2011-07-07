# encoding: utf-8
#

# This is the super class of all contactable entities within Unify. Its not
# directly used, but it does have two prominent subclasses; Organization and
# Person.
#
# The contact superclass allows us to treat them as two equal ("but not really")
# entities within the application, and have them stored within the same MongoDB
# collection.
class Contact

  # Contacts are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps

  # Add comment support to contacts.
  include Mongoid::Comments
  
  # Add filtering support to contacts.
  include FilteredResult::Model
  
  # Define the fields for the contact.
  field :name, type: String
  field :background, type: String
  field :deleted, type: Boolean, default: false

  # Contacts are associated with instances.
  belongs_to :instance

  # Contacts can be associated with sources.
  belongs_to :source

  # Contacts can have one or more phone numbers embedded. Make the phone numbers
  # assignable through mass assignment.
  embeds_many :phone_numbers, as: :phoneable do
    def work
      where(location: PhoneNumber::LOCATIONS.key(:work)).first
    end

    def mobile
      where(location: PhoneNumber::LOCATIONS.key(:mobile)).first
    end
    
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :phone_numbers, allow_destroy: true
  attr_accessible :phone_numbers_attributes

  # Contacts can have one or more email addresses embedded. Make the email
  # addresses assignable through mass assignment.
  embeds_many :email_addresses, as: :emailable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :email_addresses, allow_destroy: true
  attr_accessible :email_addresses_attributes
  
  # Contacts can have one or more websites embedded. Make the websites
  # assignable through mass assignment.
  embeds_many :websites, as: :websiteable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :websites, allow_destroy: true
  attr_accessible :websites_attributes
  
  # Contacts can have one or more instant messengers embedded. Make the instant
  # messengers assignable through mass assignment.
  embeds_many :instant_messengers, as: :instant_messageable do
    def primary
      order_by(:protocol.asc).order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :instant_messengers, allow_destroy: true
  attr_accessible :instant_messengers_attributes
  
  # Contacts can have one or more twitter accounts embedded. Make the twitter
  # accounts assignable through mass assignment.
  embeds_many :twitter_accounts, as: :tweetable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :twitter_accounts, allow_destroy: true
  attr_accessible :twitter_accounts_attributes
  
  # Contacts can have one or more addresses embedded. Make the addresses
  # assignable through mass assignment.
  embeds_many :addresses, as: :addressable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :addresses, allow_destroy: true
  attr_accessible :addresses_attributes

  # Validate that the contact is associated with an instance.
  validates :instance, presence: true

  # Validate that the contact has a name set.
  validates :name, presence: true

  # Make the source attributes assignable through mass assignment.
  attr_accessible :source, :source_id

  # Make the background attribute assignable through mass assignment.
  attr_accessible :background

  # Whenever a contact is saved, queue geocode lookups for the addresses that
  # have been modified for the contact.
  after_save :queue_geocode_lookups

  # Sort contacts by their name.
  scope :sorted_by_name, order_by(:name.asc)

  # Returns the contact having the specified employment id. This is really
  # defined on the inherited Person model, but since instance.contacts.people
  # aren't a Criteria for Person, but Contact, we add it here as well so we can
  # find people for an employment directly through the contacts association on
  # instances.
  scope :for_employment, lambda { |id| where('employments._id' => BSON::ObjectId.from_string(id)) }

  # Returns all contacts with the organization type.
  scope :organization_type, where(_type: 'Organization')

  # Returns all contacts with the person type.
  scope :person_type, where(_type: 'Person')

  # Returns all active contacts.
  scope :active, where(deleted: false)

  # Returns all deleted contacts.
  scope :deleted, where(deleted: true)

  # Return the time zone for the contact. This is done by finding the primary
  # address, if any, and then pulling the time zone from that address.
  #
  # @return [ String ] The time zone of the contact, or nil if the contact isn't
  #   associated with a time zone.
  def time_zone
    addresses.primary.blank? || addresses.primary.time_zone.blank? ? nil : addresses.primary.time_zone
  end

  # Checks if the contact has a time zone.
  #
  # @return [ TrueClass, FalseClass ] Returns true if the contact has a time
  #   zone, false otherwise.
  def time_zone?
    !time_zone.blank?
  end

  # Flags a contact as deleted.
  def flag_as_deleted!
    set(:deleted, true)
  end

  # Checks if the current contact is deleted.
  #
  # @return [ TrueClass, FalseClass ] True if the contact is deleted, false
  #   otherwise.
  def deleted?
    deleted == true
  end

  # Restores a contact.
  def restore!
    set(:deleted, false)
  end

  private
  
  # Queue a geocode lookup of any addresses that changed for the contact.
  def queue_geocode_lookups
    addresses.each do |address|
      if address.needs_geocode_lookup?
        Resque.enqueue(GeocodeAddressWorker, self.class.name, id, address.id)
      end
    end
  end
  
end
