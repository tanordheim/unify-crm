# encoding: utf-8
#

Fabricator(:source) do
  instance!
  name { Faker::Lorem.sentence }
end
