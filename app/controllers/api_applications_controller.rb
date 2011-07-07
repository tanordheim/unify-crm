# encoding: utf-8
#

# Manages the API applications for the Unify instance.
class ApiApplicationsController < ApplicationController

  respond_to :html, :js
  expose(:applications) { current_instance.api_applications }
  expose(:application) do
    if params[:id].blank?
      current_instance.api_applications.build(params[:api_application])
    else
      current_instance.api_applications.find(params[:id])
    end
  end

  # GET /api_applications
  #
  # Displays a list of API applications
  def index
    respond_with(applications)
  end

  # GET /api_applications/new
  #
  # Displays the form used to create a new API application.
  def new
    respond_with(application)
  end

  # POST /api_applications
  #
  # Creates a new API application.
  def create
    flash[:notice] = 'The API application was successfully created.' if application.save
    respond_with(application)
  end

  # GET /api_applications/:id/edit
  #
  # Displays the form used to modify an API application.
  def edit
    respond_with(application)
  end

  # PUT /api_applications/:id
  #
  # Updates an API application.
  def update
    flash[:notice] = 'The API application was successfully updated.' if application.update_attributes(params[:api_application])
    respond_with(application)
  end

  # DELETE /api_applications/:id
  #
  # Removes a API application.
  def destroy
    flash[:notice] = 'The API application was successfully removed.' if application.destroy
    respond_with(application)
  end

end
