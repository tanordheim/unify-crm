# encoding: utf-8
#

# Manages the deal stages for the Unify instance.
class DealStagesController < ApplicationController

  respond_to :html, :js

  expose(:stages) { current_instance.deal_stages.sorted_by_percentage }
  expose(:stage) do
    if params[:id].blank?
      current_instance.deal_stages.build(params[:deal_stage])
    else
      current_instance.deal_stages.find(params[:id])
    end
  end

  # GET /deal_stages
  #
  # Displays a list of deal stages.
  def index
    respond_with(stages)
  end

  # GET /deal_stages/new
  #
  # Displays the form used to create a new deal stage.
  def new
    respond_with(stage)
  end

  # POST /deal_stages
  #
  # Creates a new deal stage.
  def create
    flash[:notice] = 'The deal stage was successfully created.' if stage.save
    respond_with(stage)
  end

  # GET /deal_stages/:id/edit
  #
  # Displays the form used to modify a deal stage.
  def edit
    respond_with(stage)
  end

  # PUT /deal_stages/:id
  #
  # Updates a deal stage.
  def update
    flash[:notice] = 'The deal stage was successfully updated.' if stage.update_attributes(params[:deal_stage])
    respond_with(stage)
  end

  # DELETE /deal_stages/:id
  #
  # Removes a deal stage.
  def destroy
    flash[:notice] = 'The deal stage was successfully removed.' if stage.destroy
    respond_with(stage)
  end

end
