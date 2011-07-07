# encoding: utf-8
#

# Tickets defines a project-related work-assignment for a project stored in
# Unify.
class Ticket

  STATUSES = {
    '0' => :open,
    '1' => :in_progress,
    '2' => :closed
  }

  PRIORITIES = {
    '0' => :trivial,
    '10' => :minor,
    '20' => :major,
    '30' => :critical,
    '40' => :blocker
  }
  
  # Tickets are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Add comment support to tickets.
  include Mongoid::Comments

  # Add filtering support to tickets.
  include FilteredResult::Model

  # Define the fields for the ticket.
  field :sequence, type: Integer
  field :name, type: String
  field :description, type: String
  field :priority, type: Integer
  field :status, type: Integer, default: 0
  field :due_on, type: Date
  field :started_at, type: DateTime
  field :estimated_minutes, type: Integer
  field :worked_minutes, type: Integer, default: 0
  field :_scheduled, type: Boolean

  # Tickets are associated with instances.
  belongs_to :instance

  # Tickets are associated with projects.
  belongs_to :project

  # Tickets may be associated with milestones, and make the milestone attributes
  # assignable through mass assignment.
  belongs_to :milestone
  attr_accessible :milestone, :milestone_id

  # Tickets are associated with a category that describes what kind of work the
  # ticket is about.  Also, make the category attributes assignable through mass
  # assignment.
  belongs_to :category, class_name: 'TicketCategory'
  attr_accessible :category, :category_id

  # Tickets are associated with the user that should perform the task. Also,
  # make the user attributes assignable through mass assignment.
  belongs_to :user
  attr_accessible :user, :user_id

  # Tickets are associated with the user that reported the ticket.
  belongs_to :reporter, class_name: 'User'

  # Tickets can be associated with components. Also, make the component and
  # component_id attributes assignable through mass assignment.
  belongs_to :component
  attr_accessible :component, :component_id

  # Validate that the ticket is associated with an instance.
  validates :instance, presence: true
  
  # Validate that the ticket is associated with a project.
  validates :project, presence: true
  
  # Validate that the ticket is associated with a category.
  validates :category, presence: true

  # Validate that the ticket has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name
  
  # Validate that the ticket priority contains a valid value if its set. Also,
  # make the priority attribute assignable through mass assignment.
  validates :priority, inclusion: { in: PRIORITIES.keys.map(&:to_i), allow_blank: true }
  attr_accessible :priority

  # Validate that the ticket has a status set, and that it contains a valid
  # value.
  validates :status, presence: true, inclusion: { in: STATUSES.keys.map(&:to_i) }

  # Validate that the ticket is associated with a reporter.
  validates :reporter, presence: true
  
  # Make the estimated_minutes attribute assignable through mass assignment.
  attr_accessible :estimated_minutes

  # Make the description attribute assignable through mass assignment.
  attr_accessible :description

  # Make the due on attribute assignable through mass assignment.
  attr_accessible :due_on
  
  # Write a sequence to the sequence field before creating a ticket.
  before_create :assign_sequence

  # Update the scheduled status of the ticket before saving it.
  before_save :update_scheduled_status

  # Update ticket progress counters after saving a ticket.
  after_save :update_progress_counters

  # Sort tickets by the due date.
  scope :sorted_by_due_date, order_by(:due_on.asc)

  # Sorts tickets by the priority, descending.
  scope :sorted_by_priority, order_by(:priority.desc)

  # Returns tickets assigned to the specified user.
  scope :assigned_to, lambda { |user| where(:user_id => user.id.to_s) }

  # Returns tickets reported to the specified user.
  scope :reported_by, lambda { |user| where(:reporter_id => user.id.to_s) }
  
  # Returns ticket that have not been completed.
  scope :not_completed, where(:status.ne => STATUSES.key(:closed))

  # Returns tickets that have been completed.
  scope :completed, where(status: STATUSES.key(:closed))

  # Returns tickets that are open.
  scope :open_status, where(status: STATUSES.key(:open))

  # Returns tickets that are in progress.
  scope :in_progress_status, where(status: STATUSES.key(:in_progress))

  # Returns unscheduled tickets.
  scope :unscheduled, not_completed.where(_scheduled: false)

  # Returns scheduled tickets.
  scope :scheduled, not_completed.where(_scheduled: true)

  # Returns the instance-unique identifier for this ticket. This is built by
  # combining the key of the project with the sequence value of this ticket.
  #
  # @return [ String ] The instance-unique identifier for this ticket.
  def identifier
    [project.key, sequence].join('-')
  end

  # Returns the name of the status associated with this ticket.
  #
  # @return [ Symbol ] A name identifying the status code for this ticket.
  def status_name
    STATUSES[status.to_s]
  end
  
  # Returns the name of the priority associated with this ticket.
  #
  # @return [ Symbol ] A name identifying the priority code for this ticket.
  def priority_name
    PRIORITIES[priority.to_s]
  end

  # Checks if this ticket is open.
  #
  # @return [ TrueClass, FalseClass ] True if the ticket is open as closed,
  #   false otherwise.
  def open?
    status_name == :open
  end
  
  # Checks if this ticket is in progress.
  #
  # @return [ TrueClass, FalseClass ] True if the ticket is marked as in
  #   progress, false otherwise.
  def in_progress?
    status_name == :in_progress
  end
  
  # Checks if this ticket is closed.
  #
  # @return [ TrueClass, FalseClass ] True if the ticket is marked as closed,
  #   false otherwise.
  def closed?
    status_name == :closed
  end

  # Start the progress on this ticket.
  def start_progress!
    self.started_at = DateTime.now.utc
    self.status = STATUSES.key(:in_progress)
    self.save!
  end

  # Stop the progress on this ticket.
  def stop_progress!
    accumulate_worked_time
    self.status = STATUSES.key(:open)
    self.save!
  end

  # Close this ticket.
  def close!
    accumulate_worked_time
    self.status = STATUSES.key(:closed)
    self.save!
  end

  # Reopen this ticket.
  def reopen!
    self.status = STATUSES.key(:open)
    self.save!
  end
  
  private

  # Assign a sequence to from the project ticket sequence for this ticket.
  def assign_sequence
    self.sequence = project.ticket_sequence.increment!
  end

  # Accumulate the time this ticket has been in progress into the worked time
  # attribute.
  def accumulate_worked_time
    time_spent = self.started_at.blank? ? 0 : ((DateTime.now.utc - self.started_at) * 24 * 60).to_f
    self.started_at = nil
    self.worked_minutes += time_spent.round
  end

  # Update the relevant ticket progress counters after saving a ticket.
  def update_progress_counters

    # If the _id attribute has changed, this was a newly persisted record.
    is_new = _id_changed?

    # If this is not a new record, decrement the counters based on the previous
    # state of the ticket.
    unless is_new

      milestone_changed = milestone_id_changed?
      old_milestone = if milestone_changed
                        milestone_id_was.blank? ? nil : Milestone.find(milestone_id_was.to_s)
                      else
                        milestone
                      end

      # Decrement the old counters.
      decrement_total_ticket_counters(old_milestone)
      decrement_total_ticket_estimates(estimated_minutes_was, old_milestone) unless estimated_minutes_was.to_i == 0
      if status_was == STATUSES.key(:open).to_i
        decrement_open_ticket_counters(old_milestone)
        decrement_open_ticket_estimates(estimated_minutes_was, old_milestone) unless estimated_minutes_was.to_i == 0
      elsif status_was == STATUSES.key(:in_progress).to_i
        decrement_in_progress_ticket_counters(old_milestone)
        decrement_in_progress_ticket_estimates(estimated_minutes_was, old_milestone) unless estimated_minutes_was.to_i == 0
      elsif status_was == STATUSES.key(:closed).to_i
        decrement_closed_ticket_counters(old_milestone)
        decrement_closed_ticket_estimates(estimated_minutes_was, old_milestone) unless estimated_minutes_was.to_i  == 0
      end

    end

    # Update the state-counters.
    increment_total_ticket_counters(milestone)
    increment_open_ticket_counters(milestone) if open?
    increment_in_progress_ticket_counters(milestone) if in_progress?
    increment_closed_ticket_counters(milestone) if closed?

    # Update the estimates.
    if estimated_minutes.to_i > 0
      increment_total_ticket_estimates(estimated_minutes, milestone)
      increment_open_ticket_estimates(estimated_minutes, milestone) if open?
      increment_in_progress_ticket_estimates(estimated_minutes, milestone) if in_progress?
      increment_closed_ticket_estimates(estimated_minutes, milestone) if closed?
    end

  end

  # Increment a trackable attribute in the relevant ticket progress trackers for
  # this ticket.
  #
  # @param [ Symbol ] key The key of the trackable attribute to increment.
  # @param [ Integer ] amount The amount to increment the attribute with.
  # @param [ Milestone ] milestone The associated milestone to increment
  #   progress tracker for.
  def increment_trackable_attribute(key, amount, milestone)
    project.ticket_progress.inc(key, amount)
    milestone.ticket_progress.inc(key, amount) unless milestone.blank?
  end

  # Increment the relevant total ticket-counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to increment
  #   counters for, if any.
  def increment_total_ticket_counters(milestone)
    increment_trackable_attribute(:total_tickets, 1, milestone)
  end

  # Increment the open ticket counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to increment
  #   counters for, if any.
  def increment_open_ticket_counters(milestone)
    increment_trackable_attribute(:open_tickets, 1, milestone)
  end
  
  # Increment the in progress ticket counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to increment
  #   counters for, if any.
  def increment_in_progress_ticket_counters(milestone)
    increment_trackable_attribute(:in_progress_tickets, 1, milestone)
  end

  # Increment the closed ticket counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to increment
  #   counters for, if any.
  def increment_closed_ticket_counters(milestone)
    increment_trackable_attribute(:closed_tickets, 1, milestone)
  end
  
  # Decrement the relevant total ticket-counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   counters for, if any.
  def decrement_total_ticket_counters(milestone)
    increment_trackable_attribute(:total_tickets, -1, milestone)
  end
  
  # Decrement the open ticket counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   counters for, if any.
  def decrement_open_ticket_counters(milestone)
    increment_trackable_attribute(:open_tickets, -1, milestone)
  end
  
  # Decrement the in progress ticket counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   counters for, if any.
  def decrement_in_progress_ticket_counters(milestone)
    increment_trackable_attribute(:in_progress_tickets, -1, milestone)
  end

  # Decrement the closed ticket counters for this ticket.
  #
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   counters for, if any.
  def decrement_closed_ticket_counters(milestone)
    increment_trackable_attribute(:closed_tickets, -1, milestone)
  end

  # Increment the relevant total ticket estimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to add to the estimates.
  # @param [ Milestone ] milestone The associated milestone to increment
  #   estimates for, if any.
  def increment_total_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:total_estimated_minutes, amount, milestone)
  end
  
  # Increment the open ticket estimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to add to the estimates.
  # @param [ Milestone ] milestone The associated milestone to increment
  #   estimates for, if any.
  def increment_open_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:open_estimated_minutes, amount, milestone)
  end
  
  # Increment the in progress ticket estimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to add to the estimates.
  # @param [ Milestone ] milestone The associated milestone to increment
  #   estimates for, if any.
  def increment_in_progress_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:in_progress_estimated_minutes, amount, milestone)
  end

  # Increment the closed ticket estimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to add to the estimates.
  # @param [ Milestone ] milestone The associated milestone to increment
  #   estimates for, if any.
  def increment_closed_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:closed_estimated_minutes, amount, milestone)
  end
  
  # Decrement the relevant total ticket estimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to remove from the
  #   estimates.
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   estimates in, if any.
  def decrement_total_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:total_estimated_minutes, amount * -1, milestone)
  end

  # Decrement the open ticket estimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to remove to the estimates.
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   estimates for, if any.
  def decrement_open_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:open_estimated_minutes, amount * -1, milestone)
  end
  
  # Decrement the in progress ticket eestimates for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to remove to the estimates.
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   estimates for, if any.
  def decrement_in_progress_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:in_progress_estimated_minutes, amount * -1, milestone)
  end

  # Decrement the closed ticket counters for this ticket.
  #
  # @param [ Integer ] amount The amount of minutes to remove to the estimates.
  # @param [ Milestone ] milestone The associated milestone to decrement
  #   estimates for, if any.
  def decrement_closed_ticket_estimates(amount, milestone)
    increment_trackable_attribute(:closed_estimated_minutes, amount * -1, milestone)
  end

  # Update the scheduled-status of the ticket based on the data set on the
  # ticket model.
  #
  # If the ticket has both a user assigned to it, a milestone, and a priority -
  # it's consider scheduled.
  def update_scheduled_status
    self._scheduled = !self.user_id.blank? && !self.milestone_id.blank? && !self.priority.blank?
    true
  end

end
