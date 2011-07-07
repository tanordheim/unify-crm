# encoding: utf-8
#

Fabricator(:product) do
  instance!
  account!
  key { sequence(:key) { |i| "PRODUCT_#{i}" } }
  name { Faker::Lorem.sentence }
  price { 100.0 * rand(100..200) }
end
