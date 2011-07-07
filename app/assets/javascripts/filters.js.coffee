class Filter

  # Set up a filter.
  constructor: (element, type) ->
    @$element = element
    @$filterContainer = @$element.closest('ul.filter')
    @type = type
    @defaultFilter = ''
    @$element.data('filter-configured', true)
    @setCurrentUrlAttribute()

  # Returns the current value of the filter.
  currentFilterValue: ->
    $.queryString()["filter[#{@type}]"] || @defaultFilter

  # Returns the URL for the specified filter value.
  urlFor: (value) ->
    params = "page="

    # Go through all configured filters on this page and read the current value
    # from each of them.
    self = @
    filterContainer = @$filterContainer
    $('[data-filter][data-filter-value]').each ->
      filter = $(@)
      unless filter.attr('data-filter') == self.type
        params += "&filter[#{filter.attr('data-filter')}]=#{filter.attr('data-filter-value')}"

    params += "&filter[#{@type}]=#{value}"
    $.queryString(document.location.href, params)

  # Apply the current filter with the specified value.
  applyFilter: (value) ->
    filterUrl = @urlFor(value)
    $.getScript filterUrl, =>
      @setCurrentFilter(value)
      $.pushUrl(document.title, filterUrl)
      @setCurrentUrlAttribute()

  # Set the current filter url as a data attribute on the filter container element.
  setCurrentUrlAttribute: ->
    currentParams = $.queryString()
    currentUrl = $.queryString('', currentParams)
    @$filterContainer.attr('data-filter-url', currentUrl.replace(/^\?/, ''))
    
class ScopeFilter extends Filter

  # Set up a scope filter.
  constructor: (element) ->
    @$link = $('a[data-filter]', element)
    super(element, @$link.attr('data-filter'))

    @defaultFilter = @$link.attr('data-filter-default')
    @$filterLinks = $('.dropdown-menu li', @$element)
    @setCurrentFilter()
    @addClickHandlers()

  # Add click handlers to the filter links.
  addClickHandlers: ->
    type = @type
    self = @
    $('a', @$filterLinks).live 'click', (e) ->
      e.preventDefault()
      value = $(@).attr('data-value')
      self.applyFilter(value)

  # Set the current filter value.
  setCurrentFilter: (currentValue) ->
    currentValue ||= @currentFilterValue()
    @$link.attr('data-filter-value', currentValue)

    $currentLink = $("[data-value=\"#{currentValue}\"]", @$filterLinks)
    if $currentLink
      @setLabel($currentLink.text())

  # Set the label of the currently selected filter.
  setLabel: (label) ->
    @$link.empty()
    @$link.append(label)
    @$link.append($('<b class="caret"></b>'))

  # Returns the current search query for the page.
  currentSearch: ->
    if $('form.form-search input[type="search"]').length > 0
      $('form.form-search input[type="search"]').val()
    else
      ''

class SearchFilter extends Filter

  # Set up a search filter.
  constructor: (element) ->
    @$input = $('input[type="search"]', element)
    super(element, @$input.attr('data-filter'))
    @setCurrentFilter()
    @addKeyHandlers()

  # Set the current search criteria.
  setCurrentFilter: (criteria) ->
    criteria = if criteria? then criteria else @currentFilterValue()
    @$input.val(criteria)
    @$input.attr('data-filter-value', criteria)

  # Set up key handlers for the search field.
  addKeyHandlers: ->
    @$input.on 'keypress.search', (e) =>
      if e.which == 13
        @applyFilter(@$input.val())
  
$.configureFilters = ->
  $('ul.filter').each ->
    filterContainer = $(@)
    $('li.dropdown', filterContainer).each ->
      unless $(@).data('filter-configured')?
        new ScopeFilter($(@))
    $('li.search', filterContainer).each ->
      unless $(@).data('filter-configured')?
        new SearchFilter($(@))

$ ->
  $.configureFilters()
