# encoding: utf-8
#

module FilteredResult #:nodoc

  # Specifies a association-oriented filter for a model.
  class AssociationFilter < Filter

    # Applies the current filter to the current query scope.
    #
    # @param [ Mongoid::Criteria ] scope The current scope to add the filter to.
    #
    # @return [ Mongoid::Criteria ] The modified scope.
    def apply_to_scope(scope)
      scope = scope.where(options[:field] => value) unless value.blank?
      scope
    end

  end

end
