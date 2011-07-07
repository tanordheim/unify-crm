# encoding: utf-8
#

# Base class for all controllers in Unify.
class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :assign_instance!
  before_filter :authenticate_user!

  # Data exposed for the static sidebar.
  expose(:sidebar_my_events) { current_instance.events.assigned_to(current_user).sorted_by_start_time }
  expose(:sidebar_todays_events) { sidebar_my_events.on_or_after(Time.now.beginning_of_day).on_or_before(Time.now.end_of_day) }
  expose(:sidebar_this_weeks_events) { sidebar_my_events.on_or_after(Time.now.tomorrow.beginning_of_day).on_or_before(Time.now.end_of_week) }
  expose(:sidebar_next_weeks_events) { sidebar_my_events.on_or_after(Time.now.next_week).on_or_before(Time.now.next_week.end_of_week) }

  private

  # Assign the current instance based on the subdomain in the HTTP request.
  def assign_instance!
    subdomain = request.subdomains.first.present? ? request.subdomains.first : nil
    @current_instance = Instance.for_subdomain(subdomain).first || raise(InvalidInstanceError.new(subdomain))
  end

  # Returns the currently loaded instance.
  #
  # @return [ Instance ] The currently loaded instance.
  def current_instance
    @current_instance
  end
  helper_method :current_instance

  # Attempt to authenticate the current user.
  #
  # @return [ TrueClass, FalseClass ] Returns true if the user was
  #   authenticated, false otherwise.
  def authenticate_user!

    if user_logged_in?
      @current_user = current_instance.users.find(session[:user_id])
    else

      # If the single access token is defined in the URL, and its valid for a
      # user within the current instance, authenticate the user for this request
      # only.
      if params[:user_token]
        user = current_instance.users.for_token(params[:user_token]).first
        unless user.blank?
          @current_user = user
          return true
        end
      end

      # No authentication could be made, ask the user to sign in.
      redirect_to new_session_path
      return false

    end

    true

  rescue Mongoid::Errors::DocumentNotFound

    # This happens when a user with a valid session attempts to authenticate
    # when the user model is no longer present in the database. Just log the
    # user out and redirect to the login page.
    session[:user_id] = nil
    redirect_to new_session_path
    false

  end

  # Check if the current user is logged in.
  # 
  # @return [ TrueClass, FalseClass ] Returns true if the current user is logged
  #   in, false otherwise.
  def user_logged_in?
    !session[:user_id].blank?
  end

  # Returns the currently authenticated user.
  #
  # @return [ User ] The currently authenticated user.
  def current_user
    @current_user
  end
  helper_method :current_user

end
