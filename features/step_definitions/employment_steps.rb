Given /^I have (\d+) employments? for (that|the) person$/ do |number_of_employments, _|
  person = Person.first
  instance = Instance.first
  number_of_employments.to_i.times do
    organization = Fabricate(:organization, instance: instance)
    Fabricate(:employment, person: person, organization: organization)
  end
end

Then /^I should see (\d+) employments?$/ do |number_of_employments|
  page.find(:css, 'ul.employments').all(:css, 'li[data-employment-id]').length.should == number_of_employments.to_i
end

When /^I save the employment$/ do
  page.find(:css, 'ul.employments').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

When /^I delete the first employment$/ do

  page.execute_script <<-JS
    var employmentRow = $('li[data-employment-id]:first');
    var deleteLink = $('a.inline-remove', employmentRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end

Then /^I should see (\d+) employees?$/ do |number_of_employees|
  page.find(:css, 'table.employees-table').all('tr[data-employment-id]').length.should == number_of_employees.to_i
end

When /^I save the employee$/ do
  page.find(:css, 'table.employees-table').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) employees? for (that|the) organization$/ do |number_of_employees, _|
  organization = Organization.first
  instance = Instance.first
  number_of_employees.to_i.times do
    person = Fabricate(:person, instance: instance)
    Fabricate(:employment, person: person, organization: organization)
  end
end

When /^I delete the first employee$/ do
  page.find(:css, 'table.employees-table tr[data-employment-id]:first td.remove a').click
  sleep 1
end

# Then /^I should see (\d+) employees?$/ do |number_of_employees|
#   page.find(:css, '.tab-pane.employees-tab table tbody').all('tr').length.should == number_of_employees.to_i
# end

# Given /^I have the employee "([^"]*)" with the title "([^"]*)" for that organization$/ do |name, title|
#   step %{I have the person "#{name}"}
#   Fabricate(:employment, person: Person.first, organization: Organization.first, title: title)
# end
# 
# Given /^I have an employment in "([^"]*)" with the title "([^"]*)" for that person$/ do |name, title|
#   step %{I have the organization "#{name}"}
#   Fabricate(:employment, person: Person.first, organization: Organization.first, title: title)
# end
# 
# Then /^I should see the following employees?:$/ do |expected_table|
#   table = page.find(:css, '.tab-pane.employees-tab table').all('tbody tr').map do |row|
#     row.all('td:nth-child(1), td:nth-child(2)').map do |cell|
#       cell.text.strip
#     end
#   end
#   expected_table.diff!(table)
# end
# 
# Then /^I should see the following employments?:$/ do |expected_table|
#   table = page.find(:css, '.tab-pane.employments-tab table').all('tbody tr').map do |row|
#     row.all('td:nth-child(1), td:nth-child(2)').map do |cell|
#       cell.text.strip
#     end
#   end
#   expected_table.diff!(table)
# end
# 
# When /^I edit the first employee$/ do
#   page.find(:css, '.tab-pane.employees-tab table tbody tr:first').find('a.edit-action').click
# end
# 
# When /^I edit the first employment$/ do
#   page.find(:css, '.tab-pane.employments-tab table tbody tr:first').find('a.edit-action').click
# end
# 
# When /^I delete the first employee$/ do
#   handle_js_confirm do
#     page.find(:css, '.tab-pane.employees-tab table tbody tr:first').find('a.delete-action').click
#   end
# end
# 
# When /^I delete the first employment$/ do
#   handle_js_confirm do
#     page.find(:css, '.tab-pane.employments-tab table tbody tr:first').find('a.delete-action').click
#   end
# end
