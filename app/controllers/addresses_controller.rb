# encoding: utf-8
#

# Manages addresses for an addressable entity.
class AddressesController < ApplicationController

  respond_to :js, :json

  expose(:addressable_type) { find_addressable_type }
  expose(:addressable_id) { params[:"#{addressable_type}_id"] }
  expose(:addressable) { find_addressable }
  expose(:address) do
    if params[:id]
      addressable.addresses.find(params[:id])
    else
      addressable.addresses.build(params[:address])
    end
  end

  # POST /<addressable>/<addressable_id>/addresses
  #
  # Create a new address for the addressable.
  def create
    flash[:notice] = 'The address was successfully added.' if address.save
    respond_with(address)
  end

  # PUT /<addressable>/<addressable_id>/addresses/:id
  #
  # Updates an address for the addressable.
  def update
    flash[:notice] = 'The address was successfully updated.' if address.update_attributes(params[:address])
    respond_with(address)
  end

  # DELETE /<addressable>/<addressable_id>/addresses/:id
  #
  # Removes an address from the addressable.
  def destroy
    address.destroy
    flash[:notice] = 'The address was successfully removed.'
    respond_with(address)
  end

  private

  # Find the addressable type for the request.
  #
  # @return [ Symbol ] The name of the addressable type.
  def find_addressable_type
    %w(organization person).each do |type|
      param_name = [type, 'id'].join('_').to_sym
      requested_id = params[param_name]
      return type.to_sym unless requested_id.blank?
    end
    nil
  end

  # Find the requested addressable.
  #
  # @return [ Mongoid::Document ] The addressable Mongoid document.
  def find_addressable
    addressable_type.to_s.classify.constantize.find(addressable_id)
  end

end
