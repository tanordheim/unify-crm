# encoding: utf-8
#

# Manages the payment forms for a Unify instance.
class PaymentFormsController < ApplicationController

  respond_to :html, :js
  expose(:payment_forms) { current_instance.payment_forms.sorted_by_name }
  expose(:payment_form) do
    if params[:id].blank?
      current_instance.payment_forms.build(params[:payment_form])
    else
      current_instance.payment_forms.find(params[:id])
    end
  end

  expose(:accounts) { current_instance.accounts.without_organization_accounts.sorted_by_number }

  set_navigation_section :accounting

  # GET /payment_forms
  #
  # Displays a list of all available payment forms.
  def index
    respond_with(payment_forms)
  end

  # GET /payment_forms/new
  #
  # Displays the form used to create a new payment form.
  def new
    respond_with(payment_forms)
  end

  # POST /payment_forms
  #
  # Creates a new payment form.
  def create
    flash[:notice] = 'The payment form was successfully created.' if payment_form.save
    respond_with(payment_form)
  end

  # GET /payment_forms/:id/edit
  #
  # Displays the form used to edit a payment form.
  def edit
    respond_with(payment_form)
  end

  # PUT /payment_forms/:id
  #
  # Updates a payment form.
  def update
    flash[:notice] = 'The payment form was successfully updated.' if payment_form.update_attributes(params[:payment_form])
    respond_with(payment_form)
  end
  
end
