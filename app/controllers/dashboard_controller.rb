# encoding: utf-8
#

# Presents the user with a dashboard containing widgets that displays the
# content most relevant to the user.
class DashboardController < ApplicationController

  respond_to :html, :js

  expose(:my_tickets) { current_instance.tickets.assigned_to(current_user).scheduled.sorted_by_priority.sorted_by_due_date.page(params[:my_tickets_page]).per(10) }
  expose(:reported_tickets) { current_instance.tickets.reported_by(current_user).not_completed.sorted_by_priority.sorted_by_due_date.page(params[:reported_tickets_page]).per(10) }

  expose(:my_events) { current_instance.events.assigned_to(current_user).sorted_by_start_time }
  expose(:todays_events) { my_events.on_or_after(Time.now.beginning_of_day).on_or_before(Time.now.end_of_day) }
  expose(:this_weeks_events) { my_events.on_or_after(Time.now.tomorrow.beginning_of_day).on_or_before(Time.now.end_of_week) }
  expose(:next_weeks_events) { my_events.on_or_after(Time.now.next_week).on_or_before(Time.now.next_week.end_of_week) }

  set_navigation_section :dashboard
  
  # GET /
  #
  # Displays the dashboard to the current user.
  def index
  end

end
