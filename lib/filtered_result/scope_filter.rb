# encoding: utf-8
#

module FilteredResult #:nodoc

  # Specifies a named scope-oriented filter for a model.
  class ScopeFilter < Filter

    # Applies the current filter to the current query scope.
    #
    # @param [ Mongoid::Criteria ] scope The current scope to add the filter to.
    #
    # @return [ Mongoid::Criteria ] The modified scope.
    def apply_to_scope(scope)

      scope_definition = requested_scope
      scope_method = :"#{scope_definition[:name]}"
      scope_args = scope_definition[:params].blank? ? [] : [scope_definition[:params].call(options[:controller_instance])].flatten

      if scope.respond_to?(scope_method)
        scope = scope.send(scope_method, *scope_args)
      end

      scope

    end

    # Returns the value of the current query scope.
    def value
      requested_scope[:key]
    end

    private

    # Returns the currently requested scope, based on the value and the list of
    # scopes defined on the filter.
    #
    # @return [ Hash ] A hash containing information about the requested scope.
    def requested_scope
      if @value.blank?
        options[:scopes].first
      else
        options[:scopes].select do |scope|
          scope[:key].to_s == @value
        end.first
      end
    end
    
  end

end
