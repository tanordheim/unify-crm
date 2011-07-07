# encoding: utf-8
#

# Manages the pages for a project.
class PagesController < ApplicationController

  respond_to :html, :js

  expose(:project) { current_instance.projects.find(params[:project_id]) }
  expose(:pages) { project.pages.sorted_by_name }
  expose(:page) do
    if params[:id].blank?
      p = project.pages.build(params[:page])
      p.instance = current_instance
      p
    else
      project.pages.find(params[:id])
    end
  end

  set_navigation_section :projects

  # GET /projects/:project_id/pages
  #
  # Lists all pages in the current project.
  def index
    respond_with(pages)
  end

  # GET /projects/:project_id/pages/:id
  #
  # Shows a page.
  def show
    respond_with(page)
  end

  # GET /projects/:project_id/pages/new
  #
  # Displays the form used to create a new page.
  def new
    respond_with(page)
  end

  # POST /projects/:project_id/pages
  #
  # Creates a new page.
  def create
    flash[:notice] = 'The page was successfully created.' if page.save
    respond_with(page, location: project_page_path(page.project, page))
  end

  # GET /projects/:project_id/pages/:id/edit
  #
  # Displays the form used to modify a page.
  def edit
    respond_with(page)
  end

  # PUT /projects/:project_id/pages/:id
  #
  # Updates a page.
  def update
    flash[:notice] = 'The page was successfully updated.' if page.update_attributes(params[:page])
    respond_with(page, location: project_page_path(page.project, page))
  end
  
end
