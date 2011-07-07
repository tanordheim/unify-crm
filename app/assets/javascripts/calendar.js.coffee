$.setCalendarEventSource = (url) ->

  # Remove the existing source from the calendar if it exists.
  currentSource = $('#calendar').data('currentSourceUrl')
  if currentSource?
    $('#calendar').fullCalendar('removeEventSource', currentSource)

  # Add the new source.
  $('#calendar').fullCalendar('addEventSource', url)

  # Set the current source attribute.
  $('#calendar').data('currentSourceUrl', url)

  # # Refetch the events.
  # $('#calendar').fullCalendar('refetchEvents')

$ ->

  # Initialize the calendar view.
  $('#calendar').fullCalendar
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'agendaWeek'
    firstDay: 1
    startParam: 'from_epoch'
    endParam: 'to_epoch'
    timeFormat: 'H(:mm)'
    axisFormat: 'H:mm'

    eventClick: (calEvent, jsEvent, view) ->
      jsEvent.preventDefault()
      $.getScript(calEvent.url)

    dayClick: (date, allDay, jsEvent, view) ->
      jsEvent.preventDefault()
      startsAt = "#{date.getFullYear()}-#{date.getMonth() + 1}-#{date.getDate()} #{date.getHours()}:#{date.getMinutes()}"
      endDate = new Date(date)
      endDate.setMinutes(date.getMinutes() + 30)
      endsAt = "#{endDate.getFullYear()}-#{endDate.getMonth() + 1}-#{endDate.getDate()} #{endDate.getHours()}:#{endDate.getMinutes()}"
      $.getScript("/events/new?event[starts_at]=#{startsAt}&event[ends_at]=#{endsAt}")

  # Set the current source of the calendar.
  currentFilter = $('ul.filter').attr('data-filter-url')
  eventsUrl = "/calendar.json?#{currentFilter}"
  $.setCalendarEventSource(eventsUrl)
