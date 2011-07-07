Given /^I have (\d+) products? for that account$/ do |number_of_products|
  number_of_products.to_i.times do
    Fabricate(:product, instance: Instance.first, account: Account.first)
  end
end

Given /^I go to the products page$/ do
  visit '/products'
end

Then /^I should see (\d+) products?$/ do |number_of_products|
  page.find('table.products tbody').all('tr').length.should == number_of_products.to_i
end

Then /^I should be on the products page$/ do
  page.current_path.should == '/products'
end

Given /^I edit the first product/ do
  page.find(:css, 'table.products tbody tr:first').find('a.edit-action').click
end

Given /^I have the product "([^"]*)" for that account$/ do |name|
  Fabricate(:product, instance: Instance.first, account: Account.first, name: name)
end
