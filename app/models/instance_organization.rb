# encoding: utf-8
#

# Defines information about the organizations that owns each particular Unify
# instance.
#
# This document is embedded within the instance document.
class InstanceOrganization

  # Instance organizations are Mongoid documents embedded within instances.
  include Mongoid::Document
  embedded_in :instance, inverse_of: :organization

  # Define the fields for the organization.
  field :name, type: String
  field :street_name, type: String
  field :zip_code, type: String
  field :city, type: String
  field :country, type: String
  field :vat_number, type: String
  field :bank_account_number, type: String

  # Validate that the organization has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Make the street_name attribute assignable through mass assignment.
  attr_accessible :street_name

  # Make the zip_code attribute assignable through mass assignment.
  attr_accessible :zip_code

  # Make the city attribute assignable through mass assignment.
  attr_accessible :city

  # Make the country attribute assignable through mass assignment.
  attr_accessible :country

  # Make the vat_number attribute assignable through mass assignment.
  attr_accessible :vat_number

  # Make the bank_account_number attribute assignable through mass assignment.
  attr_accessible :bank_account_number

end
