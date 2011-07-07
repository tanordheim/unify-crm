# encoding: utf-8
#

# Manages the tickets for a project.
class TicketsController < ApplicationController

  include FilteredResult::Controller
  
  respond_to :html, :js, :json

  expose(:project) { current_instance.projects.find(params[:project_id]) }
  expose(:tickets) { project.tickets.filter_results(filters).page(params[:page]).per(15) }
  expose(:mass_tickets) { project.tickets.any_in(_id: [params[:ticket_id]].flatten.compact) }
  expose(:ticket) do
    result = if params[:id].blank?
      t = project.tickets.build(params[:ticket])
      t.instance = current_instance
      t.reporter = current_user
      t
    else
      project.tickets.find(params[:id])
    end
    result
  end
  expose(:comments) { ticket.all_comments.sorted_by_created_time.page(params[:page]).per(10) }
  expose(:commentable) { ticket }

  expose(:categories) { current_instance.categories.tickets.sorted_by_name }
  expose(:milestones) { project.milestones.active.sorted_by_end_date }
  expose(:users) { current_instance.users.sorted_by_name }
  expose(:components) { project.components.sorted_by_name }

  set_navigation_section :projects

  # Set up the filters for the ticket lists.
  add_filter :category, type: :association, field: :category_id, include_blank: 'Any Category', collection: lambda { |instance| instance.categories }
  add_filter :component, type: :association, field: :component_id, include_blank: 'Any Component', collection: lambda { |instance| instance.components }
  add_filter :assignee, type: :association, field: :user_id, include_blank: 'Anybody', collection: lambda { |instance| instance.users }
  add_filter :status, type: :scope, scopes: [
    { label: 'Uncompleted', key: :any, name: :not_completed },
    { label: 'Unscheduled', key: :unscheduled, name: :unscheduled },
    { label: 'Open', key: :open, name: :open_status },
    { label: 'In progress', key: :in_progress, name: :in_progress_status },
    { label: 'Closed', key: :closed, name: :completed }
  ]
  add_filter :keywords, type: :search
  add_filter :order, type: :sort, fields: [
    { key: :due_on, field: :due_on, direction: :asc },
    { key: :status, field: :status, direction: :asc },
    { key: :priority, field: :priority, direction: :asc },
    { key: :sequence, field: :sequence, direction: :asc },
    { key: :name, field: :name, direction: :asc }
  ]
  
  # GET /projects/:project_id/tickets
  #
  # Lists all tickets in the current project.
  def index
    respond_with(tickets)
  end
  
  # GET /projects/:project_id/tickets/:id
  #
  # Shows information about a ticket.
  def show
    respond_with(ticket)
  end

  # GET /projects/:project_id/tickets/new
  #
  # Displays the form used to create a new ticket.
  def new
    respond_with(ticket)
  end

  # POST /projects/:project_id/tickets
  #
  # Creates a new ticket.
  def create
    flash[:notice] = 'The ticket was successfully created.' if ticket.save
    respond_with(ticket, location: project_ticket_path(ticket.project, ticket))
  end

  # GET /projects/:project_id/tickets/:id/edit
  #
  # Displays the form used to modify a ticket.
  def edit
    respond_with(ticket)
  end

  # PUT /projects/:project_id/tickets/:id
  #
  # Updates a ticket.
  def update
    flash[:notice] = 'The ticket was successfully updated.' if ticket.update_attributes(params[:ticket])
    respond_with(ticket, location: project_ticket_path(ticket.project, ticket))
  end

  # POST /projects/:project_id/tickets/start_progress
  #
  # Start the progress on a ticket.
  def start_progress
    ticket.start_progress!
    flash[:notice] = 'The progress on the ticket was started.'
    respond_with(ticket, location: project_ticket_path(ticket.project, ticket))
  end
  
  # POST /projects/:project_id/tickets/stop_progress
  #
  # Stop the progress on a ticket.
  def stop_progress
    ticket.stop_progress!
    flash[:notice] = 'The progress on the ticket was stopped.'
    respond_with(ticket, location: project_ticket_path(ticket.project, ticket))
  end

  # POST /projects/:project_id/tickets/reopen
  #
  # Reopens a closed ticket
  def reopen
    ticket.reopen!
    flash[:notice] = 'The ticket was reopened.'
    respond_with(ticket, location: project_ticket_path(ticket.project, ticket))
  end

  # POST /projects/:project_id/tickets/close
  #
  # Close a ticket
  def close
    ticket.close!
    flash[:notice] = 'The ticket was closed.'
    respond_with(ticket, location: project_ticket_path(ticket.project, ticket))
  end

  # POST /projects/:project_id/tickets/set_milestone
  #
  # Set the milestone of the selected tickets.
  def set_milestone

    milestone = params[:milestone_id].blank? ? nil : milestones.find(params[:milestone_id])
    mass_tickets.each do |ticket|
      ticket.milestone = milestone
      ticket.save
    end

    mass_update

  end
  
  # POST /projects/:project_id/tickets/set_priority
  #
  # Set the priority of the selected tickets.
  def set_priority

    mass_tickets.each do |ticket|
      ticket.priority = params[:priority].blank? ? nil : params[:priority].to_i
      ticket.save
    end

    mass_update

  end

  # POST /projects/:project_id/tickets/set_user
  #
  # Set the assigned user of the selected tickets.
  def set_user

    user = params[:user_id].blank? ? nil : users.find(params[:user_id])
    mass_tickets.each do |ticket|
      ticket.user = user
      ticket.save
    end

    mass_update

  end

  # PUT /projects/:project_id/tickets/inline_update
  #
  # Performs an inline update of a ticket.
  def inline_update
    flash[:notice] = 'The ticket was successfully updated.' if ticket.update_attributes(params[:ticket])
    respond_with(ticket)
  end
  
  private

  # Handle the response of a ticket mass-update.
  def mass_update
    flash[:notice] = 'The tickets were updated.'
    render action: :mass_update
  end
    
  
end
