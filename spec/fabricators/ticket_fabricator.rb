# encoding: utf-8
#

Fabricator(:ticket) do
  instance!
  project!
  category!(fabricator: :ticket_category)
  user!
  reporter!(fabricator: :user)
  name { Faker::Lorem.sentence }
  priority { Ticket::PRIORITIES.keys.map(&:to_i).sample }
  status { Ticket::STATUSES.keys.map(&:to_i).sample }
  description { Faker::Lorem.sentence }
  due_on { Date.today + rand(1..30).days }
  estimated_minutes { rand(1..10) * 15 }
end
