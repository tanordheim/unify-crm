# encoding: utf-8
#

module API_V1 #:nodoc

  # Presents a set of ActiveModel::Errors in a format used by version 1 of the
  # API.
  class ActiveModelErrorsPresenter < Presenter

    # Returns the JSON representation of a single error.
    #
    # @param [ Object ] error The error to render - defaults to +resource+.
    #
    # @return [ Hash ] A hash representing the JSON variant of an error.
    def present_singular(error = resource)

      json = { :errors => {} }
      error.keys.each do |attribute|
        json[:errors][attribute.to_sym] = error.get(attribute)
      end

      json

    end

  end

end
