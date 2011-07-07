# encoding: utf-8
#

Fabricator(:invoice_line) do
  invoice!
  product!
  description { Faker::Lorem.sentence }
  price_per { 100.0 * rand(1..5) }
  quantity { rand(1..5) }
end
