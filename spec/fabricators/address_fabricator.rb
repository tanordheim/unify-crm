# encoding: utf-8
#

Fabricator(:address) do
  location { Address::LOCATIONS.keys.sample.to_i }
  street_name { Faker::Address.street_name }
  zip_code { Faker::Address.zip_code }
  city { Faker::Address.city }
  state { Faker::Address.state }
  country { Faker::Address.country }

  # If no addressable is assigned to the address, associate it with an
  # organization.
  after_build do |address|
    if address.addressable.blank?
      address.addressable = Fabricate(:organization)
    end
  end
end
