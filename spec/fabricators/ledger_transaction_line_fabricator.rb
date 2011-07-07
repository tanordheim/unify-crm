# encoding: utf-8
#

Fabricator(:ledger_transaction_line) do
  ledger_transaction { Fabricate.build(:ledger_transaction, lines: []) }
  account!
  description { Faker::Lorem.sentence }
  debit { 10000.00 }
end
