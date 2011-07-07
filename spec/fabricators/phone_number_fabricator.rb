# encoding: utf-8
#

Fabricator(:phone_number) do
  location { PhoneNumber::LOCATIONS.keys.sample.to_i }
  number { Faker::PhoneNumber.phone_number }

  # If no phoneable is assigned to the phone number, associate it with an
  # organization.
  after_build do |phone_number|
    if phone_number.phoneable.blank?
      phone_number.phoneable = Fabricate(:organization)
    end
  end
end
