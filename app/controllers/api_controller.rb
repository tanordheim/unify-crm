# encoding: utf-8
#

# Load our API renderers.
require File.join(Rails.root, 'app', 'renderers', 'api_v1_renderer')

# Base controller for all REST API controllers in Unify.
class ApiController < ApplicationController

  # Don't verify authenticity tokens on API requests.
  skip_before_filter :verify_authenticity_token

  # Don't authenticate users on API requests.
  skip_before_filter :authenticate_user!

  # Authenticate the request using the API application token.
  before_filter :authenticate_api_application

  # Respond to our different API versions.
  respond_to :api_v1

  # Use the API responder to handle api responses.
  self.responder = ApiResponder

  # Rescue record not found-errors and present some proper JSON data to the
  # client.
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :record_not_found
  # rescue_from Mongoid::Errors::NoResult, :with => :record_not_found

  private

  # Authenticate the current API request using the application token header.
  #
  # @return [ FalseClass, TrueClass ] True if the application token is valid,
  #   false otherwise.
  def authenticate_api_application

    token = request.headers['X-Unify-Token']
    return access_denied if token.blank?

    application = current_instance.api_applications.where(token: token).first
    return access_denied if application.blank?

    true

  end

  # Returns an access denied error to the requesting client.
  #
  # @return [ FalseClass ] Always returns false.
  def access_denied
    render :text => "You don't have access to this resource", :status => 401
    false
  end

  # Displays an error message indicating the requested content could not be
  # found.
  #
  # @return [ FalseClass ] Always returns false.
  def record_not_found
    render :text => 'The record you requested was not found', :status => 404
    false
  end

end
