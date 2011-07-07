# encoding: utf-8
#

module API_V1 #:nodoc

  # Presents an organization in the format used by version 1 of the API.
  class OrganizationPresenter < Presenter

    protected

    # Returns the JSON representation of a single organization.
    #
    # @param [ Object ] organization The organization to render - defaults to
    #   +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of a organization.
    def present_singular(organization = resource)

      json = {
        :organization => compact_hash({
          id: organization.id,
          identifier: organization.identifier,
          name: organization.name
        })
      }

      json

    end

    # Returns the JSON representation of a collection of organizations.
    #
    # @param [ Object ] organizations The organizations to render - defaults to
    #   +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of a collection of
    #   organizations.
    def present_collection(organizations = resource)
      {
        :organizations => organizations.map { |organization| present_singular(organization)[:organization] }
      }
    end

  end
end
