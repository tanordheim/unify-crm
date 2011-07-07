# encoding: utf-8
#

# Manages the accounts for a Unify instance.
class AccountsController < ApplicationController

  respond_to :html, :js
  expose(:accounts) { current_instance.accounts.without_organization_accounts.sorted_by_number }
  expose(:account) do
    if params[:id].blank?
      current_instance.accounts.build(params[:account])
    else
      current_instance.accounts.without_organization_accounts.find(params[:id])
    end
  end

  expose(:tax_codes) { current_instance.tax_codes.sorted_by_code }

  set_navigation_section :accounting

  # GET /accounts
  #
  # Displays a list of all available accounts.
  def index
    respond_with(accounts)
  end

  # GET /accounts/new
  #
  # Displays the form used to create a new account.
  def new
    respond_with(account)
  end

  # POST /accounts
  #
  # Creates a new account.
  def create
    flash[:notice] = 'The account was successfully created.' if account.save
    respond_with(account)
  end

  # GET /accounts/:id/edit
  #
  # Displays the form used to edit an account.
  def edit
    respond_with(account)
  end

  # PUT /accounts/:id
  #
  # Updates an account.
  def update
    flash[:notice] = 'The account was successfully updated.' if account.update_attributes(params[:account])
    respond_with(account)
  end

end
