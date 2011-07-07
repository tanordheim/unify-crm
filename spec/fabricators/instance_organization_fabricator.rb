# encoding: utf-8
#

Fabricator(:instance_organization) do
  instance!
  name { Faker::Company.name }
  street_name { Faker::Address.street_name }
  zip_code { Faker::Address.zip_code }
  city { Faker::Address.city }
  country { Faker::Address.country }
  vat_number { Faker::PhoneNumber.phone_number }
  bank_account_number { Faker::PhoneNumber.phone_number }
end
