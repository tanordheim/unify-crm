# encoding: utf-8
#

module FilteredResult #:nodoc

  # Adds result filtering support to a Mongoid model.
  module Model

    extend ActiveSupport::Concern

    included do
      scope :filter_results, lambda { |filters| apply_filters(filters) }
    end

    module ClassMethods

      # Apply the filters to the query.
      #
      # @param [ Hash ] filters A hash of filter definitions.
      #
      # @return [ Mongoid::Criteria ] The criteria including the requested
      #   filters.
      def apply_filters(filters)
        current_scope = scoped
        filters.each do |name, filter|
          current_scope = filter.apply_to_scope(current_scope)
        end
        current_scope
      end

    end

  end

end
