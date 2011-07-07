# encoding: utf-8
#

# Ledger transaction lines defines a single line witihin a ledger transaction.
class LedgerTransactionLine

  # Ledger transaction lines are Mongoid documents.
  include Mongoid::Document

  # Enable model sequence support for ledger transaction lines.
  include Mongoid::ModelSequenceSupport

  # Define the fields for the ledger transaction line.
  field :description, type: String
  field :debit, type: Float
  field :credit, type: Float

  # Ledger transaction lines are embedded in ledger transactions.
  embedded_in :ledger_transaction, inverse_of: :lines

  # Ledger transaction lines are associated with accounts.
  belongs_to :account

  # Validate that the transaction line is associated with an account, and make
  # the account attributes assignable through mass assignment.
  validates :account, presence: true
  attr_accessible :account, :account_id

  # Validate that the transaction line has a description set, and make the
  # description attribute assignable through mass assignment.
  validates :description, presence: true
  attr_accessible :description

  # Validate that the debit field is set, unless the credit field is already
  # set. Also, allow the debit field to be assigned via mass assignment.
  validates :debit, presence: { unless: :credit? }
  attr_accessible :debit

  # Validate that the credit field is set, unless the debit field is already
  # set. Also, allow the credit field to be assigned via mass assignment.
  validates :credit, presence: { unless: :debit? }
  attr_accessible :credit

  # Nullify any zero values in debit/credit before validating the line.
  before_validation :nullify_zero_values

  # Only allow either the debit or credit field to have a value, not both.
  before_validation :only_allow_debit_or_credit

  # Checks if this line is a debit line.
  #
  # @return [ TrueClass, FalseClass ] True if this is a debit line, false
  #   otherwise.
  def debit?
    !self.debit.blank?
  end

  # Checks if this line is a credit line.
  #
  # @return [ TrueClass, FalseClass ] True if this is a credit line, false
  #   otherwise.
  def credit?
    !self.credit.blank?
  end

  private

  # Nullify the debit and/or credit value if the current value is 0.
  def nullify_zero_values
    %w(debit credit).each do |attribute_name|
      value = send(attribute_name.to_sym)
      if !value.nil? && value == 0.0
        send(:"#{attribute_name}=", nil)
      end
    end
    true
  end
  
  # Only allow the debit or credit value to be populated, not both. If we have
  # both values, nullify the debit field.
  def only_allow_debit_or_credit
    self.debit = nil if !debit.blank? && !credit.blank?
    true
  end

  # Returns the parent model holding the identifier sequences to use when
  # generating the sequence for this class.
  #
  # @return [ LedgerTransaction ] The instance of the parent model holding
  #   identifier sequences used to generating the sequence for this class.
  def identifier_parent
    ledger_transaction
  end
  
end
