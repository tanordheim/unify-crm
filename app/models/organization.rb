# encoding: utf-8
#

# An organization is a subclass of the Contact model. It defines attributes
# specific for organization style contacts.
class Organization < Contact

  # Enable model sequence support for organizations.
  include Mongoid::ModelSequenceSupport

  # Mount a CarrierWave uploader on the organization and make the image
  # attribute assignable through mass assignment.
  mount_uploader :image, OrganizationLogoUploader
  attr_accessible :image

  # Organizations can have one or more deals associated with it.
  has_many :deals, dependent: :destroy

  # Organizations are associated with an organization account used to track income
  # and expenses for the organization.
  has_one :organization_account, dependent: :destroy

  # Make the name attribute assignable through mass assignment.
  attr_accessible :name

  # Before saving this organization, make sure it has an account and that the
  # account name is in sync with the organization name.
  before_save :create_or_update_account

  # Returns all the people employed within this organization.
  #
  # @return [ Mongoid::Criteria ] A Mongoid criteria containing the people
  #   employed within this organization.
  def employees
    instance.contacts.people.where('employments.organization_id' => id).sorted_by_name
  end

  private

  # Return a list of object IDs related to this organization which should have
  # their comments included in the comment list for the organization.
  #
  # @return [ Array ] An array of object IDs.
  def commentable_object_ids
    employees.map(&:id) + deals.map(&:id)
  end

  # Make sure the organization has an organization account, and that its name
  # matches the name of the organization.
  def create_or_update_account

    # Make sure an identifier has been assigned.
    assign_identifier

    # Build the organization account if we don't have it.
    if self.organization_account.blank?
      self.build_organization_account
      # self.organization_account.type = Account::TYPES.key(:balance)
      self.organization_account.number = self.identifier
      self.organization_account.instance = self.instance
    end

    # Update the organization account name and save it.
    self.organization_account.name = self.name
    self.organization_account.save!

  end

end
