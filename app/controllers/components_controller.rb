# encoding: utf-8
#

# Manages the components for a project.
class ComponentsController < ApplicationController

  respond_to :html, :js

  expose(:project) { current_instance.projects.find(params[:project_id]) }
  expose(:components) { project.components.sorted_by_name }
  expose(:component) do
    if params[:id].blank?
      project.components.build(params[:component])
    else
      project.components.find(params[:id])
    end
  end

  set_navigation_section :projects
  
  # GET /projects/:project_id/components
  #
  # Lists all components for the current project.
  def index
    respond_with(components)
  end

  # GET /projects/:project_id/components/new
  #
  # Displays the form used to create a new component.
  def new
    respond_with(component)
  end

  # POST /projects/:project_id/components
  #
  # Creates a new component for the current project.
  def create
    flash[:notice] = 'The component was successfully created.' if component.save
    respond_with(component)
  end

  # GET /projects/:project_id/components/:id/edit
  #
  # Displays the form used to modify a component.
  def edit
    respond_with(component)
  end

  # PUT /projects/:project_id/components/:id
  #
  # Updates a component.
  def update
    flash[:notice] = 'The component was successfully updated.' if component.update_attributes(params[:component])
    respond_with(component)
  end

end
