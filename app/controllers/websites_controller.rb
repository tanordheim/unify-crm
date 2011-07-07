# encoding: utf-8
#

# Manages websites for a websiteable entity.
class WebsitesController < ApplicationController

  respond_to :js

  expose(:websiteable_type) { find_websiteable_type }
  expose(:websiteable_id) { params[:"#{websiteable_type}_id"] }
  expose(:websiteable) { find_websiteable }
  expose(:website) do
    if params[:id]
      websiteable.websites.find(params[:id])
    else
      websiteable.websites.build(params[:website])
    end
  end

  # POST /<websiteable>/<websiteable_id>/websites
  #
  # Create a new website for the websiteable.
  def create
    flash[:notice] = 'The website was successfully added.' if website.save
    respond_with(website)
  end

  # DELETE /<websiteable>/<websiteable_id>/websites/:id
  #
  # Removes a website from the websiteable.
  def destroy
    website.destroy
    flash[:notice] = 'The website was successfully removed.'
    respond_with(website)
  end

  private

  # Find the websiteable type for the request.
  #
  # @return [ Symbol ] The name of the websiteable type.
  def find_websiteable_type
    %w(organization person).each do |type|
      param_name = [type, 'id'].join('_').to_sym
      requested_id = params[param_name]
      return type.to_sym unless requested_id.blank?
    end
    nil
  end

  # Find the requested websiteable.
  #
  # @return [ Mongoid::Document ] The websiteable Mongoid document.
  def find_websiteable
    websiteable_type.to_s.classify.constantize.find(websiteable_id)
  end

end
