# encoding: utf-8
#

# Manages the organizations registered in the Unify instance.
class OrganizationsController < ContactsController

  expose(:organizations) { current_instance.contacts.organizations.sorted_by_name }
  expose(:organization) do
    if params[:id].blank?
      o = Organization.new(params[:organization])
      o.instance = current_instance
      o
    else
      current_instance.contacts.organizations.find(params[:id])
    end
  end
  expose(:contact) { organization }

  # GET /organizations/:id
  #
  # Shows information about an organization.
  def show
    respond_with(organization)
  end

  # GET /organizations/new
  #
  # Displays the form used to create an organization.
  def new
    respond_with(organization)
  end

  # POST /organizations
  #
  # Creates a new organization.
  def create
    flash[:notice] = 'The organization was successfully created.' if organization.save
    respond_with(organization)
  end

  # GET /organizations/:id/edit
  #
  # Displays the form used to modify an organization.
  def edit
    respond_with(organization)
  end

  # PUT /organizations/:id
  #
  # Update an organization.
  def update
    flash[:notice] = 'The organization was successfully updated.' if organization.update_attributes(params[:organization])
    respond_with(organization)
  end

  # GET /organizations/typeahead
  #
  # Returns typeahead JSON data for organizations
  def typeahead

    results = organizations.csearch(params[:term] || '').map do |organization|
      { value: organization.id.to_s, label: organization.name }
    end

    render json: results.to_json

  end
  
end
