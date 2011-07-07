# encoding: utf-8
#

# Accounts defines an account used to track income and expenses within a
# financial budget.
class Account

  TYPES = {
    '0' => :balance,
    '10' => :income,
    '20' => :expense,
    '30' => :activa,
    '40' => :passiva
  }

  # Accounts are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the account.
  field :number, type: Integer
  field :name, type: String
  field :type, type: Integer
  field :balance, type: Float, default: 0.0

  # Accounts are associated with instances.
  belongs_to :instance

  # Accounts are asociated with tax codes.
  belongs_to :tax_code, inverse_of: :target_account

  # Accounts can be associated with products.
  has_many :products
  
  # Validate that the account is associatd with an instance.
  validates :instance, presence: true

  # Validate that the account has a number set, and that its unique within this
  # instance. Also, make the number attribute assignable through mass
  # assignment.
  validates :number, presence: true, uniqueness: { scope: :instance_id }
  attr_accessible :number

  # Validate that the account has a name set, and make the name attribute
  # assignable through mass assignment.
  validates :name, presence: true
  attr_accessible :name

  # Validate that the account has a type defined, and that it's a valid type.
  # Also, make the type attribute assignable through mass assignment.
  validates :type, presence: true, inclusion: { in: TYPES.keys.map(&:to_i) }
  attr_accessible :type

  # Make the tax code attributes assignable through mass assignment.
  attr_accessible :tax_code, :tax_code_id

  # Exclude organization accounts from the list of accounts.
  scope :without_organization_accounts, where(:_type.ne => 'OrganizationAccount')

  # Include only organization accounts from the list of accounts.
  scope :organization_accounts, where(_type: 'OrganizationAccount')

  # Sort accounts by the account number.
  scope :sorted_by_number, order_by(:number.asc)
  
  # Returns the name of the type associated with this account.
  #
  # @return [ Symbol ] A name identifying the type code for this account.
  def type_name
    TYPES[type.to_s]
  end
  
  # Update the balance of this account.
  def update_balance!(amount)
    inc(:balance, amount)
  end

  # Checks if this account is taxable (has a tax code associated with it).
  #
  # @return [ TrueClass, FalseClass ] True if the account is taxable, false
  #   otherwise.
  def taxable?
    !tax_code.blank?
  end

end
