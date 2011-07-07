# encoding: utf-8
#

module FilteredResult #:nodoc

  # Specifies a filter for a model.
  class Filter

    attr_reader :name, :value, :options

    # Initialize a new filter.
    def initialize(name, value, *args)
      @name = name
      @value = value
      @options = args.extract_options!
    end

    # Applies the current filter to the current query scope.
    #
    # @param [ Mongoid::Criteria ] scope The current scope to add the filter to.
    #
    # @return [ Mongoid::Criteria ] The modified scope.
    def apply_to_scope(scope)
      scope
    end

    # Returns the type name of the filter.
    #
    # @return [ Symbol ] The type name of the filter.
    def type
      self.class.name.demodulize.underscore.gsub(/_filter$/, '').to_sym
    end

    # Returns the URL param representation of the filter.
    #
    # @return [ String ] The param representation of the filter.
    def to_param
      "filter[#{name}]=#{value}"
    end

  end

end
