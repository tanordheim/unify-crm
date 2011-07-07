# encoding: utf-8
#

Fabricator(:twitter_account) do
  location { TwitterAccount::LOCATIONS.keys.sample.to_i }
  username { Faker::Internet.user_name }

  # If no tweetable is assigned to the twitter account, associate it with an
  # organization.
  after_build do |twitter_account|
    if twitter_account.tweetable.blank?
      twitter_account.tweetable = Fabricate(:organization)
    end
  end
end
