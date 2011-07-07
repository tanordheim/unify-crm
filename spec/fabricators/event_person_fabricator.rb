# encoding: utf-8
#

Fabricator(:event_person) do
  event { Fabricate.build(:event, external_attendees: []) }
  person!
end
