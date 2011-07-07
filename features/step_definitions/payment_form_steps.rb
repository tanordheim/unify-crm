Given /^I have (\d+) payment forms? for that account$/ do |number_of_payment_forms|
  number_of_payment_forms.to_i.times do
    Fabricate(:payment_form, instance: Instance.first, account: Account.first)
  end
end

Given /^I go to the payment forms page$/ do
  visit '/payment_forms'
end

Then /^I should see (\d+) payment forms?$/ do |number_of_payment_forms|
  page.find('table.payment-forms tbody').all('tr').length.should == number_of_payment_forms.to_i
end

Then /^I should be on the payment forms page$/ do
  page.current_path.should == '/payment_forms'
end

Given /^I edit the first payment form$/ do
  page.find(:css, 'table.payment-forms tbody tr:first').find('a.edit-action').click
end
