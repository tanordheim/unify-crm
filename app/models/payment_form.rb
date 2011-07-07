# encoding: utf-8
#

# Payment forms defines the source of incoming payments and how it should be
# handled financially.
class PaymentForm

  # Payment forms are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the payment form.
  field :name, type: String

  # Payment forms are associated with instances.
  belongs_to :instance

  # Payment forms are associated with accounts.
  belongs_to :account

  # Validate that the payment form is associated with an instance.
  validates :instance, presence: true

  # Validate that the payment form is associated with an account, and make the
  # account attributes assignable through mass assignment.
  validates :account, presence: true
  attr_accessible :account, :account_id

  # Validate that the payment form has a name, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Sort payments form by the name.
  scope :sorted_by_name, order_by(:name.asc)

end
