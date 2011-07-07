module InvoiceHelper

  # Returns the state of an invoice.
  # 
  # @param [ Invoice ] The invoice to return the state for.
  #
  # @return [ String ] The formatted state of the invoice.
  def invoice_state(invoice)
    t("invoices.state.#{invoice.state_name}")
  end

end
