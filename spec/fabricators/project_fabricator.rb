# encoding: utf-8
#

Fabricator(:project) do
  instance!
  organization!
  key { sequence(:key) { |i| "PROJECT_#{i}" } }
  name { Faker::Lorem.sentence }
  starts_on { Date.today + rand(1..10).days }
end
