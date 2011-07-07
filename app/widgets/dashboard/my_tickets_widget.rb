# encoding: utf-8
#

# Displays a list of tickets assigned to the current user.
class Dashboard::MyTicketsWidget < DashboardWidget

  helper TicketHelper
  helper CategoryHelper

  responds_to_event :start, with: :start_progress
  responds_to_event :stop, with: :stop_progress
  responds_to_event :close, with: :close_ticket
  responds_to_event :show, with: :show

  # Display a list of tickets assigned to the current user.
  def display
    @tickets = @current_instance.tickets.assigned_to(@current_user).not_completed.sorted_by_due_date.sorted_by_priority.page(params[:page]).per(10)
    render
  end

  # Show information about a specific ticket in the list.
  def show(event)
    @ticket = @current_instance.tickets.find(event[:ticket_id])
    render
  end

  # Start the progress of one of the tickets within the list.
  def start_progress(event)
    ticket = @current_instance.tickets.find(event[:ticket_id])
    ticket.start_progress!
    replace state: :display
  end

  # Stop the progress of one of the tickets within the list.
  def stop_progress(event)
    ticket = @current_instance.tickets.find(event[:ticket_id])
    ticket.stop_progress!
    replace state: :display
  end
  
  # Close one of the tickets within the list.
  def close_ticket(event)
    ticket = @current_instance.tickets.find(event[:ticket_id])
    ticket.close!
    replace state: :display
  end
  
end
