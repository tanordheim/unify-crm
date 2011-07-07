Given /^I have (\d+) (\w+) (category|categories)$/ do |number_of_categories, class_name, _|
  number_of_categories.to_i.times do
    Fabricate("#{class_name}_category".to_sym, instance: Instance.first)
  end
end

Given /^I have the (\w+) category "([^"]*)"$/ do |class_name, name|
  Fabricate("#{class_name}_category".to_sym, instance: Instance.first, name: name)
end

Then /^I should see (\d+) (\w+) (category|categories)$/ do |number_of_categories, class_name, _|
  page.find('table.categories tbody').all('tr').length.should == number_of_categories.to_i
end

When /^I should see the (\w+) category "([^"]*)"$/ do |class_name, name|
  page.find('table.categories tbody tr td', text: name)
end

When /^I edit the first \w+ category$/ do
  page.find(:css, 'table.categories tbody tr:first').find('a.edit-action').click
end

When /^I delete the first \w+ category$/ do
  handle_js_confirm do
    page.find(:css, 'table.categories tbody tr:first').find('a.delete-action').click
  end
end
