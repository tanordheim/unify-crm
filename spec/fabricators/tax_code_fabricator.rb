# encoding: utf-8
#

Fabricator(:tax_code) do
  instance!
  target_account!(fabricator: :account)
  code { sequence(:code) }
  percentage { rand(1..50) }
  name { Faker::Lorem.sentence }
end
