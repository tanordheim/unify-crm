# encoding: utf-8
#

# Manages email addresses for an emailable entity.
class EmailAddressesController < ApplicationController

  respond_to :js

  expose(:emailable_type) { find_emailable_type }
  expose(:emailable_id) { params[:"#{emailable_type}_id"] }
  expose(:emailable) { find_emailable }
  expose(:email_address) do
    if params[:id]
      emailable.email_addresses.find(params[:id])
    else
      emailable.email_addresses.build(params[:email_address])
    end
  end

  # POST /<emailable>/<emailable_id>/email_addresses
  #
  # Create a new email address for the emailable.
  def create
    flash[:notice] = 'The email address was successfully added.' if email_address.save
    respond_with(email_address)
  end

  # DELETE /<emailable>/<emailable_id>/email_addresses/:id
  #
  # Removes an email address from the emailable.
  def destroy
    email_address.destroy
    flash[:notice] = 'The email address was successfully removed.'
    respond_with(email_address)
  end

  private

  # Find the emailable type for the request.
  #
  # @return [ Symbol ] The name of the emailable type.
  def find_emailable_type
    %w(organization person).each do |type|
      param_name = [type, 'id'].join('_').to_sym
      requested_id = params[param_name]
      return type.to_sym unless requested_id.blank?
    end
    nil
  end

  # Find the requested emailable.
  #
  # @return [ Mongoid::Document ] The emailable Mongoid document.
  def find_emailable
    emailable_type.to_s.classify.constantize.find(emailable_id)
  end

end
