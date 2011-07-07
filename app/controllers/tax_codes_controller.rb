# encoding: utf-8
#

# Manages the tax codes for a Unify instance.
class TaxCodesController < ApplicationController

  respond_to :html, :js
  expose(:tax_codes) { current_instance.tax_codes.sorted_by_code }
  expose(:tax_code) do
    if params[:id].blank?
      current_instance.tax_codes.build(params[:tax_code])
    else
      current_instance.tax_codes.find(params[:id])
    end
  end

  expose(:accounts) { current_instance.accounts.without_organization_accounts.sorted_by_number }

  set_navigation_section :accounting

  # GET /tax_codes
  #
  # Displays a list of all available tax codes.
  def index
    respond_with(tax_codes)
  end

  # GET /tax_codes/new
  #
  # Displays the form used to create a new tax code.
  def new
    respond_with(tax_code)
  end

  # POST /tax_codes
  #
  # Creates a new tax code.
  def create
    flash[:notice] = 'The tax code was successfully created.' if tax_code.save
    respond_with(tax_code)
  end

  # GET /tax_codes/:id/edit
  #
  # Displays the form used to edit a tax code.
  def edit
    respond_with(tax_code)
  end

  # PUT /tax_codes/:id
  #
  # Updates a tax code.
  def update
    flash[:notice] = 'The tax code was successfully updated.' if tax_code.update_attributes(params[:tax_code])
    respond_with(tax_code)
  end
  
end
