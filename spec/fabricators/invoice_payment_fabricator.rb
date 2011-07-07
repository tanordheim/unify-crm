# encoding: utf-8
#

Fabricator(:invoice_payment) do
  invoice!
  payment_form!
  amount { 100.0 * rand(1..5) }
  paid_on { Date.today }
end
