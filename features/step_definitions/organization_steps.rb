Then /^I should be on the page for that organization$/ do
  page.current_path.should =~ /^\/organizations\/[a-f0-9]+$/
end

Given /^I have the organization "([^"]*)"$/ do |name|
  Fabricate(:organization, name: name, instance: Instance.first)
end

Given /^I go to the page for (that|the) organization$/ do |_|
  visit "/organizations/#{Organization.first.id}"
end

Then /^I should see (\d+) organizations?$/ do |number_of_organizations|
  page.find(:css, '.contacts-table').all('tr.organization').length.should == number_of_organizations.to_i
end

When /^I send an API request for that organization$/ do
  step %{I send an API request to "/organizations/#{Organization.first.id}"}
end

Then /^I should see the background information "([^"]*)"$/ do |text|
  within(:css, '.entity-header .background') do
    page.should have_content(text)
  end
end
