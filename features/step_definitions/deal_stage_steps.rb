When /^I go to the deal stages page$/ do
  visit '/deal_stages'
end

When /^I should see the deal stage "([^"]*)"$/ do |name|
  page.find('table.deal-stages tbody tr td', text: name)
end

Given /^I have the deal stage "([^"]*)"$/ do |name|
  Fabricate(:deal_stage, instance: Instance.first, name: name)
end

Given /^I have the deal stage "([^"]*)" with the percentage (\d+)$/ do |name, percentage|
  Fabricate(:deal_stage, instance: Instance.first, name: name, percent: percentage.to_i)
end

Given /^I have (\d+) deal stages?$/ do |number_of_stages|
  number_of_stages.to_i.times do
    Fabricate(:deal_stage, instance: Instance.first)
  end
end

Then /^I should see (\d+) deal stages?$/ do |number_of_stages|
  page.find('table.deal-stages tbody').all('tr').length.should == number_of_stages.to_i
end

When /^I delete the first deal stage$/ do
  handle_js_confirm do
    page.find(:css, 'table.deal-stages tbody tr:first').find('a.delete-action').click
  end
end

When /^I edit the first deal stage$/ do
  page.find(:css, 'table.deal-stages tbody tr:first').find('a.edit-action').click
end
