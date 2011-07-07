# encoding: utf-8
#

# Manages events for the Unify instance.
class EventsController < ApplicationController

  respond_to :js

  expose(:event) do
    if params[:id].blank?

      e = current_instance.events.build(params[:event])

      # If the event has no assignees, add the current user as the default
      # assignee.
      e.assignees.build(user: current_user) if e.assignees.empty?

      e

    else
      current_instance.events.find(params[:id])
    end
  end
  expose(:users) { current_instance.users.sorted_by_name }
  expose(:categories) { current_instance.categories.events.sorted_by_name }

  # GET /events/new
  #
  # Displays the form used to create a new event.
  def new
    respond_with(event)
  end

  # POST /events
  #
  # Creates a new event.
  def create
    flash[:notice] = 'The event was successfully created.' if event.save
    respond_with(event)
  end

  # GET /events/:id
  #
  # Displays information about an event.
  def show
    respond_with(event)
  end

  # GET /events/:id/edit
  #
  # Displays the form used to modify an event.
  def edit
    respond_with(event)
  end

  # PUT /events/:id
  #
  # Updates an event.
  def update
    flash[:notice] = 'The event was successfully updated.' if event.update_attributes(params[:event])
    respond_with(event)
  end

end
