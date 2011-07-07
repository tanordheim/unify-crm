# encoding: utf-8
#

# Manages instant messengers for a instant_messageable entity.
class InstantMessengersController < ApplicationController

  respond_to :js

  expose(:instant_messageable_type) { find_instant_messageable_type }
  expose(:instant_messageable_id) { params[:"#{instant_messageable_type}_id"] }
  expose(:instant_messageable) { find_instant_messageable }
  expose(:instant_messenger) do
    if params[:id]
      instant_messageable.instant_messengers.find(params[:id])
    else
      instant_messageable.instant_messengers.build(params[:instant_messenger])
    end
  end

  # POST /<instant_messageable>/<instant_messageable_id>/instant_messengers
  #
  # Create a new instant messenger for the instant_messageable.
  def create
    flash[:notice] = 'The instant messenger was successfully added.' if instant_messenger.save
    respond_with(instant_messenger)
  end

  # DELETE /<instant_messageable>/<instant_messageable_id>/instant_messengers/:id
  #
  # Removes a instant messenger from the instant_messageable.
  def destroy
    instant_messenger.destroy
    flash[:notice] = 'The instant messenger was successfully removed.'
    respond_with(instant_messenger)
  end

  private

  # Find the instant_messageable type for the request.
  #
  # @return [ Symbol ] The name of the instant_messageable type.
  def find_instant_messageable_type
    %w(organization person).each do |type|
      param_name = [type, 'id'].join('_').to_sym
      requested_id = params[param_name]
      return type.to_sym unless requested_id.blank?
    end
    nil
  end

  # Find the requested instant_messageable.
  #
  # @return [ Mongoid::Document ] The instant_messageable Mongoid document.
  def find_instant_messageable
    instant_messageable_type.to_s.classify.constantize.find(instant_messageable_id)
  end

end
