# encoding: utf-8
#

module FilteredResult #:nodoc

  # Specifies a search order for a model.
  class SortFilter < Filter

    # Applies the current filter to the current query scope.
    #
    # @param [ Mongoid::Criteria ] scope The current scope to add the filter to.
    #
    # @return [ Mongoid::Criteria ] The modified scope.
    def apply_to_scope(scope)
      sort_order = requested_sort
      scope.order_by([sort_order[:field], sort_order[:direction]])
    end

    # Returns the value of the current sort order.
    def value
      requested_sort[:key]
    end

    private

    # Returns the currently requested sorting, based on the value and the list
    # of sort orders defined on the filter.
    #
    # @return [ Hash ] A hash containing information about the requested sort
    #   order.
    def requested_sort
      if @value.blank?
        fields_for_controller.first
      else
        fields_for_controller.select do |scope|
          scope[:key].to_s == @value
        end.first
      end
    end

    # Returns all the sort fields applicable to the current controller.
    #
    # @return [ Array ] An array containing all sort fields applicable to the
    #   current controller.
    def fields_for_controller
      @fields_for_controller ||= options[:fields].select do |field|
        field[:only].blank? || [field[:only]].flatten.include?(options[:action_name].to_sym)
      end
    end

  end

end
