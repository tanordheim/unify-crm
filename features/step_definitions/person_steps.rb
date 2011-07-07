Then /^I should be on the page for that person/ do
  page.current_path.should =~ /^\/people\/[a-f0-9]+$/
end

Given /^I have the person "([^"]*)"$/ do |name|
  first, last = name.split(' ', 2)
  Fabricate(:person, first_name: first, last_name: last, instance: Instance.first)
end

Given /^I go to the page for (that|the) person/ do |_|
  visit "/people/#{Person.first.id}"
end

Then /^I should see (\d+) (person|people)/ do |number_of_people, _|
  page.find(:css, '.contacts-table').all('tr.person').length.should == number_of_people.to_i
end
