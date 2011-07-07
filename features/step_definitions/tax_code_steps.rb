Given /^I have (\d+) tax codes? for that account$/ do |number_of_tax_codes|
  number_of_tax_codes.to_i.times do
    Fabricate(:tax_code, instance: Instance.first, target_account: Account.first)
  end
end

Given /^I go to the tax codes page$/ do
  visit '/tax_codes'
end

Then /^I should see (\d+) tax codes?$/ do |number_of_tax_codes|
  page.find('table.tax-codes tbody').all('tr').length.should == number_of_tax_codes.to_i
end

Then /^I should be on the tax codes page$/ do
  page.current_path.should == '/tax_codes'
end

Given /^I edit the first tax code/ do
  page.find(:css, 'table.tax-codes tbody tr:first').find('a.edit-action').click
end
