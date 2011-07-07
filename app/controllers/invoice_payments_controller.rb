# encoding: utf-8
#

# Manages payments for an invoice.
class InvoicePaymentsController < ApplicationController

  respond_to :js

  expose(:invoice) { current_instance.invoices.find(params[:invoice_id]) }
  expose(:payment) { invoice.payments.build(params[:invoice_payment]) }

  expose(:payment_forms) { current_instance.payment_forms.sorted_by_name }

  # GET /invoices/:invoice_id/payments/new
  #
  # Displays the form used to register a new payment on an invoice.
  def new
    respond_with(payment)
  end

  # POST /invoices/:invoice_id/payments
  #
  # Registers a new payment on an invoice.
  def create
    flash[:notice] = 'The invoice payment was successfully registered.' if payment.save
    Rails.logger.debug("ERRORS: #{payment.errors.inspect}")
    respond_with(payment)
  end

end
