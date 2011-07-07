# encoding: utf-8
#

Fabricator(:event_assignee) do
  event { Fabricate.build(:event, assignees: []) }
  user!
end
