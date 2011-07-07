# encoding: utf-8
#

# Manages the projects for a Unify instance.
class ProjectsController < ApplicationController

  include FilteredResult::Controller

  respond_to :html, :js, :json

  expose(:projects) { current_instance.projects.filter_results(filters).page(params[:page]).per(15) }
  expose(:project) do
    if params[:id].blank?
      current_instance.projects.build(params[:project])
    else
      current_instance.projects.find(params[:id])
    end
  end
  expose(:comments) { project.all_comments.sorted_by_created_time.page(params[:page]).per(10) }
  expose(:commentable) { project }

  expose(:categories) { current_instance.categories.projects.sorted_by_name }
  expose(:sources) { current_instance.sources.sorted_by_name }
  expose(:users) { current_instance.users.sorted_by_name }
  expose(:released_milestones) { project.milestones.recently_released.limit(3) }
  expose(:pending_milestones) { project.milestones.in_development.sorted_by_end_date }
  expose(:upcoming_milestones) { project.milestones.upcoming.limit(3) }
  
  set_navigation_section :projects

  # Set up the filters for the project lists.
  add_filter :state, type: :scope, scopes: [
    { label: 'All', key: :all, name: :active },
    { label: 'Closed', key: :Closed, name: :closed }
  ]
  add_filter :category, type: :association, field: :category_id, include_blank: 'Any Category', collection: lambda { |instance| instance.categories }
  add_filter :keywords, type: :search
  add_filter :order, type: :sort, fields: [
    { key: :name, field: :name, direction: :asc }
  ]

  # GET /projects
  #
  # Displays all projects.
  def index
    respond_with(projects)
  end

  # GET /projects/:id
  #
  # Shows information about a project.
  def show
    respond_with(project)
  end

  # GET /projects/new
  #
  # Displays the form used to create a new project.
  def new
    respond_with(project)
  end

  # POST /projects
  #
  # Creates a new project.
  def create
    flash[:notice] = 'The project was successfully created.' if project.save
    respond_with(project)
  end

  # GET /projects/:id/edit
  #
  # Displays the form used to modify a project.
  def edit
    respond_with(project)
  end

  # PUT /projects/:id
  #
  # Updates a project.
  def update
    flash[:notice] = 'The project was successfully updated.' if project.update_attributes(params[:project])
    respond_with(project)
  end

  # DELETE /projects/:id
  #
  # Flags a project as closed.
  def destroy
    project.flag_as_closed!
    render action: :update
  end

  # POST /projects/:id/restore
  #
  # Restores a project from closed-state.
  def restore
    project.restore!
    render action: :update
  end
  
end
