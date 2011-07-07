# encoding: utf-8
#

Fabricator(:deal) do
  instance!
  organization!
  person!
  user!
  stage!(fabricator: :deal_stage)
  name { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  price { 1000.00 * rand(100..999).to_f }
  price_type { Deal::PRICE_TYPES.keys.sample.to_i }
  duration { rand(1..10) }
  probability { rand(0..100) }
end
