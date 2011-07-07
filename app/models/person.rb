# encoding: utf-8
#

# A person is a subclass of the Contact model. It defines attributes specific
# for person style contacts.
class Person < Contact

  # Enable model sequence support for people.
  include Mongoid::ModelSequenceSupport
  
  # Mount a CarrierWave uploader on the person and make the image attribute
  # assignable through mass assignment.
  mount_uploader :image, PersonPictureUploader
  attr_accessible :image
  
  # Define the fields for the person.
  field :first_name, type: String
  field :last_name, type: String

  # People can have many employments embedded withim them. Also, accept nested
  # attributes for employments, and make the employment attributes assignable
  # through mass assignment.
  embeds_many :employments
  accepts_nested_attributes_for :employments, allow_destroy: true
  attr_accessible :employments_attributes

  # People can have one or more deals associated with it.
  has_many :deals, dependent: :destroy

  # Validate that the person has a first name set, and make the first_name
  # attribute assignable through mass assignment.
  validates :first_name, presence: :true
  attr_accessible :first_name

  # Validate that the person has a last name set, and make the last_name
  # attribute assignable through mass assignment.
  validates :last_name, presence: :true
  attr_accessible :last_name
  
  # Before validation or saving a person, merge the first and last name columns
  # into the name column inherited from the Contact class.
  before_validation :merge_first_and_last_name_into_name

  # Returns the person having the specified employment id.
  scope :for_employment, lambda { |id| where('employments._id' => BSON::ObjectId.from_string(id)) }

  # Returns a persons employment for the specified organization.
  #
  # @param [ Organization ] organization The organization to return the
  #   employment for.
  #
  # @return [ Employment ] The persons employment for the organization, or nil
  #   if no employment was found.
  def employment_for(organization)
    employments.select { |e| e.organization_id == organization.id }.first
  end

  private

  # Merge the first_name and last_name columns into the name column inherited
  # from the Contact class.
  def merge_first_and_last_name_into_name
    self.name = [first_name, last_name].compact.join(' ').strip
  end
  
end
