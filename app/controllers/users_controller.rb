# encoding: utf-8
#

# Manages users for the Unify instance.
class UsersController < ApplicationController

  respond_to :html, :js

  expose(:users) { current_instance.users.sorted_by_name }
  expose(:user) do
    if params[:id].blank?
      current_instance.users.build(params[:user])
    else
      current_instance.users.find(params[:id])
    end
  end

  set_navigation_section :instance

  # GET /users
  #
  # Displays all users.
  def index
    respond_with(users)
  end

  # GET /users/:id
  #
  # Shows information about a user.
  def show
    respond_with(user)
  end

  # GET /users/new
  #
  # Displays the form used to create a new user.
  def new
    respond_with(user)
  end

  # POST /users
  #
  # Creates a new user.
  def create
    flash[:notice] = 'The user was successfully created' if user.save
    respond_with(user)
  end

  # GET /users/:id/edit
  #
  # Displays the form used to modify a user.
  def edit
    respond_with(user)
  end

  # PUT /users/:id
  #
  # Updates a user.
  def update
    flash[:notice] = 'The user was successfully updated.' if user.update_attributes(params[:user])
    respond_with(user)
  end

end
