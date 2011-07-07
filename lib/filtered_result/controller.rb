# encoding: utf-8
#

module FilteredResult #:nodoc

  # Adds result filtering support to a controller.
  module Controller

    extend ActiveSupport::Concern

    included do
      helper_method :filters
      helper_method :current_filters
    end

    module ClassMethods #:nodoc

      # Adds a filter to the list of available filters.
      #
      # @param [ Symbol ] name The name of the filter to add.
      def add_filter(name, *args)
        before_filter do |instance|
          instance.send(:add_filter, name, *args)
        end
      end

    end

    protected

    # Returns a hash containing the names and values of the current filters.
    #
    # @return [ Hash ] The names and values of the current filters.
    def current_filters
      filters.inject({}) do |hash, filter|
        hash[filter[0]] = filter[1].value unless filter[1].value.blank?
        hash
      end
    end

    # Adds a filter to the list of available filters.
    #
    # @param [ Symbol ] name The name of the filter to add.
    def add_filter(name, *args)

      @filters ||= {}
      
      options = args.extract_options!.dup
      options[:controller_name] = controller_name
      options[:controller_instance] = self
      options[:action_name] = action_name

      type = options.delete(:type)
      filter_class = FilteredResult.const_get(:"#{type.to_s.classify}Filter")
      filter_value = (params[:filter] || {})[name]

      @filters[name] = filter_class.new(name, filter_value, options)

    end

    # Returns all defined filters for the controller.
    #
    # @return [ Hash ] A hash of filter definitions.
    def filters
      @filters ||= {}
    end
    
  end
end
