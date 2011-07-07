# encoding: utf-8
#

module API_V1 #:nodoc

  # Presents a user in the format used by version 1 of the API.
  class UserPresenter < Presenter

    protected

    # Returns the JSON representation of a single user.
    #
    # @param [ Object ] user The user to render - defaults to +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of a user.
    def present_singular(user = resource)

      json = {
        :user => compact_hash({
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          title: user.title
        })
      }

      json

    end

    # Returns the JSON representation of a collection of users.
    #
    # @param [ Object ] users The users to render - defaults to +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of a collection of
    #   users.
    def present_collection(users = resource)
      {
        :users => users.map { |user| present_singular(user)[:user] }
      }
    end

  end
end
