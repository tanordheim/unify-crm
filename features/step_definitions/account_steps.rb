Given /^I have (\d+) accounts?$/ do |number_of_accounts|
  number_of_accounts.to_i.times do
    Fabricate(:account, instance: Instance.first)
  end
end

Given /^I have the account "([^"]*)" with number "([^"]*)"$/ do |name, number|
  Fabricate(:account, instance: Instance.first, name: name, number: number.to_i)
end

Given /^I go to the accounts page$/ do
  visit '/accounts'
end

Given /^I go to the organization accounts page$/ do
  visit '/organization_accounts'
end

Then /^I should see (\d+) accounts?$/ do |number_of_accounts|
  page.find('table.accounts tbody').all('tr').length.should == number_of_accounts.to_i
end

Then /^I should see (\d+) organization accounts?$/ do |number_of_accounts|
  page.find('table.accounts tbody').all('tr').length.should == number_of_accounts.to_i
end

Then /^I should be on the accounts page$/ do
  page.current_path.should == '/accounts'
end

Given /^I edit the first account$/ do
  page.find(:css, 'table.accounts tbody tr:first').find('a.edit-action').click
end
