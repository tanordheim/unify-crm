# encoding: utf-8
#

Fabricator(:invoice) do
  instance!
  organization!
  project!
  state { Invoice::STATES.keys.sample.to_i }
  billed_on { Date.today }
  due_on { Date.today + rand(15..30).days }
  description { Faker::Lorem.sentence }
  biller_reference { Faker::Name.name }
  organization_reference { Faker::Name.name }
  lines do |invoice|
    [
      Fabricate.build(:invoice_line, invoice: nil, quantity: 1, price_per: (100.0 * rand(1..15)))
    ]
  end
end
