# encoding: utf-8
#

# Milestones define a common deadline for a set of tickets within a project.
class Milestone

  # Milestones are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Add comment support to milestones.
  include Mongoid::Comments

  # Add filtering support to milestones.
  include FilteredResult::Model

  # Define the fields for the project.
  field :name, type: String
  field :description, type: String
  field :starts_on, type: Date
  field :ends_on, type: Date
  field :closed, type: Boolean, default: false
  field :closed_at, type: DateTime

  # Milestones are associated with instances.
  belongs_to :instance

  # Milestones are associated with projects.
  belongs_to :project

  # Milestones can have many tickets. If a milestone is removed, all tickets
  # within it will get their milestone association nullified.
  has_many :tickets, dependent: :nullify
  
  # Milestones have a ticket progress embedded within it that holds aggregated
  # information about the tickets assigned to the milestone.
  embeds_one :ticket_progress, as: :ticket_trackable, class_name: 'TicketProgress'

  # Validate that the milestone is associated with an instance.
  validates :instance, presence: true
  
  # Validate that the milestone is associated with a project.
  validates :project, presence: true
  
  # Validate that the milestone has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name
  
  # Make the description attribute assignable through mass assignment.
  attr_accessible :description

  # Validate that the milestone has a start date, and make the starts_on
  # attribute assignable through mass assignment.
  validates :starts_on, presence: true
  attr_accessible :starts_on

  # Validate that the milestone has a end date, and make the ends_on attribute
  # assignable through mass assignment.
  validates :ends_on, presence: true
  attr_accessible :ends_on

  # When instantiating a milestone, build the associated ticket progress.
  after_initialize :build_progress

  # Sort the milestones by their end date.
  scope :sorted_by_end_date, order_by(:ends_on.asc)
  scope :sorted_by_end_date_descending, order_by(:ends_on.desc)

  # Sort the milestones by their start date.
  scope :sorted_by_start_date, order_by(:starts_on.asc)
  
  # Sort the milestones by their closed time.
  scope :sorted_by_closed_time, order_by(:closed_at.desc)
  
  # Returns all active milestones.
  scope :active, where(closed: false)

  # Returns all closed milestones.
  scope :closed, where(closed: true)

  # Returns all milestones currently in development.
  scope :in_development, lambda { active.where(:starts_on.lte => Date.today) }

  # Returns the most recently released milestones.
  scope :recently_released, closed.where(:closed_at.exists => true).sorted_by_closed_time

  # Returns the upcoming milestones for the project.
  scope :upcoming, lambda { active.where(:starts_on.gt => Date.today).sorted_by_start_date }

  # Returns all milestones ending before the specified date.
  scope :ends_before, lambda { |date| where(:ends_on.lt => date) }
  
  # Returns all milestones ending after the specified date.
  scope :ends_after, lambda { |date| where(:ends_on.gt => date) }
  
  # Checks if the current milestone is closed.
  #
  # @return [ TrueClass, FalseClass ] True if the milestone is closed, false
  #   otherwise.
  def closed?
    closed == true
  end

  # Flag a milestone as closed.
  def flag_as_closed!
    tickets.not_completed.each do |ticket|
      ticket.set(:milestone_id, nil)
    end
    self.closed = true
    self.closed_at = DateTime.now
    self.save!
  end

  # Restore a milestone.
  def restore!
    self.closed = false
    self.closed_at = nil
    self.save!
  end
  
  private

  # Build the embedded ticket progress model for the milestone.
  def build_progress
    self.build_ticket_progress if self.ticket_progress.blank?
  end

  # Return a list of object IDs related to this ticket which should have their
  # comments included in the comment list for the ticket.
  #
  # @return [ Array ] An array of object IDs.
  def commentable_object_ids
    tickets.map(&:id)
  end
  
end
