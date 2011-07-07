# encoding: utf-8
#

# Helpers for the Ticket model class.
module TicketHelper

  # Returns the path to a ticket.
  # 
  # @param [ Ticket ] The ticket to return the description for.
  #
  # @return [ String ] The path to the ticket.
  def ticket_path(ticket)
    project_ticket_path(ticket.project, ticket)
  end

  # Returns the description of a ticket.
  # 
  # @param [ Ticket ] The ticket to return the description for.
  #
  # @return [ String ] The parsed and formatted description of the ticket.
  def ticket_description(ticket)
    simple_format(ticket.description)
  end

  # Returns a collection of priorities for a ticket in a format ready to use in
  # a collection input element.
  def ticket_priority_collection
    Ticket::PRIORITIES.keys.sort.map do |priority|
      [I18n.t("tickets.priority.#{Ticket::PRIORITIES[priority]}"), priority.to_i]
    end
  end

  # Returns the estimate of a ticket in plain text form.
  #
  # @param [ Ticket ] ticket The ticket to return estimate from.
  #
  # @return [ String ] The plain text version of the time estimate on the
  #   ticket.
  def ticket_estimate(ticket, *args)

    options = args.extract_options!
    options[:format] ||= :long

    if ticket.estimated_minutes.blank?
      content_tag(:span, 'None', class: 'muted')
    else

      hours = ticket.estimated_minutes.to_i / 60
      minutes = ticket.estimated_minutes.to_i % 60

      if options[:format] == :long

        output = []
        output << pluralize(hours, 'hour') if hours > 0
        output << pluralize(minutes, 'minute') if minutes > 0
        output.to_sentence

      else

        output = ''
        output << "#{hours}h " if hours > 0
        output << "#{minutes}m" if minutes > 0
        output.strip

      end

    end

  end

  # Returns the inline edit field for ticket estimates.
  #
  # @param [ Ticket ] ticket The ticket to build the inline edit field for.
  #
  # @return [ String ] The DOM elements for the inline edit field.
  def ticket_estimate_field(ticket, *args)

    form_fields = []
    form_fields << text_field_tag("ticket_#{ticket.id.to_s}_estimated_minutes", ticket.estimated_minutes)
    form_fields << content_tag(:span, 'min')

    content_tag(:span, form_fields.join.html_safe, class: 'ticket-estimate-form') + content_tag(:span, ticket_estimate(ticket, *args), class: 'ticket-estimate-value')
    
  end

  # Returns the due date of a ticket in plain text form.
  #
  # @param [ Ticket ] ticket The ticket to return due date from.
  #
  # @return [ String ] The due date of the ticket in plain text form.
  def ticket_due_on(ticket)
    if ticket.due_on.blank?
      content_tag(:span, 'Not set', class: 'muted')
    else
      I18n.l(ticket.due_on, format: :short)
    end
  end

  # Returns the inline edit field for ticket due dates.
  #
  # @param [ Ticket ] ticket The ticket to build the inline edit field for.
  #
  # @return [ String ] The DOM elements for the inline edit field.
  def ticket_due_on_field(ticket)

    form_field = text_field_tag("ticket_#{ticket.id.to_s}_due_on", ticket.due_on, class: 'date')
    label = ticket_due_on(ticket)
    content_tag(:span, form_field, class: 'ticket-due-on-form') + content_tag(:span, label, class: 'ticket-due-on-value')

  end

  # Returns a minute-estimate in hours.
  #
  # @param [ Integer ] minutes The estimated minutes for a ticket.
  #
  # @return [ Integer ] The minutes converted to hours.
  def ticket_estimate_in_hours(estimated_minutes)
    (estimated_minutes.to_f / 60).round
  end

  # Returns the time the ticket has been worked on in plain text form.
  #
  # @param [ Ticket ] ticket The ticket to return worked time from.
  #
  # @return [ String ] The plain text version of the worked time on the ticket.
  def ticket_worked_time(ticket)
    ChronicDuration.output(ticket.worked_minutes * 60, format: :long)
  end
  
  # Returns the status of a ticket in plain text form.
  #
  # @param [ Ticket ] ticket The ticket to return status from.
  #
  # @return [ String ] The plain text version of the status on the ticket.
  def ticket_status(ticket)
    I18n.t("tickets.status.#{ticket.status_name}")
  end
  
  # Returns the priority of a ticket in plain text form.
  #
  # @param [ Ticket ] ticket The ticket to return priority from.
  #
  # @return [ String ] The plain text version of the priority on the ticket.
  def ticket_priority(ticket)
    I18n.t("tickets.priority.#{ticket.priority_name}")
  end
  
  # Returns the CSS class to use on a ticket in a ticket list.
  #
  # @param [ Ticket ] ticket The ticket to figure out CSS class for.
  #
  # @return [ String ] The CSS class to apply on this ticket in listings.
  def ticket_css_class(ticket)
    return 'ticket-closed' if ticket.closed?
    return 'ticket-in-progress' if ticket.in_progress?
    return nil
  end

  # Returns a progress bar showing the progress of a set of tickets.
  #
  # @param [ TicketProgress ] progress A TicketProgress instance that describes
  #   the progress for the tickets.
  #
  # @return [ String ] The markup for a progress bar describing the progress.
  def ticket_progress_bar(progress)

    completed_hours = ticket_estimate_in_hours(progress.closed_estimated_minutes)
    total_hours = ticket_estimate_in_hours(progress.total_estimated_minutes)
    completed_percentage = if progress.total_tickets == 0 || progress.closed_tickets == 0
                             0
                           else
                             ((progress.closed_tickets.to_f / progress.total_tickets.to_f) * 100).ceil
                           end

    bar = content_tag(:div, nil, style: "width: #{completed_percentage}%")
    bar_label = content_tag(:span, "#{completed_percentage}%")
    bar_container = content_tag(:div, bar + bar_label, class: 'progress-bar')
    footer = content_tag(:small, "#{completed_hours} of #{total_hours} hours completed")

    bar_container + footer
    
  end

end
