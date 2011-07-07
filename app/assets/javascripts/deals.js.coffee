$.configureDealPriceFields = ->

  priceType = $('form.deal select#deal_price_type').val()
  durationContainer = $('form.deal .price-duration')
  durationClassifiers = $('form.deal .price-duration-classifier')

  # Hide all duration classifiers.
  durationClassifiers.hide()

  # A simple map for price type and class name.
  priceTypeClasses =
    '0': 'fixed'
    '1': 'per_hour'
    '2': 'per_month'
    '3': 'per_year'

  # If this not a fixed price, show the duration block.
  if priceType != '0'
    durationContainer.show()

    # Show the appropriate duration classifier.
    $("form.deal .price-duration-classifier.#{priceTypeClasses[priceType]}").show()

  else
    durationContainer.hide()

$ ->

  $('form.deal select#deal_price_type').live 'change', ->
    $.configureDealPriceFields()

  if $('form.deal').length > 0
    $.configureDealPriceFields()

  # Update the probability percentage element when the probability slider
  # changes.
  $('form.deal input#deal_probability').live 'change', (e) ->
    slider = $(e.target)
    label = $('#probability-percentage span')
    label.text("#{slider.val()}%")
  $('#probability-percentage span').text("#{$('input#deal_probability').val()}%")
