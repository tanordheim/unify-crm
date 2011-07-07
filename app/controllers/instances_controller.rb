# encoding: utf-8
#

# Allows the user to modify the settings for the Unify instance.
class InstancesController < ApplicationController

  respond_to :html

  expose(:instance) { current_instance }

  set_navigation_section :instance

  # GET /instance
  #
  # Displays the instance settings and the form used to modify them.
  def show
    respond_with(instance)
  end

  # PUT /instance
  #
  # Updates the instance settings.
  def update
    flash[:notice] = 'The instance settings were successfully updated.' if instance.update_attributes(params[:instance])
    Rails.logger.info(instance.model_sequences.collect(&:errors).inspect)
    respond_with(instance, location: instance_path)
  end

end
