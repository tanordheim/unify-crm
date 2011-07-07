# encoding: utf-8
#

Fabricator(:payment_form) do
  instance!
  account!
  name { Faker::Lorem.sentence }
end
