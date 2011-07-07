# encoding: utf-8
#

# Frozen invoice data instances hold captured data from invoice associations
# from the time of invoice generation so that organizations and projects that
# have invoices can be changed without historical data on invoices becoming
# incorrect.
class FrozenInvoiceData

  # Frozen invoice data are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the frozen invoice data.
  field :biller_name, type: String
  field :biller_street_name, type: String
  field :biller_zip_code, type: String
  field :biller_city, type: String
  field :biller_vat_number, type: String
  field :biller_bank_account_number, type: String
  field :organization_name, type: String
  field :organization_identifier, type: Integer
  field :organization_street_name, type: String
  field :organization_zip_code, type: String
  field :organization_city, type: String
  field :project_name, type: String
  field :project_identifier, type: Integer
  field :project_key, type: String

  # Frozen invoice data are embedded within invoices.
  embedded_in :invoice, inverse_of: :frozen_data

end
