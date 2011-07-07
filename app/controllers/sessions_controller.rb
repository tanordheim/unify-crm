# encoding: utf-8
#

# Handles sessions and authentications for registered Unify users.
class SessionsController < ApplicationController

  respond_to :html
  layout 'authentication'

  # Don't attempt to authenticate before displaying or submitting the login
  # form.
  skip_before_filter :authenticate_user!, only: [:new, :create]

  # GET /sessions/new
  #
  # Displays the form to authenticate a user.
  def new
  end

  # POST /sessions
  #
  # Attempts to authenticate a user.
  def create

    user = current_instance.users.where(username: params[:username]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'You have been successfully logged in to Unify.'
    else
      flash[:error] = 'Invalid username and/or password.'
      render :new
    end

  end

  # DELETE /sessions
  #
  # Logs out the currently authenticated user.
  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: 'You have been logged out of Unify.'
  end

end
