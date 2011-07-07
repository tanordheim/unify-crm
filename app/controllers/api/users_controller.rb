# encoding: utf-8
#

# RESTful API controller for user management.
class Api::UsersController < ApiController

  expose(:user) { current_instance.users.find(params[:id]) }

  # GET /api/users/:id
  #
  # Returns information about a specific user.
  def show
    respond_with(user)
  end

end
