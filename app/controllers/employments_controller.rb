# encoding: utf-8
#

# Manages employments for a person.
class EmploymentsController < ApplicationController

  respond_to :js, :json

  expose(:person) { current_instance.contacts.people.find(params[:person_id]) }
  expose(:employment) do
    if params[:id]
      person.employments.find(params[:id])
    else
      person.employments.build(params[:employment])
    end
  end

  # GET /people/:person_id/employments
  #
  # Displays a list of all employments.
  def index
    respond_with(person.employments)
  end

  # POST /people/:person_id/employments
  #
  # Creates a new employment.
  def create
    flash[:notice] = 'The employment was successfully created.' if employment.save
    respond_with(employment)
  end

  # PUT /people/:person_id/employments/:id
  #
  # Updates an employment.
  def update
    flash[:notice] = 'The employment was successfully updated.' if employment.update_attributes(params[:employment])
    respond_with(employment)
  end

  # DELETE /people/:person_id/employment/:id
  #
  # Removes an employment.
  def destroy
    employment.destroy
    flash[:notice] = 'The employment was successfully removed.'
    respond_with(employment)
  end
  
end
