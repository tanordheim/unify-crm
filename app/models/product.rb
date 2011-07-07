# encoding: utf-8
#

# Defines a product provided by the owning organization.
class Product

  # Products are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the product.
  field :key, type: String
  field :name, type: String
  field :price, type: Float

  # Products are associated with instances.
  belongs_to :instance

  # Products are associated with accounts.
  belongs_to :account

  # Validate that the product is associated with an instance.
  validates :instance, presence: true

  # Validate that the product is associated with an account, and make the
  # account attributes assignable through mass assignment.
  validates :account, presence: true
  attr_accessible :account, :account_id

  # Validate that the product has a key set, and that the key is unique for this
  # instance. Also, make the key attribute assignable through mass assignment.
  validates :key, presence: true, uniqueness: { scope: :instance_id }
  attr_accessible :key

  # Validate that the product has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Validate that the product has a price set, and make the price attribute
  # assignable through mass assignment.
  validates :price, presence: true
  attr_accessible :price

  # Sort products by their name.
  scope :sorted_by_name, order_by(:name.asc)
  
end
