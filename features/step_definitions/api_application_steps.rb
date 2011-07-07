Given /^I have (\d+) API applications?$/ do |number_of_applications|
  number_of_applications.to_i.times do
    Fabricate(:api_application, instance: Instance.first)
  end
end

Given /^I go to the API applications page$/ do
  visit '/api_applications'
end

Then /^I should see (\d+) API applications?$/ do |number_of_applications|
  page.find('table.api-applications tbody').all('tr').length.should == number_of_applications.to_i
end

When /^I delete the first API application$/ do
  handle_js_confirm do
    page.find(:css, 'table.api-applications tbody tr:first').find('a.delete-action').click
  end
end

Given /^I edit the first API application$/ do
  page.find(:css, 'table.api-applications tbody tr:first').find('a.edit-action').click
end
