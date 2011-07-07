# encoding: utf-8
#

# Manages the milestones for a project.
class MilestonesController < ApplicationController

  include FilteredResult::Controller
  
  respond_to :html, :js, :json

  expose(:project) { current_instance.projects.find(params[:project_id]) }
  expose(:milestones) { project.milestones.filter_results(filters).page(params[:page]).per(15) }
  expose(:milestone) do
    if params[:id].blank?
      m = project.milestones.build(params[:milestone])
      m.instance = current_instance
      m
    else
      project.milestones.find(params[:id])
    end
  end
  expose(:previous_milestone) do
    project.milestones.ends_before(milestone.ends_on).sorted_by_end_date_descending.first
  end
  expose(:next_milestone) do
    project.milestones.ends_after(milestone.ends_on).sorted_by_end_date.first
  end
  expose(:components) { project.components.sorted_by_name }
  expose(:tickets) { milestone.tickets.filter_results(filters).page(params[:page]).per(15) }
  expose(:resolved_tickets) { milestone.tickets.completed.sorted_by_due_date }
  expose(:ticket_categories) { current_instance.categories.tickets.sorted_by_name }
  expose(:comments) { milestone.all_comments.sorted_by_created_time.page(params[:page]).per(10) }
  expose(:commentable) { milestone }
  expose(:users) { current_instance.users.sorted_by_name }

  set_navigation_section :projects

  # Set up the filters for the milestone lists.
  add_filter :keywords, type: :search

  # Filters for the ticket list for any specific milestones.
  add_filter :state, type: :scope, scopes: [
    { label: 'All', key: :all, name: :active },
    { label: 'Closed', key: :deleted, name: :closed }
  ]
  add_filter :category, type: :association, field: :category_id, include_blank: 'Any Category', collection: lambda { |instance| instance.ticket_categories }
  add_filter :component, type: :association, field: :component_id, include_blank: 'Any Component', collection: lambda { |instance| instance.components }
  add_filter :assignee, type: :association, field: :user_id, include_blank: 'Anybody', collection: lambda { |instance| instance.users }
  add_filter :status, type: :scope, scopes: [
    { label: 'Uncompleted', key: :any, name: :not_completed },
    { label: 'Unscheduled', key: :unscheduled, name: :unscheduled },
    { label: 'Open', key: :open, name: :open_status },
    { label: 'In progress', key: :in_progress, name: :in_progress_status },
    { label: 'Closed', key: :closed, name: :completed }
  ]
  add_filter :order, type: :sort, fields: [
    { key: :due_on, field: :due_on, direction: :asc, only: :show },
    { key: :status, field: :status, direction: :asc, only: :show },
    { key: :priority, field: :priority, direction: :asc, only: :show },
    { key: :sequence, field: :sequence, direction: :asc, only: :show },
    { key: :name, field: :name, direction: :asc },
    { key: :starts_on, field: :starts_on, direction: :asc },
    { key: :ends_on, field: :ends_on, direction: :asc }
  ]
  
  # GET /projects/:project_id/milestones
  #
  # Lists all milestones in the current project.
  def index
    respond_with(milestones)
  end

  # GET /projects/:project_id/milestones/:id
  #
  # Shows information about a milestone.
  def show
    respond_with(milestone)
  end

  # GET /projects/:project_id/milestones/new
  #
  # Displays the form used to create a new milestone.
  def new
    respond_with(milestone)
  end

  # POST /projects/:project_id/milestones
  #
  # Creates a new milestone.
  def create
    flash[:notice] = 'The milestone was successfully created.' if milestone.save
    respond_with(milestone, location: project_milestone_path(milestone.project, milestone))
  end

  # GET /projects/:project_id/milestones/:id/edit
  #
  # Displays the form used to modify a milestone.
  def edit
    respond_with(milestone)
  end

  # PUT /projects/:project_id/milestones/:id
  #
  # Updates a milestone.
  def update
    flash[:notice] = 'The milestone was successfully updated.' if milestone.update_attributes(params[:milestone])
    respond_with(milestone, location: project_milestone_path(milestone.project, milestone))
  end
  
  # DELETE /projects/:project_id/milestones/:id
  #
  # Flags a milestone as closed.
  def destroy
    milestone.flag_as_closed!
    render action: :update
  end

  # POST /projects/:project_id/milestones/:id/restore
  #
  # Restores a milestone from closed-state.
  def restore
    milestone.restore!
    render action: :update
  end

  # GET /projects/:project_id/milestones/:id/change_log
  #
  # Displays a change log for the milestone.
  def change_log
    respond_with(milestone)
  end

  # POST /projects/:project_id/milestones/:id/notify
  #
  # Notifies project members about a released milestone.
  def notify

    milestone.project.members.each do |member|
      if !member.user.email_addresses.primary.blank? && !member.user.email_addresses.primary.address.blank?
        MilestoneChangeLogMailer.change_log_email(milestone, current_user, member.user).deliver
      end
    end

    flash[:notice] = "#{view_context.pluralize(milestone.project.members.count, 'project member')} was notified about this milestone."
    respond_with(milestone)

  end
  
end
