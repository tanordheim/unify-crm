$ ->

  $('[data-toggle="popover"]').live 'click', (e) ->
    e.preventDefault()
    $(@).popover('toggle')
