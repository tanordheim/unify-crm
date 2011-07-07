# encoding: utf-8
#

# Categories are the super class for all types of categories used to categorize
# primary content within Unify.
class Category

  # Categories are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the category.
  field :name, type: String
  field :color, type: String

  # Categories are associated with instances.
  belongs_to :instance

  # Validate that the category is associated with an instance.
  validates :instance, presence: true

  # Validate that the category has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Validate that the category has a color set, and make the color attribute
  # assignable through mass assignment.
  validates :color, presence: true
  attr_accessible :color

  # Sort categories by their name.
  scope :sorted_by_name, order_by(:name.asc)

end
