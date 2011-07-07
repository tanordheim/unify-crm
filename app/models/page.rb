# encoding: utf-8
#

# Pages define a wiki page within a project used for writing notes and
# documentation.
class Page

  # Pages are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Define the fields for the project.
  field :name, type: String
  field :body, type: String

  # Pages are associated with instances.
  belongs_to :instance

  # Pages are associated with projects.
  belongs_to :project
  
  # Validate that the page is associated with an instance.
  validates :instance, presence: true
  
  # Validate that the page is associated with a project.
  validates :project, presence: true
  
  # Validate that the page has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name
  
  # Validate that the page has a body set, and make the body attribute
  # assignable through mass assignment.
  validates :body, presence: true
  attr_accessible :body

  # Sort pages by their name.
  scope :sorted_by_name, order_by(:name.asc)
  
end
