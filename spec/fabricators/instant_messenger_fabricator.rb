# encoding: utf-8
#

Fabricator(:instant_messenger) do
  protocol { InstantMessenger::PROTOCOLS.keys.sample.to_i }
  location { InstantMessenger::LOCATIONS.keys.sample.to_i }
  handle { Faker::Internet.user_name }

  # If no instant messageable is assigned to the instant messenger, associate it
  # with an organization.
  after_build do |instant_messenger|
    if instant_messenger.instant_messageable.blank?
      instant_messenger.instant_messageable = Fabricate(:organization)
    end
  end
end
