Given /^I have (\d+) ledger transactions?$/ do |number_of_transactions|
  number_of_transactions.to_i.times do
    account = Fabricate(:account, instance: Instance.first)
    transaction = Fabricate.build(:ledger_transaction, instance: Instance.first, lines: [])
    transaction.lines = [
      Fabricate.build(:ledger_transaction_line, ledger_transaction: nil, account: account, description: 'Test Transaction', debit: 100),
      Fabricate.build(:ledger_transaction_line, ledger_transaction: nil, account: account, description: 'Test Transaction', credit: 100)
    ]
    transaction.save!
  end
end

Given /^I go to the ledger transactions page$/ do
  visit '/ledger_transactions'
end

Then /^I should see (\d+) ledger transactions?$/ do |number_of_transactions|
  page.find('table.ledger-transactions tbody').all('tr').length.should == number_of_transactions.to_i
end

When /^I add a ledger transaction line for "([^"]*)" with description "([^"]*)" and (debit|credit) (\d+)$/ do |account, description, debit_or_credit, amount|

  # Click the correct "add" link.
  if page.all('.ledger-transaction-lines .add-first', visible: true).length > 0
    page.find('.ledger-transaction-lines .add-first a').click
  else
    page.find('.ledger-transaction-lines .add-another a').click
  end

  within(:css, '.ledger-transaction-lines-form tbody tr:last') do

    select(account, from: 'Account')
    fill_in('Description', with: description)

    if debit_or_credit == 'debit'
      fill_in('Debit', with: amount)
    else
      fill_in('Credit', with: amount)
    end

  end

end

Then /^I should be on the page for that ledger transaction$/ do
  page.current_path.should =~ /^\/ledger_transactions\/[a-f0-9]+$/
end

Given /^I go to the page for that ledger transaction$/ do
  visit "/ledger_transactions/#{LedgerTransaction.first.id}"
end
