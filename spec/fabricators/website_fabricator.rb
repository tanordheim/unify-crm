# encoding: utf-8
#

Fabricator(:website) do
  location { Website::LOCATIONS.keys.sample.to_i }
  url { "http://#{Faker::Internet.domain_name}" }

  # If no websiteable is assigned to the website, associate it with an
  # organization.
  after_build do |website|
    if website.websiteable.blank?
      website.websiteable = Fabricate(:organization)
    end
  end
end
