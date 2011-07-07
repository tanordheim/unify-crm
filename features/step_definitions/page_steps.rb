Given /^I have (\d+) pages? for that project$/ do |number_of_pages|
  number_of_pages.to_i.times do
    Fabricate(:page, instance: Instance.first, project: Project.first)
  end
end

Given /^I go to the pages page for that project$/ do
  visit "/projects/#{Project.first.id}/pages"
end

Then /^I should see (\d+) pages?$/ do |number_of_pages|
  page.find('table.pages tbody').all('tr').length.should == number_of_pages.to_i
end

Then /^I should be on the page for that page$/ do
  page.current_path.should =~ /^\/projects\/[a-f0-9]+\/pages\/[a-f0-9]+$/
end

Given /^I go to the page for (the|that) page$/ do |_|
  visit "/projects/#{Project.first.id}/pages/#{Page.first.id}"
end
