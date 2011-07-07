# encoding: utf-8
#

# Ledger transactions define a transaction within the financial ledger.
class LedgerTransaction

  # Ledger transactions are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps

  # Enable model sequence support for ledger transactions.
  include Mongoid::ModelSequenceSupport

  # Define the fields for the ledger transaction.
  field :transacted_on, type: Date
  field :description, type: String
  field :locked, type: Boolean, default: false

  # Ledger transactions are associated with instances.
  belongs_to :instance

  # Ledger transactions can have one or more lines embedded, and make the lines
  # assignable through mass assignment.
  embeds_many :lines, class_name: 'LedgerTransactionLine'
  accepts_nested_attributes_for :lines, allow_destroy: true
  attr_accessible :lines_attributes
  
  # Ledger transactions can have one or more attachments embedded, and make the
  # attachments assignable through mass assignment.
  embeds_many :attachments, class_name: 'LedgerTransactionAttachment', cascade_callbacks: true
  accepts_nested_attributes_for :attachments, allow_destroy: true
  attr_accessible :attachments_attributes
  
  # Embed a collection of model sequences containing sequence details for each
  # data type for the ledger transaction.
  embeds_many(:model_sequences, as: :sequenceable) do
    def line; for_model_class(LedgerTransactionLine); end
    def attachment; for_model_class(LedgerTransactionAttachment); end

    def for_model_class(model_class)
      @target.select { |seq| seq.model_class == model_class.name }.first
    end
  end

  # Validate that the ledger transaction is associated with an instance.
  validates :instance, presence: true

  # Validate that the transacted on date is set, and make the transacted_on
  # attribute assignable through mass assignment.
  validates :transacted_on, presence: true
  attr_accessible :transacted_on

  # Validate that the description is set, and make the description attribute
  # assignable through mass assignment.
  validates :description, presence: true
  attr_accessible :description

  # Validate that there's at least one line on the transaction.
  validates :lines, presence: true

  # Validate that the ledger transaction is balanced.
  validate :validate_transaction_balance

  # When instantiating a ledger transaction, build the associated model
  # sequences as well.
  after_initialize :build_model_sequences

  # Before updating a ledger transaction, capture the original transaction so we
  # can perform a rollback in the after save callback.
  before_update :capture_original_transaction

  # After saving a ledger transaction, update the balance on all accounts
  # involved.
  after_save :update_account_balances

  # Sort transactions by their identifier.
  scope :sorted_by_identifier, order_by(:identifier.desc)

  # Returns the net amount for this transaction (total debit amount)
  def net_amount; debit; end

  # Returns the total debit amount for this transaction
  def debit
    self.lines.select { |l| !l.debit.blank? }.collect(&:debit).sum
  end

  # Returns the total credit amount for this transaction
  def credit
    self.lines.select { |l| !l.credit.blank? }.collect(&:credit).sum
  end

  # Returns the balance difference for this transaction
  def difference
    debit - credit
  end

  # Checks if the transaction is locked.
  #
  # @return [ TrueClass, FalseClass ] True if the transaction is locked, false
  #   otherwise.
  def locked?
    locked
  end

  # Adjust the balance on all accounts involved with this ledger transaction.
  #
  # CAUTION: This is called from the post-save callback and should never be
  # called directly.
  def adjust_balance!
    lines.each do |line|

      balance_update = line.debit? ? line.debit : line.credit * -1
      line.account.update_balance!(balance_update)

      # If this account has a tax code associated with it, calculate the taxable
      # amount and update the balance on the tax account.
      if line.account.taxable?
        tax_balance_update = (balance_update / 100) * line.account.tax_code.percentage
        line.account.tax_code.target_account.update_balance!(tax_balance_update)
      end

    end
  end

  # Roll back the balance changes made by this ledger transaction.
  # This is called from the account balance observer and must never be called
  # manually, or it will screw up the balances.
  def rollback_balance!
    lines.each do |line|

      balance_update = line.debit? ? line.debit * -1 : line.credit
      line.account.update_balance!(balance_update)

      # If this account has a tax code associated with it, calculate the taxable
      # amount and update the balance on the tax account.
      if line.account.taxable?
        tax_balance_update = (balance_update / 100) * line.account.tax_code.percentage
        line.account.tax_code.target_account.update_balance!(tax_balance_update)
      end
      
    end
  end

  private

  # Build the embedded model sequences for the instance.
  def build_model_sequences
    [LedgerTransactionLine, LedgerTransactionAttachment].each do |model_class|

      model_class_name = model_class.name
      if model_sequences.select { |ms| ms.model_class == model_class_name }.empty?
        sequence = ModelSequence.new
        sequence.model_class = model_class_name
        model_sequences << sequence
      end

    end
  end
  
  # Validate that the balance of this transaction is exactly 0
  def validate_transaction_balance
    errors.add(:lines, 'Balance difference must be 0') if self.difference != 0.0
  end

  # Capture the original transaction, if any, so we can perform a proper
  # rollback in the update_account_balances callback.
  def capture_original_transaction
    @original_transaction = if new_record? then
                              nil
                            else
                              LedgerTransaction.find(id.to_s).freeze
                            end
  end

  # Update the balance of all accounts involved with this transaction.
  def update_account_balances

    # If we have an original transaction defined, roll that one back so we can
    # blindly update the balances below.
    @original_transaction.rollback_balance! if @original_transaction

    # Adjust the balances of the accounts based on the current transaction data.
    adjust_balance!

  end

  # When assigning identifier, also assign identifier on all lines and
  # attachments in this transaction.
  def assign_identifier
    lines.each { |l| l.send(:assign_identifier) }
    attachments.each { |a| a.send(:assign_identifier) }
    super
  end
  
end
