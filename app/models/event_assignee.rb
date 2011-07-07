# encoding: utf-8
#

# Event assignees defines relationships between events and a user assigned to
# attend the event.
class EventAssignee

  # Event assignees are Mongoid documents.
  include Mongoid::Document

  # Event assignees are embedded within events, as an inversed association of
  # the assignees collection.
  embedded_in :event, inverse_of: :assignees

  # Event assignees are associated with users.
  belongs_to :user

  # Validate that the event assignee is associated with a user. Also, make the
  # user and user_id attributes assignble through mass assignment.
  validates :user, presence: true, uniqueness: true
  attr_accessible :user, :user_id

end
