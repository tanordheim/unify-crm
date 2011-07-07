# encoding: utf-8
#

# Invoices defines a bill/invoice sent to a client.
class Invoice

  STATES = {
    '0' => :draft,
    '10' => :unpaid,
    '20' => :partially_paid,
    '30' => :paid
  }

  # Invoices are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Enable model sequence support for invoices.
  include Mongoid::ModelSequenceSupport

  # Add filtering support to invoices.
  include FilteredResult::Model
  
  # Define the fields for the invoice.
  field :state, type: Integer, default: 0
  field :billed_on, type: Date
  field :due_on, type: Date
  field :description, type: String
  field :biller_reference, type: String
  field :organization_reference, type: String
  field :net_cost, type: Float, default: 0.0
  field :taxable_amount, type: Float, default: 0.0
  field :tax_cost, type: Float, default: 0.0
  field :total_cost, type: Float, default: 0.0

  # Invoices are associated with instances.
  belongs_to :instance

  # Invoices are associated with organizations.
  belongs_to :organization

  # Invoices can be associated with projects.
  belongs_to :project

  # Invoices embeds a frozen invoice data set where biller, organization and
  # project data is frozen whenever an invoice is generated to keep the invoice
  # historically correct even if the associated data (organizations and
  # projects) change.
  embeds_one :frozen_data, class_name: 'FrozenInvoiceData'

  # Invoices can have one or more lines embedded, and make the lines assignable
  # through mass assignment.
  embeds_many :lines, class_name: 'InvoiceLine'
  accepts_nested_attributes_for :lines, allow_destroy: true
  attr_accessible :lines_attributes

  # Invoices embeds payments describing a full or partial incoming paymenet on
  # an invoice.
  embeds_many :payments, class_name: 'InvoicePayment'
  
  # Validate that the invoice is associated with an instance.
  validates :instance, presence: true

  # Validate that the invoice is associated with an organization, and make the
  # organization attributes assignable through mass assignment.
  validates :organization, presence: true
  attr_accessible :organization, :organization_id

  # Make the project attributes assignable through mass assignment.
  attr_accessible :project, :project_id

  # Validate that the invoice has a state defined, and that it's a valid state.
  # Also, make the state attribute assignable through mass assignment.
  validates :state, presence: true, inclusion: { in: STATES.keys.map(&:to_i) }
  attr_accessible :state

  # Validate that the billed on date is set, and make the billed_on attriute
  # assignable through mass assignment.
  validates :billed_on, presence: true
  attr_accessible :billed_on
  
  # Validate that the due on date is set, and make the due_on attriute
  # assignable through mass assignment.
  validates :due_on, presence: true
  attr_accessible :due_on

  # Make the description attribute assignable through mass assignment.
  attr_accessible :description
  
  # Make the biller_reference attribute assignable through mass assignment.
  attr_accessible :biller_reference
  
  # Make the organization_reference attribute assignable through mass
  # assignment.
  attr_accessible :organization_reference

  # When instantiating an invoice, build the associated frozen data as well.
  after_initialize :build_embedded_frozen_data

  # Calculate the actual costs of this invoice before saving it.
  before_save :calculate_costs

  # After generating an invoice, create a ledger transaction for it.
  after_save :generate_ledger_transaction

  # Sort invoices by their due date.
  scope :sorted_by_due_date, order_by(:due_on.desc)

  # Returns the name of the state associated with this invoice.
  #
  # @return [ Symbol ] A name identifying the state code for this invoice.
  def state_name
    STATES[state.to_s]
  end

  # Checks if the current invoice is a draft.
  #
  # @return [ TrueClass, FalseClass ] True if the current invoice is a draft,
  #   false otherwise.
  def draft?
    state_name == :draft
  end

  # Checks if the current invoice is generated.
  #
  # @return [ TrueClass, FalseClass ] True if the current invoice is generated,
  #   false otherwise.
  def generated?
    !draft?
  end
  
  # Checks if the current invoice is unpaid.
  #
  # @return [ TrueClass, FalseClass ] True if the current invoice is unpaid,
  #   false otherwise.
  def unpaid?
    state_name == :unpaid
  end

  # Checks if the current invoice is partially paid.
  #
  # @return [ TrueClass, FalseClass ] True if the current invoice is partially
  #   paid, false otherwise.
  def partially_paid?
    state_name == :partially_paid
  end

  # Checks if the current invoice is paid.
  #
  # @return [ TrueClass, FalseClass ] True if the current invoice is paid, false
  #   otherwise.
  def paid?
    state_name == :paid
  end

  # Flag the invoice as generated and unpaid
  def generate!
    self.state = STATES.key(:unpaid).to_i
    freeze_data
    self.save!
  end

  # Flags the invoice as partially paid
  def partially_paid!
    self.state = STATES.key(:partially_paid).to_i
    self.save!
  end

  # Flags the invoice as paid
  def paid!
    self.state = STATES.key(:paid).to_i
    self.save!
  end
  
  # Returns the outstanding amount for this invoice
  def outstanding_amount
    total_cost - paid_amount
  end

  # Returns the amount that has been paid for this invoice
  def paid_amount
    payments.collect(&:amount).sum
  end

  # Returns the frozen biller name if the invoice has been generated, the
  # instance company name if its not.
  def biller_name; frozen_value_or_default(:biller_name, instance.organization.name); end

  # Returns the frozen biller street name if the invoice has been generated, the
  # instance street name if its not.
  def biller_street_name; frozen_value_or_default(:biller_street_name, instance.organization.street_name); end
  
  # Returns the frozen biller zip code if the invoice has been generated, the
  # instance zip code if its not.
  def biller_zip_code; frozen_value_or_default(:biller_zip_code, instance.organization.zip_code); end
  
  # Returns the frozen biller city if the invoice has been generated, the
  # instance city if its not.
  def biller_city; frozen_value_or_default(:biller_city, instance.organization.city); end
  
  # Returns the frozen biller vat number if the invoice has been generated, the
  # instance vat number if its not.
  def biller_vat_number; frozen_value_or_default(:biller_vat_number, instance.organization.vat_number); end
  
  # Returns the frozen biller bank account number if the invoice has been
  # generated, the instance bank account number if its not.
  def biller_bank_account_number; frozen_value_or_default(:biller_bank_account_number, instance.organization.bank_account_number); end

  # Returns the frozen organization name if the invoice has been generated, the
  # organization name if its not.
  def organization_name; frozen_value_or_default(:organization_name, organization.name); end
  
  # Returns the frozen organization identtifier if the invoice has been
  # generated, the organization identifier if its not.
  def organization_identifier; frozen_value_or_default(:organization_identifier, organization.identifier); end
  
  # Returns the frozen organization street name if the invoice has been
  # generated, the organization primary address street name if its not.
  def organization_street_name; frozen_value_or_default(:organization_street_name, organization.addresses.primary.blank? ? nil : organization.addresses.primary.street_name); end
  
  # Returns the frozen organization zip code if the invoice has been generated,
  # the organization primary address zip code if its not.
  def organization_zip_code; frozen_value_or_default(:organization_zip_code, organization.addresses.primary.blank? ? nil : organization.addresses.primary.zip_code); end

  # Returns the frozen organization city if the invoice has been generated, the
  # organization primary address zip code if its not.
  def organization_city; frozen_value_or_default(:organization_city, organization.addresses.primary.blank? ? nil : organization.addresses.primary.city); end

  # Returns the frozen project name if the invoice has been generated, the
  # project name if its not.
  def project_name; frozen_value_or_default(:project_name, project.blank? ? nil : project.name); end
  
  # Returns the frozen project identifier if the invoice has been generated, the
  # project identifier if its not.
  def project_identifier; frozen_value_or_default(:project_identifier, project.blank? ? nil : project.identifier); end
  
  # Returns the frozen project key if the invoice has been generated, the
  # project key if its not.
  def project_key; frozen_value_or_default(:project_key, project.blank? ? nil : project.key); end
  
  private

  # Freeze the invoice data into the embedded frozen data object.
  def freeze_data

    # Biller data.
    frozen_data.biller_name = instance.organization.name
    frozen_data.biller_street_name = instance.organization.street_name
    frozen_data.biller_zip_code = instance.organization.zip_code
    frozen_data.biller_city = instance.organization.city
    frozen_data.biller_vat_number = instance.organization.vat_number
    frozen_data.biller_bank_account_number = instance.organization.bank_account_number

    # Organization data.
    frozen_data.organization_name = organization.name
    frozen_data.organization_identifier = organization.identifier
    frozen_data.organization_street_name = organization.addresses.primary.blank? ? nil : organization.addresses.primary.street_name
    frozen_data.organization_zip_code = organization.addresses.primary.blank? ? nil : organization.addresses.primary.zip_code
    frozen_data.organization_city = organization.addresses.primary.blank? ? nil : organization.addresses.primary.city

    # Project data.
    frozen_data.project_name = project.blank? ? nil : project.name
    frozen_data.project_identifier = project.blank? ? nil : project.identifier
    frozen_data.project_key = project.blank? ? nil : project.key

    # Invoice lines.
    lines.each do |line|
      line.frozen_product_key = line.product.key
    end

  end

  # Returns a frozen value from the invoice if it has been generated -
  # otherwise, it returns the default value
  def frozen_value_or_default(frozen_key, default_value)
    generated? ? frozen_data.send(frozen_key) : default_value
  end
  
  # Build the embedded frozen data object for the invoice unless its already
  # set.
  def build_embedded_frozen_data
    build_frozen_data if frozen_data.blank?
  end

  # Calculate the actual costs of this invoice.
  def calculate_costs

    lines.each(&:calculate_costs)    

    self.net_cost = lines.collect(&:net_cost).sum
    self.taxable_amount = lines.select { |l| l.tax_percentage > 0 }.collect(&:net_cost).sum
    self.tax_cost = lines.collect(&:tax_cost).sum
    self.total_cost = lines.collect(&:total_cost).sum

  end

  # Assign an identifier from the model sequence to the invoice if the invoice
  # state is not pending.
  def assign_identifier
    if generated?
      super
    end
    true
  end

  # Generate a ledger transaction for this invoice if it has just gone from
  # draft- to generated-state.
  def generate_ledger_transaction
    if state_changed? && state_was == STATES.key(:draft).to_i && generated?

      transaction_label = I18n.t('ledger_transactions.auto_generated.invoice', invoice_identifier: identifier, organization_identifier: organization.identifier)
      debit_label = I18n.t('ledger_transactions.auto_generated.invoice_debit', :invoice_identifier => identifier)

      transaction = instance.ledger_transactions.build(:transacted_on => Date.today, :description => transaction_label)
      transaction.locked = true

      transaction.lines.build(:account => organization.organization_account, :description => debit_label, :debit => total_cost)

      # Add a credit line for each line on the invoice
      lines.each do |line|
        transaction.lines.build(:account => line.product.account, :description => line.product.name, :credit => line.total_cost)
      end

      transaction.save!

    end
  end
  
end
