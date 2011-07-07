# encoding: utf-8
#

# Manages phone numbers for a phoneable entity.
class PhoneNumbersController < ApplicationController

  respond_to :js

  expose(:phoneable_type) { find_phoneable_type }
  expose(:phoneable_id) { params[:"#{phoneable_type}_id"] }
  expose(:phoneable) { find_phoneable }
  expose(:phone_number) do
    if params[:id]
      phoneable.phone_numbers.find(params[:id])
    else
      phoneable.phone_numbers.build(params[:phone_number])
    end
  end

  # POST /<phoneable>/<phoneable_id>/phone_numbers
  #
  # Create a new phone number for the phoneable.
  def create
    flash[:notice] = 'The phone number was successfully added.' if phone_number.save
    respond_with(phone_number)
  end

  # DELETE /<phoneable>/<phoneable_id>/phone_numbers/:id
  #
  # Removes a phone number from the phoneable.
  def destroy
    phone_number.destroy
    flash[:notice] = 'The phone number was successfully removed.'
    respond_with(phone_number)
  end

  private

  # Find the phoneable type for the request.
  #
  # @return [ Symbol ] The name of the phoneable type.
  def find_phoneable_type
    %w(organization person).each do |type|
      param_name = [type, 'id'].join('_').to_sym
      requested_id = params[param_name]
      return type.to_sym unless requested_id.blank?
    end
    nil
  end

  # Find the requested phoneable.
  #
  # @return [ Mongoid::Document ] The phoneable Mongoid document.
  def find_phoneable
    phoneable_type.to_s.classify.constantize.find(phoneable_id)
  end

end
