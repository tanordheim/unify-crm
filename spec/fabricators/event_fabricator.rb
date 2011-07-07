# encoding: utf-8
#

Fabricator(:event) do
  instance!
  assignees do |event|
    event.assignees = [Fabricate.build(:event_assignee, event: event)]
  end
  external_attendees do |event|
    event.external_attendees = [Fabricate.build(:event_person, event: event)]
  end
  name { Faker::Lorem.sentence }
  starts_at { DateTime.now + rand(0..20).days }
  ends_at { DateTime.now + rand(0..20).days }
end
