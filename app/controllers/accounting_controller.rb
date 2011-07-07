# encoding: utf-8
#

# Manages the accounting dashboard for a Unify instance.
class AccountingController < ApplicationController

  respond_to :html

  set_navigation_section :accounting

  # GET /accounting
  #
  # Displays the accounting dashboard.
  def index
  end

end
