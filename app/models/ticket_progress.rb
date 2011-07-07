# encoding: utf-8
#

# Tracks progress on tickets within a ticket trackable (a project or a
# milestone).
class TicketProgress

  # Ticket progresses are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the ticket progress.
  field :total_tickets, type: Integer, default: 0
  field :open_tickets, type: Integer, default: 0
  field :in_progress_tickets, type: Integer, default: 0
  field :closed_tickets, type: Integer, default: 0
  field :total_estimated_minutes, type: Integer, default: 0
  field :open_estimated_minutes, type: Integer, default: 0
  field :in_progress_estimated_minutes, type: Integer, default: 0
  field :closed_estimated_minutes, type: Integer, default: 0

  # Ticket progresses can be embedded as a polymorphic association named
  # 'ticket_trackable' using the :as option on the embeds_many directive.
  embedded_in :ticket_trackable, polymorphic: true
  
end
