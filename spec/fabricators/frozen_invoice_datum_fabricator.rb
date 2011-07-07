# encoding: utf-8
#

Fabricator(:frozen_invoice_data, class: 'FrozenInvoiceData') do
  invoice!
  biller_name { Faker::Company.name }
end
