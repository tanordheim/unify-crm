# encoding: utf-8
#

Fabricator(:page) do
  instance!
  project!
  name { Faker::Lorem.sentence }
  body { Faker::Lorem.sentence }
end
