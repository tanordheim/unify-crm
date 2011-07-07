# encoding: utf-8
#

# Projects define sets of work/actual projects within a Unify instance.
class Project

  # Projects are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Add comment support to projects.
  include Mongoid::Comments
  
  # Enable model sequence support for projects.
  include Mongoid::ModelSequenceSupport
  
  # Add filtering support to projects.
  include FilteredResult::Model

  # Define the fields for the project.
  field :name, type: String
  field :key, type: String
  field :description, type: String
  field :starts_on, type: Date
  field :closed, type: Boolean, default: false

  # Embed a model sequence within the project to allow project-scoped sequences
  # for tickets associated with the project.
  embeds_one :ticket_sequence, as: :sequenceable, class_name: 'ModelSequence'
  
  # Projects are associated with instances.
  belongs_to :instance

  # Projects are associated with organizations.
  belongs_to :organization

  # Projects can be associated with a category that describes what kind of
  # delivery the project is about.  Also, make the category attributes
  # assignable through mass assignment.
  belongs_to :category, class_name: 'ProjectCategory'
  attr_accessible :category, :category_id
  
  # Projects can be associated with sources.
  belongs_to :source

  # Projects can have many components.
  has_many :components, dependent: :destroy

  # Projects can have many milestones.
  has_many :milestones, dependent: :destroy
  
  # Projects can have many tickets.
  has_many :tickets, dependent: :destroy

  # Projects have a ticket progress embedded within it that holds aggregated
  # information about the tickets assigned to the project.
  embeds_one :ticket_progress, as: :ticket_trackable, class_name: 'TicketProgress'

  # Projects can have many pages.
  has_many :pages, dependent: :destroy

  # Projects can have many members embedded within it, and make the members
  # assignable through mass assignment.
  embeds_many :members, class_name: 'ProjectMember'
  accepts_nested_attributes_for :members, allow_destroy: true
  attr_accessible :members_attributes

  # Validate that the project is associated with an instance.
  validates :instance, presence: true

  # Validate that the project is associated with an organization, and make the
  # organization attributes assignable through mass assignment.
  validates :organization, presence: true
  attr_accessible :organization, :organization_id

  # Make the source attributes assignable through mass assignment.
  attr_accessible :source, :source_id

  # Validate that the project has a key set, that the key is unique for the
  # instance, and that it has a valid format. Also, make the key attribute
  # assignable through mass assignment.
  validates :key, presence: true, uniqueness: { scope: :instance_id }, format: { :with => /^[\w\d_]+$/ }
  attr_accessible :key

  # Validate that the project has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name
  
  # Make the description attribute assignable through mass assignment.
  attr_accessible :description

  # Make the starts_on attribute assignable through mass assignment.
  attr_accessible :starts_on

  # When instantiating a project, build the associated model sequences.
  after_initialize :build_model_sequences
  
  # When instantiating a project, build the associated ticket progress.
  after_initialize :build_progress
  
  # Sort the projects by their name.
  scope :sorted_by_name, order_by(:name.asc)

  # Returns all projects for the specified instance.
  scope :for_instance, lambda { |instance| where(instance_id: instance.id.to_s) }

  # Returns all active projects.
  scope :active, where(closed: false)

  # Returns all closed projects.
  scope :closed, where(closed: true)

  # Checks if the current project is closed.
  #
  # @return [ TrueClass, FalseClass ] True if the project is closed, false
  #   otherwise.
  def closed?
    closed == true
  end

  # Flag a project as closed.
  def flag_as_closed!
    set(:closed, true)
  end

  # Restore a project.
  def restore!
    set(:closed, false)
  end
  
  private

  # Build the embedded model sequences for the project.
  def build_model_sequences
    if self.ticket_sequence.blank?
      self.build_ticket_sequence
      self.ticket_sequence.model_class = Ticket.name
      self.ticket_sequence.current_value = 0
    end
  end

  # Build the embedded ticket progress model for the project.
  def build_progress
    self.build_ticket_progress if self.ticket_progress.blank?
  end

  # Return a list of object IDs related to this project which should have their
  # comments included in the comment list for the project.
  #
  # @return [ Array ] An array of object IDs.
  def commentable_object_ids
    milestones.map(&:id) + tickets.map(&:id)
  end
  
end
