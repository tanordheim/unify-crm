# encoding: utf-8
#

# RESTful API controller for organization management.
class Api::OrganizationsController < ApiController

  expose(:organizations) { current_instance.contacts.organizations.active.sorted_by_name }
  expose(:organization) { current_instance.contacts.organizations.active.find(params[:id]) }

  # GET /api/organizations
  #
  # Returns a list of all registered organizations.
  def index
    respond_with(organizations)
  end

  # GET /api/organizations/:id
  #
  # Returns information about a specific organization.
  def show
    respond_with(organization)
  end

end
