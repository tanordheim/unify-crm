# encoding: utf-8
#

Fabricator(:milestone) do
  instance!
  project!
  name { Faker::Lorem.sentence }
  starts_on { Date.today + rand(1..10).days }
  ends_on { Date.today + rand(10..20).days }
end
