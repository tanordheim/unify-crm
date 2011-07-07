# encoding: utf-8
#

# Manages employees for an organization.
class EmployeesController < ApplicationController

  respond_to :js, :json

  expose(:organization) { current_instance.contacts.organizations.find(params[:organization_id]) }
  expose(:people) { current_instance.contacts.people.sorted_by_name }
  expose(:employees) { organization.employees }
  expose(:employment) do
    if params[:id]
      person = current_instance.contacts.people.for_employment(params[:id]).first
      person.employments.find(params[:id])
    elsif !params[:employment] || params[:employment][:person].blank?
      Employment.new(params[:employment])
    else
      person = current_instance.contacts.people.find(params[:employment][:person])
      params[:employment].delete(:person)
      emp = person.employments.build(params[:employment])
      emp.organization = organization
      emp
    end
  end

  # GET /organizations/:organization_id/employees
  #
  # Displays a list of all employees.
  def index
    respond_with(employees)
  end

  # POST /organizations/:organization_id/employees
  #
  # Creates a new employee.
  def create
    flash[:notice] = 'The employee was successfully added.' if employment.save
    respond_with(employment)
  end
  
end
