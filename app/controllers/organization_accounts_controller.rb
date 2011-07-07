# encoding: utf-8
#

# Manages the organization accounts for a Unify instance.
class OrganizationAccountsController < ApplicationController

  respond_to :html
  expose(:accounts) { current_instance.accounts.organization_accounts.sorted_by_number }

  set_navigation_section :accounting

  # GET /organization_accounts
  #
  # Displays a list of all available organization accounts.
  def index
    respond_with(accounts)
  end
  
end
