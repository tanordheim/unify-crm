# encoding: utf-8
#

# Events are user-generated calendar events stored in Unify.
class Event

  # Events are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Add filtering support to tickets.
  include FilteredResult::Model
  
  # Define the fields for the event.
  field :name, type: String
  field :description, type: String
  field :starts_at, type: DateTime
  field :ends_at, type: DateTime
  field :all_day, type: Boolean, default: false

  # Events are associated with instances.
  belongs_to :instance

  # Events have one or more assignees embedded within them to define the users
  # attending the event. Also, make the assignees assignable through mass
  # assignment.
  embeds_many :assignees, class_name: 'EventAssignee'
  accepts_nested_attributes_for :assignees, allow_destroy: true
  attr_accessible :assignees_attributes

  # Events can be associated with people, describing external attendees on the
  # event. Also, make the external attendees assignable through mass assignment.
  embeds_many :external_attendees, class_name: 'EventPerson'
  accepts_nested_attributes_for :external_attendees, allow_destroy: true
  attr_accessible :external_attendees_attributes

  # Events can be associated with a category that describes what kind of event
  # it is. Also, make the category attributes assignable through mass
  # assignment.
  belongs_to :category, class_name: 'EventCategory'
  attr_accessible :category, :category_id

  # Validate that the event is associated with an instance.
  validates :instance, presence: true

  # Validate that the event is associated with at least one assignee.
  validates :assignees, presence: true

  # Validate that the event has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Validate that the event has a start time set, and make the starts_at
  # attribute assignable through mass assignment.
  validates :starts_at, presence: true
  attr_accessible :starts_at

  # Validate that the event has a end time set, and make the ends_at attribute
  # assignable through mass assignment.
  validates :ends_at, presence: true
  attr_accessible :ends_at

  # Make the all_day attribute assignable through mass assignment.
  attr_accessible :all_day

  # Make the description attribute assignable through mass assignment.
  attr_accessible :description
  
  # Returns all the events assigned to the specified user.
  scope :assigned_to, lambda { |user| where('assignees.user_id' => user.id) }

  # Returns all events that starts or ends after the specified time.
  scope :on_or_after, lambda { |time| any_of({ :starts_at.gte => time }, { :starts_at.lte => time, :ends_at.gte => time }) }

  # Returns all events that starts or ends before the specified time.
  scope :on_or_before, lambda { |time| where(:starts_at.lte => time) }

  # Sort events by the start time.
  scope :sorted_by_start_time, order_by(:starts_at.asc)

  # Override the all_day flag based on the duration of the event.
  before_save :override_all_day_based_on_duration

  private

  # Override the all_day flag based on the duration of the event. If the event
  # spans multiple days, we always set all_day to true.
  def override_all_day_based_on_duration
    starts_on = starts_at.to_date
    ends_on = ends_at.to_date
    if starts_on != ends_on
      self.all_day = true
    end
    true
  end
  
end
