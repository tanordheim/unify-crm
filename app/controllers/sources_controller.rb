# encoding: utf-8
#

# Manages the sources for the Unify instance.
class SourcesController < ApplicationController

  respond_to :html, :js

  expose(:sources) { current_instance.sources.sorted_by_name }
  expose(:source) do
    if params[:id].blank?
      current_instance.sources.build(params[:source])
    else
      current_instance.sources.find(params[:id])
    end
  end

  # GET /sources
  #
  # Displays a list of sources.
  def index
    respond_with(sources)
  end

  # GET /sources/new
  #
  # Displays the form used to create a new source.
  def new
    respond_with(source)
  end

  # POST /sources
  #
  # Creates a new source.
  def create
    flash[:notice] = 'The source was successfully created.' if source.save
    respond_with(source)
  end

  # GET /sources/:id/edit
  #
  # Displays the form used to modify a source.
  def edit
    respond_with(source)
  end

  # PUT /sources/:id
  #
  # Updates a source.
  def update
    flash[:notice] = 'The source was successfully updated.' if source.update_attributes(params[:source])
    respond_with(source)
  end

  # DELETE /sources/:id
  #
  # Removes a source.
  def destroy
    flash[:notice] = 'The source was successfully removed.' if source.destroy
    respond_with(source)
  end
  
end
