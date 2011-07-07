# encoding: utf-8
#

# Event assignees defines relationships between events and a person attending
# the event.
class EventPerson

  # Event people are Mongoid documents.
  include Mongoid::Document

  # Event people are embedded within events, as an inversed association of
  # the external_attendees collection.
  embedded_in :event, inverse_of: :external_attendees

  # Event people are associated with people.
  belongs_to :person

  # Validate that the event person is associated with a person. Also, make the
  # person and person_id attributes assignble through mass assignment.
  validates :person, presence: true, uniqueness: true
  attr_accessible :person, :person_id

end
