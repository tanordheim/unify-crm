# encoding: utf-8
#

# Manages the calendars for the Unify instance.
class CalendarController < ApplicationController

  include FilteredResult::Controller
  
  respond_to :html, :json, :js, :ics

  expose(:events) do
    results = current_instance.events.filter_results(filters)
    results = results.on_or_after(Time.at(params[:from_epoch].to_i)) unless params[:from_epoch].blank?
    results = results.on_or_before(Time.at(params[:to_epoch].to_i)) unless params[:to_epoch].blank?
    results
  end

  set_navigation_section :calendar

  add_filter :assignee, type: :scope, scopes: [
    { label: 'Me', key: :me, name: :assigned_to, params: lambda { |instance| instance.send(:current_user) } },
    { label: 'Anybody', key: :anybody, name: :scoped }
  ]
  
  # GET /calendar
  #
  # Displays the calendar.
  def index
    respond_with(events) do |format|
      format.ics { send_data(events_as_ical, filename: "#{current_user.username}-#{current_instance.subdomain}-calendar.ics", type: Mime::Type.lookup_by_extension('ics')) }
      format.json { render json: fullcalendar_events_json }
    end
  end

  private

  # Returns all available events for the current user in iCal format.
  #
  # @return [ String ] All available events for the current user in iCal format.
  def events_as_ical

    calendar = RiCal.Calendar do |cal|
      events.each do |e|
        cal.event do |event|
          event.summary = e.name
          event.dtstart = e.starts_at.getutc
          event.dtend = e.ends_at.getutc
        end
      end
    end

    calendar.to_s
    
  end

  # Returns the JSON data structure for the FullCalendar JSON format.
  #
  # @return [ Array ] An array of hashes containing the JSON data structure.
  def fullcalendar_events_json
    events.map do |event|
      {
        id: event.id.to_s,
        title: event.name,
        start: event.starts_at.strftime('%Y-%m-%d %H:%M:%S'),
        end: event.ends_at.strftime('%Y-%m-%d %H:%M:%S'),
        allDay: event.all_day,
        url: event_path(event)
      }
    end
  end

end
