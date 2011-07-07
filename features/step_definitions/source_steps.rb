Then /^I should see the source "([^"]*)"$/ do |name|
  within(:css, '.source .best_in_place') do
    page.should have_content(name)
  end
end

Given /^I have the source "([^"]*)"$/ do |name|
  Fabricate(:source, instance: Instance.first, name: name)
end

# When /^I go to the sources page$/ do
#   visit '/sources'
# end
# 
# Then /^I should see the source "([^"]*)"$/ do |name|
#   page.find('table.sources tbody tr td', text: name)
# end
# 
# Given /^I have (\d+) sources?$/ do |number_of_sources|
#   number_of_sources.to_i.times do
#     Fabricate(:source, instance: Instance.first)
#   end
# end
# 
# 
# Then /^I should see (\d+) sources?$/ do |number_of_sources|
#   page.find('table.sources tbody').all('tr').length.should == number_of_sources.to_i
# end
# 
# When /^I delete the first source$/ do
#   handle_js_confirm do
#     page.find(:css, 'table.sources tbody tr:first').find('a.delete-action').click
#   end
# end
# 
# Given /^I edit the first source$/ do
#   page.find(:css, 'table.sources tbody tr:first').find('a.edit-action').click
# end
