# encoding: utf-8
#

# Sources describe how an entity ended up in Unify; for instance, how a deal or
# the registration of an organization ended up in the registry.
#
# This can be used to track the return on investment on campaigns and similar.
class Source

  # Sources are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the source.
  field :name, type: String

  # Sources are associated with instances.
  belongs_to :instance

  # Sources are associated with contacts.
  has_many :contacts
  
  # Sources are associated with deals.
  has_many :deals

  # Sources are associated with projects.
  has_many :projects

  # Validate that the source is associated with an instance.
  validates :instance, presence: true

  # Validate that the source has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Sort sources by name.
  scope :sorted_by_name, order_by(:name.asc)

end
