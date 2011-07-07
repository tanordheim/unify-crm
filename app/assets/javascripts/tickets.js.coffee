$.performTicketAction = (action, data) ->

  form = $('#ticket-actions-form')
  projectId = form.attr('data-project-id')
  form.attr('action', "/projects/#{projectId}/tickets/#{action}")

  # If the hidden block containing hidden fields isn't present, create it.
  paramsBlock = $('#ticket-action-params')
  if paramsBlock.length == 0
    paramsBlock = $('<div id="ticket-action-params" class="hide"/>')
    form.append(paramsBlock)


  # Empty the params block and add fields for our new data.
  paramsBlock.empty()
  for key, value of data
    paramsBlock.append($("<input type='hidden' name='#{key}' value='#{value}'>"))

  # Add the current filters to the data.
  $('ul.filter [data-filter][data-filter-value]').each ->
    element = $(@)
    filter = element.attr('data-filter')
    value = element.attr('data-filter-value')
    paramsBlock.append($("<input type='hidden' name='filter[#{filter}]' value='#{value}'>"))

  # Submit the form.
  form.submit()

$.enableTicketActions = ->
  $('#ticket-actions-wrapper').addClass('active')

$.disableTicketActions = ->
  $('#ticket-actions-wrapper').removeClass('active')

$.showTicketEstimateForm = (row) ->
  $('td.estimate .ticket-estimate-value', row).hide()
  $('td.estimate .ticket-estimate-form', row).show()

$.updateTicketEstimateFromForm = (row) ->
  estimatedMinutes = $('td.estimate .ticket-estimate-form input', row).val()
  projectId = row.closest('form#ticket-actions-form').attr('data-project-id')
  ticketId = row.attr('data-ticket-id')

  $.ajax
    data:
      ticket:
        estimated_minutes: estimatedMinutes
    dataType: 'script'
    type: 'PUT'
    url: "/projects/#{projectId}/tickets/#{ticketId}/inline_update"

$.showTicketDueOnForm = (row) ->
  $('td.due-on .ticket-due-on-value', row).hide()
  $('td.due-on .ticket-due-on-form', row).show()

$.updateTicketDueOnFromForm = (row) ->
  dueOn = $('td.due-on .ticket-due-on-form input', row).val()
  projectId = row.closest('form#ticket-actions-form').attr('data-project-id')
  ticketId = row.attr('data-ticket-id')

  $.ajax
    data:
      ticket:
        due_on: dueOn
    dataType: 'script'
    type: 'PUT'
    url: "/projects/#{projectId}/tickets/#{ticketId}/inline_update"

$ ->

  # Select all/select none in the ticket list.
  $('.tickets-table thead th.select input[type="checkbox"]').live 'change', (e) ->
    checkbox = $(e.target)
    if checkbox.is(':checked')
      $('.tickets-table tbody td.select input[type="checkbox"]').attr('checked', true)
    else
      $('.tickets-table tbody td.select input[type="checkbox"]').removeAttr('checked')

  # Show/hide the ticket actions.
  $('.tickets-table .select input[type="checkbox"]').live 'change', (e) ->
    if $('.tickets-table tbody td.select input[type="checkbox"]:checked').length == 0
      $.disableTicketActions()
    else
      $.enableTicketActions()

  # Mass assign milestones for the selected tickets.
  $('#ticket-actions .assign-to-milestone a').live 'click', (e) ->
    e.preventDefault()
    link = $(@)

    milestoneId = link.attr('data-milestone-id')
    if milestoneId?
      $.performTicketAction 'set_milestone'
        milestone_id: milestoneId

  # Mass assign priority for the selected tickets.
  $('#ticket-actions .set-priority a').live 'click', (e) ->
    e.preventDefault()
    link = $(@)
    console.log('link:', link)

    priorityId = link.attr('data-priority')
    if priorityId?
      console.log('Performing action set_priority')
      $.performTicketAction 'set_priority'
        priority: priorityId

  # Mass assign assignee for the selected tickets.
  $('#ticket-actions .assign-to-user a').live 'click', (e) ->
    e.preventDefault()
    link = $(@)

    userId = link.attr('data-user-id')
    if userId?
      $.performTicketAction 'set_user'
        user_id: userId

  # Inline editing of the ticket estimate.
  $('.tickets-table td.estimate .ticket-estimate-value').live 'click', (e) ->
    e.preventDefault()
    $.showTicketEstimateForm($(e.target).closest('tr'))
  $('.tickets-table td.estimate .ticket-estimate-form input').live 'change', (e) ->
    e.preventDefault()
    $.updateTicketEstimateFromForm($(e.target).closest('tr'))

  # Inline editing of the ticket due date.
  $('.tickets-table td.due-on .ticket-due-on-value').live 'click', (e) ->
    e.preventDefault()
    $.showTicketDueOnForm($(e.target).closest('tr'))
  $('.tickets-table td.due-on .ticket-due-on-form input').live 'change', (e) ->
    e.preventDefault()
    $.updateTicketDueOnFromForm($(e.target).closest('tr'))
