# encoding: utf-8
#

# Helpers for the TwitterAccount model class.
module TwitterAccountHelper

  # Returns a collection of locations for a twitter account in a format ready to
  # use in a collection input element.
  def twitter_account_location_collection
    TwitterAccount::LOCATIONS.keys.sort.map do |location|
      [I18n.t("twitter_accounts.location.#{TwitterAccount::LOCATIONS[location]}"), location]
    end
  end

  # Returns the name of the twitter account location.
  #
  # @param [ String ] key The key defining the location.
  #
  # @return [ String ] The name of the location.
  def twitter_account_location_name(key)
    I18n.t("twitter_accounts.location.#{key}")
  end
  
  # Returns the URL for a twitter account.
  #
  # @param [ TwitterAccount ] twitter_account The twitter account to find the
  #   URL for.
  #
  # @return [ String ] The URL to the twitter account.
  def twitter_account_path(twitter_account)
    url_for([twitter_account.tweetable, twitter_account])
  end
  
end
