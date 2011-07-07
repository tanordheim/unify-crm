# encoding: utf-8
#

# Helpers for content filtering.
module FilterHelper

  # Builds the DOM for a filter.
  #
  # @param [ Symbol ] name The name of the filter to build DOM for.
  #
  # @return [ String ] The DOM for the filter.
  def filter_for(name)

    # Find the filter definition and use a type-specific method to render the
    # DOM.
    filter = filters[name]
    send(:"#{filter.type}_filter", filter)

  end

  # Returns the URL to the current page including the specified filter.
  #
  # @return [ String ] The URL of the current page with the specified filters.
  def url_for_filter(*args)
    filter_params = args.extract_options!
    filter_params = current_filters.merge(filter_params)
    url_for(filter: filter_params)
  end

  private

  # Render the DOM for a search filter.
  #
  # @param [ FilteredResult::SearchFilter ] filter The filter to render the DOM
  #   for.
  #
  # @return [ String ] The DOM for the filter.
  def search_filter(filter)

    placeholder = filter.options[:placeholder].blank? ? 'Search...' : filter.options[:placeholder]
    search_field_tag "filter[#{filter.name.to_s}]", '', :'data-filter' => filter.name.to_s, placeholder: placeholder
    
  end

  # Render the DOM for a scope filter.
  #
  # @param [ FilteredResult::ScopeFilter ] filter The filter to render the DOM
  #   for.
  #
  # @return [ String ] The DOM for the filter.
  def scope_filter(filter)

    # The link used to select scope.
    default_value = filter.value.blank? ? filter.options[:scopes].first[:key].to_s : filter.value
    link = link_to('', '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown', :'data-filter' => filter.name.to_s, :'data-filter-default' => default_value)

    # Build the dropdown menu elements containing the available scopes.
    scope_elements = filter.options[:scopes].map do |scope|
      filter_link = link_to(scope[:label], '#', :'data-value' => scope[:key].to_s)
      content_tag(:li, filter_link)
    end

    # Return the DOM.
    [link, content_tag(:ul, scope_elements.join('').html_safe, class: 'dropdown-menu')].join('').html_safe
    
  end

  # Render the DOM for an association filter.
  #
  # @param [ FilteredResult::ScopeFilter ] filter The filter to render the DOM
  #   for.
  #
  # @return [ String ] The DOM for the filter.
  def association_filter(filter)

    # The label methods to try on each object in the collection, in prioritized
    # order.
    label_methods = [:username, :name]

    collection = filter.options[:collection].call(self)

    # The link used to select the association.
    default_value = if filter.value.blank?
                      if filter.options[:include_blank]
                        ''
                      else
                        collection.first.id.to_s
                      end
                    else
                      filter.value
                    end
    link = link_to('', '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown', :'data-filter' => filter.name.to_s, :'data-filter-default' => default_value)

    # Build the dropdown menu elements containing the available collection
    # objects.
    collection_elements = collection.map do |obj|
      label = 'Unknown'
      label_methods.each do |label_method|
        if obj.respond_to?(label_method)
          label = obj.send(label_method)
          break
        end
      end
      collection_link = link_to(label, '#', :'data-value' => obj.id.to_s)
      content_tag(:li, collection_link)
    end

    # If we need to include a blank value, add that to the front of the list of
    # collection elements.
    if filter.options[:include_blank]
      blank_link = link_to(filter.options[:include_blank], '#', :'data-value' => '')
      collection_elements.unshift(content_tag(:li, blank_link))
    end
    
    # Return the DOM.
    [link, content_tag(:ul, collection_elements.join('').html_safe, class: 'dropdown-menu')].join('').html_safe
    
  end

end
