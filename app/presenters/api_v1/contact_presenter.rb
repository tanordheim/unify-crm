# encoding: utf-8
#

module API_V1 #:nodoc

  # Presents a contact in the format used by version 1 of the API.
  # This uses the Organization or Person presenter, depending on that type of
  # contacts we need to render.
  class ContactPresenter < Presenter

    protected

    # Returns the JSON representation of a single contact.
    #
    # @param [ Object ] contact The contact to render - defaults to +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of a contact.
    def present_singular(contact = resource)

      if contact.is_a(Organization)
        API_V1::OrganizationPresenter.new(contact).present
      else
        {}
      end

    end

    # Returns the JSON representation of a collection of contacts.
    #
    # @param [ Object ] contacts The contacts to render - defaults to
    # +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of a collection of
    #   contacts.
    def present_collection(contacts = resource)

      if !contacts.empty? && contacts.first.is_a?(Organization)
        API_V1::OrganizationPresenter.new(contacts).present
      else
        {}
      end

    end

  end
end
