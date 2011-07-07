# encoding: utf-8
#

Fabricator(:component) do
  project!
  name { Faker::Lorem.sentence }
end
