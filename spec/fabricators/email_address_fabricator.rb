# encoding: utf-8
#

Fabricator(:email_address) do
  location { EmailAddress::LOCATIONS.keys.sample.to_i }
  address { Faker::Internet.email }

  # If no emailable is assigned to the email address, associate it with an
  # organization.
  after_build do |email_address|
    if email_address.emailable.blank?
      email_address.emailable = Fabricate(:organization)
    end
  end
end
