# encoding: utf-8
#

# Defines a product line within an invoice.
class InvoiceLine

  # Invoice lines are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the invoice line.
  field :description, type: String
  field :price_per, type: Float
  field :quantity, type: Integer, default: 1
  field :net_cost, type: Float
  field :tax_percentage, type: Integer
  field :tax_cost, type: Float
  field :total_cost, type: Float
  field :frozen_product_key, type: String

  # Invoice lines are embedded within invoices.
  embedded_in :invoice, inverse_of: :lines

  # Invoices are associated with products.
  belongs_to :product

  # Validate that the line is associated with a product, and make the product
  # attributes assignable through mass assignment.
  validates :product, presence: true
  attr_accessible :product, :product_id

  # Validate that the line has a description, and make the description attribute
  # assignable through mass assignment.
  validates :description, presence: true
  attr_accessible :description

  # Validate that the line has a price per product set, and make the price_per
  # attribute assignable through mass assignment.
  validates :price_per, presence: true
  attr_accessible :price_per

  # Validate that the line has a product quantity set, and make the quantity
  # attribute assignable through mass assignment.
  validates :quantity, presence: true
  attr_accessible :quantity

  # Calculate the actual costs of this invoice line before saving it.
  before_save :calculate_costs

  # Calculate the costs for this invoice line.
  def calculate_costs

    find_tax_percentage

    self.net_cost = price_per * quantity
    self.total_cost = (price_per * quantity) * tax_multiplier
    self.tax_cost = total_cost - net_cost

  end

  # Returns the frozen product key of this invoice line if the associated
  # invoice has been generated, the product key if its not.
  def product_key
    invoice.generated? ? frozen_product_key : product.key
  end
  
  private

  # Returns the tax multiplier for this invoice line based on the tax
  # percentage.
  def tax_multiplier
    multiplier = (tax_percentage.to_f / 100) + 1.0
  end

  # Find the tax percentage for this invoice line based on the associated
  # product.
  def find_tax_percentage
    if !product.blank? && !product.account.blank? && product.account.taxable?
      self.tax_percentage = product.account.tax_code.percentage
    else
      self.tax_percentage = 0
    end
  end
  
end
