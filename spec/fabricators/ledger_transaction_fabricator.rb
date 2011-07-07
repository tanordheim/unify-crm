# encoding: utf-8
#

Fabricator(:ledger_transaction) do
  instance!
  transacted_on { Date.today - rand(1..30).days }
  description { Faker::Lorem.sentence }
  lines do |transaction|
    [
      Fabricate.build(:ledger_transaction_line, ledger_transaction: nil, debit: 10000.00, credit: nil),
      Fabricate.build(:ledger_transaction_line, ledger_transaction: nil, debit: nil, credit: 10000.00)
    ]
  end
end
