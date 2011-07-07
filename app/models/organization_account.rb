# encoding: utf-8
#

# Organization accounts defines accounts for each organiation used to track
# income and expenses from organization within a financial budget.
class OrganizationAccount < Account

  # Define the fields for the organization account.
  field :type, type: Integer, default: 0

  # Organization accounts are associated with organizations.
  belongs_to :organization

  # Validate that the organization account has an organization association, and
  # prevent the organization from being assigned through mass assignment.
  validates :organization, presence: true
  attr_protected :organization, :organization_id

  # Prevent the type attribute from being assigned through mass assignment.
  attr_protected :type

  # Prevent the number attribute from being assigned through mass assignment.
  attr_protected :number
  
end
