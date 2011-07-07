Given /^I have (\d+) milestones? for that project$/ do |number_of_milestones|
  number_of_milestones.to_i.times do
    Fabricate(:milestone, instance: Instance.first, project: Project.first)
  end
end

Given /^I go to the milestones page for that project$/ do
  visit "/projects/#{Project.first.id}/milestones"
end

Then /^I should see (\d+) milestones?$/ do |number_of_milestones|
  page.find('table.milestones tbody').all('tr').length.should == number_of_milestones.to_i
end

Given /^I have the milestone "([^"]*)" for that project$/ do |name|
  Fabricate(:milestone, instance: Instance.first, project: Project.first, name: name)
end

Given /^I go to the page for (the|that) milestone$/ do |_|
  visit "/projects/#{Project.first.id}/milestones/#{Milestone.first.id}"
end

Then /^I should be on the page for (the|that) milestone$/ do |_|
  page.current_path.should =~ /^\/projects\/[a-f0-9]+\/milestones\/[a-f0-9]+$/
end
