# encoding: utf-8
#

# Tax codes defines a tax code/percentage for used in accounting.
class TaxCode

  # Tax codes are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the tax code.
  field :code, type: Integer
  field :percentage, type: Integer
  field :name, type: String

  # Tax codes are associated with instances.
  belongs_to :instance

  # Tax codes can have many accounts using the tax code.
  has_many :accounts

  # Tax codes are associated with a target account that will be balanced based
  # on the tax code account associations.
  belongs_to :target_account, class_name: 'Account'

  # Validate that the tax code is associated with an instance.
  validates :instance, presence: true

  # Validate that the tax code is associated with a target account, and make the
  # target account attributes assignable through mass assignment.
  validates :target_account, presence: true
  attr_accessible :target_account, :target_account_id

  # Validate that the tax code has a code set, and that the code is unique for
  # this instance. Also, make the code attribute assignable through mass
  # assignment.
  validates :code, presence: true, uniqueness: { scope: :instance_id }
  attr_accessible :code

  # Validate that the tax code has a percentage set, and that it contains a
  # valid value. Also, make the percentage attribute assignable through mass
  # assignment.
  validates :percentage, presence: true, inclusion: { in: (0..100).to_a }
  attr_accessible :percentage

  # Validate that the tax code has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Sort tax codes by the code.
  scope :sorted_by_code, order_by(:code.asc)
  
end
