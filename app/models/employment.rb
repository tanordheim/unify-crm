# encoding: utf-8
#

# An employment describes a persons employment within an organization.
class Employment

  # Employments are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the employment.
  field :title, type: String
  field :since, type: Date

  # Employments are embedded within people.
  embedded_in :person

  # Employments are associated with organizations.
  belongs_to :organization

  # Validate that the employment is associated with an organization, and make
  # the organization attributes assignable through mass assignment.
  validates :organization, presence: true
  attr_accessible :organization, :organization_id

  # Make the title attribute assignable trough mass assignment.
  attr_accessible :title

  # Make the since attribute assignable through mass assignment.
  attr_accessible :since

end
