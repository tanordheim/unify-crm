# encoding: utf-8
#

# Handles single sign-on sessions and authentications for API applications with
# single sign-on enabled.
class SingleSignonController < ApplicationController

  layout 'authentication'

  # Don't attempt to authenticate before displaying or submitting the login
  # form.
  skip_before_filter :authenticate_user!, only: [:new, :create]

  expose(:application) { current_instance.api_applications.sso_enabled.where(key: params[:application_key]).first }

  # GET /sso/:application_key/new
  #
  # Displays the login form to authenticate a user through a single sign-on
  # service.
  def new

    # If the user is already logged in, show a confirmation dialog. Otherwise,
    # render the login form.
    if user_logged_in?
      authenticate_user! # Needed to set current_user
      render :confirm
    else
      render :new
    end

  end

  # POST /sso/:application_key
  #
  # Attempts to authenticate the user against Unify, and redirects to the
  # callback URL of the application if authentication succeeds.
  def create

    user = current_instance.users.where(username: params[:username]).first
    if user && user.authenticate(params[:password])

      session[:user_id] = user.id
      redirect_to application.sso_callback_url_for(user)

    else
      flash[:error] = 'Invalid username and/or password.'
      render :new
    end

  end

end
