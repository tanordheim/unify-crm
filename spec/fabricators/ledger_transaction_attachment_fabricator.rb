# encoding: utf-8
#

Fabricator(:ledger_transaction_attachment) do
  ledger_transaction { Fabricate.build(:ledger_transaction, lines: []) }
  attachment { upload_file('test.txt', 'text/plain') }
end
