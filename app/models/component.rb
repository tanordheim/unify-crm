# encoding: utf-8
#

# Components defines a specific component of a project, allowing tickets to be
# segmented by component in large projects.
class Component

  # Components are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps

  # Define the fields for the component.
  field :name, type: String

  # Components are associated with projects.
  belongs_to :project

  # Components can have tickets associated with them, and when a component is
  # destroyd we nullify the component association of all associated tickets.
  has_many :tickets, dependent: :nullify

  # Validate that the component has a project set.
  validates :project, presence: true

  # Validate that the component has a name set, and that the name is unique for
  # the project. Also, make the name attribute assignable through mass
  # assignment.
  validates :name, presence: true, uniqueness: { scope: :project_id }
  attr_accessible :name

  # Sort components by their name.
  scope :sorted_by_name, order_by(:name.asc)
  
end
