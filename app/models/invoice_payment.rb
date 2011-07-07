# encoding: utf-8
#

# Defines a payment on an invoice.
class InvoicePayment

  # Invoice payments are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the invoice payment.
  field :amount, type: Float
  field :paid_on, type: Date

  # Invoice payments are embedded within invoices.
  embedded_in :invoice, inverse_of: :payments

  # Invoice payments are associated with payment forms.
  belongs_to :payment_form

  # Validate that the payment has a payment form associated with it, and make
  # the payment form attributes assignable through mass assignment.
  validates :payment_form, presence: true
  attr_accessible :payment_form, :payment_form_id

  # Validate that the payment has an amount set, and make the amount attribute
  # assignable through mass assignment.
  validates :amount, presence: true
  attr_accessible :amount

  # Validate that the payment has a paid on-date set, and make the paid_on
  # attribute assignable through mass assignment.
  validates :paid_on, presence: true
  attr_accessible :paid_on

  # After creating a payment, create a ledger transaction for it.
  after_create :generate_ledger_transaction

  # After creating a payment, set the status of the associated invoice.
  after_create :set_invoice_payment_status

  private

  # Generate a ledger transaction for this payment if its a new record.
  def generate_ledger_transaction

    is_new = _id_changed?
    if is_new

      transaction_label = I18n.t('ledger_transactions.auto_generated.payment', payment_form: payment_form.name, invoice_identifier: invoice.identifier, organization_identifier: invoice.organization.identifier)
      transaction = invoice.instance.ledger_transactions.build(transacted_on: paid_on, description: transaction_label)
      transaction.locked = true

      # Add debit for this transaction
      transaction.lines.build(account: payment_form.account, description: transaction_label, debit: amount)

      # Add a credit for this transaction
      transaction.lines.build(account: invoice.organization.organization_account, description: transaction_label, credit: amount)
      
      transaction.save!
    
    end
    
  end

  # Set the payment status of the associated invoice after persisting a new
  # invoice payment.
  def set_invoice_payment_status

    invoice_cost = invoice.total_cost
    paid_amount = invoice.paid_amount

    if paid_amount >= invoice_cost
      invoice.paid!
    else
      invoice.partially_paid!
    end

  end

end
