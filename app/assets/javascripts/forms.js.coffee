# Configure color picker fields.
$.configureColorPickers = ->
  $('div.input.color input[type="text"]').each ->
    
    field = $(@)
    field.colorpicker
      showOn: 'both'
      buttonColorize: true
      limit: 'websafe'
      buttonImage: COLOR_PICKER_BUTTON_IMAGE
      parts: ['map', 'bar', 'swatches', 'footer']
      onSelect: (hex) ->
        field.val(hex)

# Configure percentage slider fields.
$.configurePercentageSliders = ->

  $('.input.percentage').each ->
    percentageBlock = $(@)
    sliderElement = $('.percentage-slider', percentageBlock)
    valueField = $('.percentage-value', percentageBlock)
    inputField = $('input[type="hidden"]', percentageBlock)

    initialValue = inputField.val()
    valueField.text("#{initialValue}%")

    sliderElement.slider
      value: initialValue
      step: 5
      slide: (e, ui) ->
        inputField.val(ui.value)
        inputField.change()

    inputField.live 'change', ->
      valueField.text("#{$(@).val()}%")
  
$.updateAddLinkState = ->

  # Go through each add-first-link in the DOM and find the form container for
  # each.
  $('.add-first[data-association]').each ->

    addFirst = $(@)
    container = addFirst.closest('ul, tbody')

    items = $('tr:not([data-association]):visible, li:not([data-association]):not(.title):visible', container)
    if items.length == 0
      $('.add-first[data-association]', container).show()
      $('.add-another[data-association]', container).hide()
    else
      $('.add-first[data-association]', container).hide()
      $('.add-another[data-association]', container).show()

$.startEntityEditing = ->
  editor = $('.entity-info')
  editor.addClass('in-editing')
  $.updateAddLinkState()

$.cancelEntityEditing = ->
  $.stopEntityEditing()

$.stopEntityEditing = ->
  editor = $('.entity-info')
  editor.removeClass('in-editing')

$ ->

  # Set the jQuery date picker defaults.
  $.datepicker.setDefaults
    dateFormat: 'yy-mm-dd'
    firstDay: 1

  # Add jQuery date picker w/hour and minutes on date time fields.
  $('input[type="text"].date_time').live 'focus', ->
    $this = $(@)
    if !$this.data('datepicker')
      $this.datetimepicker
        timeFormat: 'hh:mm'
        stepHour: 1
        stepMinute: 15
        hour: new Date().getHours() + 1

  # Add jQuery date picker to date fields.
  $('input[type="text"].date').live 'focus', ->
    $this = $(@)
    if !$this.data('datepicker')
      $this.datepicker()

  # Handle add first/add another clicks.
  $.updateAddLinkState()
  $('.add-first a, .add-another a').live 'click', (e) ->
    e.preventDefault()

    link = $(e.target)
    association = link.closest('li, tr').attr('data-association')
    container = link.closest('ul, table')

    templateContainer = $("#form-templates [data-association='#{association}']")
    if templateContainer.length == 0
      templateContainer = $("#modal-form-templates [data-association='#{association}']")
    template = templateContainer.html()

    # Build a new ID for the association.
    regexp = new RegExp("new_#{association}", 'g')
    newId = new Date().getTime()
    template = template.replace(regexp, newId)

    # Add the element to the DOM.
    $('.add-first', container).before(template)

    $.updateAddLinkState()

  # Handle association removals.
  $('[data-destroy-association]').live 'click', (e) ->
    e.preventDefault()

    link = $(e.target)
    container = link.closest('li, tr')

    # If the element directly appended to the container is an hidden input
    # element, the association record we are deleting is persisted in the
    # database. Instead of removing it from the DOM, we add a new field
    # indicating we want it destroyed, and hide it from the DOM instead.
    nextElement = container.next()
    if nextElement.is('input') && nextElement.attr('type') == 'hidden'
      fieldName = nextElement.attr('name').replace('[id]', '[_destroy]')
      destroyField = $("<input type='hidden' name='#{fieldName}' value='1'>")
      container.append(destroyField)
      container.hide()
    else
      container.remove()

    $.updateAddLinkState()

  # Handle starting and cancelling of entity editing.
  $('[data-start-editing]').live 'click', (e) ->
    e.preventDefault()
    $.startEntityEditing()
  $('[data-cancel-editing]').live 'click', (e) ->
    e.preventDefault()
    $.cancelEntityEditing()

  # Add color picker to color fields.
  $.configureColorPickers()

  # Auto completion.
  $('input[type="text"][data-autocompletion-source]').live 'keydown.autocomplete', (e) ->

    inputField = $(@)
    hiddenField = inputField.prev('[type="hidden"]')
    apiUrl = inputField.attr('data-autocompletion-source')

    inputField.autocomplete
      source: apiUrl
      minLength: 0
      delay: 0
      select: (e, ui) ->

        if ui.item?
          inputField.val(ui.item.label)
          hiddenField.val(ui.item.value)
        else
          inputField.val('')
          hiddenField.val('')

        false
