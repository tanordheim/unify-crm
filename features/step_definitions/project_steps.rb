Given /^I have (\d+) projects?$/ do |number_of_projects|
  number_of_projects.to_i.times do
    organization = Fabricate(:organization, instance: Instance.first)
    category = Fabricate(:project_category, instance: Instance.first)
    Fabricate(:project, instance: Instance.first, organization: organization, category: category)
  end
end

Given /^I go to the projects page$/ do
  visit '/projects'
end

Then /^I should see (\d+) projects?$/ do |number_of_projects|
  page.find('table.projects tbody').all('tr').length.should == number_of_projects.to_i
end

Given /^I have the project "([^"]*)"$/ do |name|
  organization = Fabricate(:organization, instance: Instance.first)
  category = Fabricate(:project_category, instance: Instance.first)
  Fabricate(:project, instance: Instance.first, organization: organization, category: category, name: name)
end

Given /^I have the project "([^"]*)" with the key "([^"]*)"$/ do |name, key|
  organization = Fabricate(:organization, instance: Instance.first)
  category = Fabricate(:project_category, instance: Instance.first)
  Fabricate(:project, instance: Instance.first, organization: organization, category: category, name: name, key: key)
end

Given /^I go to the page for (that|the) project$/ do |_|
  visit "/projects/#{Project.first.id}"
end

Then /^I should be on the page for that project$/ do
  page.current_path.should =~ /^\/projects\/[a-f0-9]+$/
end
