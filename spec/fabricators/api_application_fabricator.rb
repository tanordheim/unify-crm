# encoding: utf-8
#

Fabricator(:api_application) do
  instance!
  name { Faker::Lorem.sentence }
  key { sequence(:key) { |i| "APP_#{i}" } }
end
