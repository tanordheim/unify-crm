# encoding: utf-8
#

# Defines a user that have access to Unify on behalf of an instance.
class User

  # Users are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Mount a CarrierWave uploader on the user and make the image attribute
  # assignable through mass assignment.
  mount_uploader :image, UserImageUploader
  attr_accessible :image
  
  # Define the fields for the user.
  field :username, type: String
  field :password_digest, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :title, type: String
  field :single_access_token, type: String

  # Use the secure password feature from ActiveModel to handle authentications
  # through the user model.
  include ActiveModel::SecurePassword
  has_secure_password

  # Users are associated with instances.
  belongs_to :instance

  # Users can have one or more phone numbers embedded. Make the phone numbers
  # assignable through mass assignment.
  embeds_many :phone_numbers, as: :phoneable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :phone_numbers
  attr_accessible :phone_numbers_attributes

  # Users can have one or more email addresses embedded. Make the email
  # addresses assignable through mass assignment.
  embeds_many :email_addresses, as: :emailable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :email_addresses
  attr_accessible :email_addresses_attributes
  
  # Users can have one or more websites embedded. Make the websites assignable
  # through mass assignment.
  embeds_many :websites, as: :websiteable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :websites
  attr_accessible :websites_attributes
  
  # Users can have one or more instant messengers embedded. Make the instant
  # messengers assignable through mass assignment.
  embeds_many :instant_messengers, as: :instant_messageable do
    def primary
      order_by(:protocol.asc).order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :instant_messengers
  attr_accessible :instant_messengers_attributes
  
  # Users can have one or more twitter accounts embedded. Make the twitter
  # accounts assignable through mass assignment.
  embeds_many :twitter_accounts, as: :tweetable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :twitter_accounts
  attr_accessible :twitter_accounts_attributes
  
  # Users can have one or more addresses embedded. Make the addresses assignable
  # through mass assignment.
  embeds_many :addresses, as: :addressable do
    def primary
      order_by(:location.asc).first
    end
  end
  accepts_nested_attributes_for :addresses
  attr_accessible :addresses_attributes

  # Users can have one or more widget configurations embedded.
  embeds_many :widget_configurations do
    def for_column(index)
      @target.select { |c| c.column == index }
    end
  end

  # Validate that the user has a username set, and that the username is unique
  # for the associatd instance. Also, make the username column accessible
  # through mass assignment.
  validates :username, presence: true, uniqueness: { scope: :instance_id, case_sensitive: false }
  attr_accessible :username

  # Validate that the user has a first name set, and make the first_name column
  # accessible through mass assignment.
  validates :first_name, presence: true
  attr_accessible :first_name

  # Validate that the user has a last name set, and make the last_name column
  # accessible through mass assignment.
  validates :last_name, presence: true
  attr_accessible :last_name
  
  # Validate that the user has a title set, and make the title column accessible
  # through mass assignment.
  validates :title, presence: true
  attr_accessible :title

  # Make the password attributes assignable through mass assignment.
  attr_accessible :password, :password_confirmation

  # Before saving a user, make sure it has a single access token.
  before_save :generate_single_access_token

  # Returns the user having the specified single access token, if any.
  scope :for_token, lambda { |token| where(single_access_token: token) }

  # Returns a list of users for the specified instance.
  scope :for_instance, lambda { |instance| where(instance_id: instance.id.to_s) }

  # Returns a list of users having the specified e-mail address.
  scope :with_email_address, lambda { |address| where('email_addresses.address' => address) }

  # Sorts users by their name.
  scope :sorted_by_name, order_by([[:first_name, :asc], [:last_name, :asc]])

  # Returns the full name of the user based on the first and last name.
  #
  # @return [ String ] The full name of the user.
  def name
    [first_name, last_name].join(' ')
  end

  private

  # Generate a single acces token for the user unless it already exists.
  #
  # @return [ String ] The single access token for the user.
  def generate_single_access_token
    self.single_access_token ||= UUIDTools::UUID.random_create
  end
  
end
