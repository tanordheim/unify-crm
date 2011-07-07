# encoding: utf-8
#

module Mongoid #:nodoc

  # Adds support for model sequences to a Mongoid::Document class.
  #
  # This will add a "identifier" attribute to the document, and some callbacks
  # to ensure that the identifier is created if it's missing.
  module ModelSequenceSupport

    extend ActiveSupport::Concern

    included do

      # Add a identifier field.
      field :identifier, type: Integer

      # Write an identifier to the identifier field before creating a model.
      before_save :assign_identifier

    end

    private

    # Returns the parent model holding the identifier sequences to use when
    # generating the sequence for this class.
    #
    # @return [ Object ] The instance of the parent model holding identifier
    #   sequences used to generating the sequence for this class.
    def identifier_parent
      instance
    end

    # Assign an identifier to the identifier attribute from the model sequence
    # for this class.
    def assign_identifier
      self.identifier ||= identifier_parent.model_sequences.for_model_class(self.class).increment!
    end

  end
end
