# encoding: utf-8
#

# Manages the ledger transactions for a Unify instance.
class LedgerTransactionsController < ApplicationController

  respond_to :html, :js

  expose(:transactions) { current_instance.ledger_transactions.sorted_by_identifier.page(params[:page]).per(15) }
  expose(:transaction) do
    if params[:id].blank?
      current_instance.ledger_transactions.build(params[:ledger_transaction])
    else
      current_instance.ledger_transactions.find(params[:id])
    end
  end

  expose(:accounts) { current_instance.accounts.sorted_by_number }
  
  set_navigation_section :accounting

  # GET /ledger_transactions
  #
  # Displays a list of all available ledger transactions.
  def index
    respond_with(transactions)
  end

  # GET /ledger_transactions/:id
  #
  # Displays information about a ledger transaction.
  def show
    respond_with(transaction)
  end

  # GET /ledger_transactions/new
  #
  # Displays the form used to create a new ledger transaction.
  def new
    respond_with(transaction)
  end

  # POST /ledger_transactions
  #
  # Creates a new ledger transaction.
  def create
    flash[:notice] = 'The ledger transaction was successfully created.' if transaction.save
    respond_with(transaction)
  end

  # GET /ledger_transactions/:id/edit
  #
  # Displays the form used to edit a ledger transaction.
  def edit
    respond_with(transaction)
  end

  # PUT /ledger_transactions/:id
  #
  # Updates a ledger transaction.
  def update
    flash[:notice] = 'The ledger transaction was successfully updated.' if transaction.update_attributes(params[:ledger_transaction])
    respond_with(transaction)
  end
  
end
