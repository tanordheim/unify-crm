Given /^I have (\d+) deals?$/ do |number_of_deals|
  number_of_deals.to_i.times do
    organization = Fabricate(:organization, instance: Instance.first)
    person = Fabricate(:person, instance: Instance.first)
    stage = Fabricate(:deal_stage, instance: Instance.first)
    category = Fabricate(:deal_category, instance: Instance.first)
    Fabricate(:deal, instance: Instance.first, organization: organization, person: person, stage: stage, category: category)
  end
end

Given /^I have the deal "([^"]*)"$/ do |name|
  organization = Fabricate(:organization, instance: Instance.first)
  person = Fabricate(:person, instance: Instance.first)
  stage = Fabricate(:deal_stage, instance: Instance.first)
  category = Fabricate(:deal_category, instance: Instance.first)
  Fabricate(:deal, instance: Instance.first, organization: organization, person: person, stage: stage, category: category, name: name)
end

Given /^I have the deal "([^"]*)" with the category "([^"]*)" in stage "([^"]*)"$/ do |name, category_name, stage_name|

  organization = Fabricate(:organization, instance: Instance.first)
  person = Fabricate(:person, instance: Instance.first)

  stage = Instance.first.deal_stages.where(name: stage_name).first
  if stage.blank?
    stage = Fabricate(:deal_stage, instance: Instance.first, name: stage_name)
  end

  category = Instance.first.categories.deals.where(name: category_name).first
  if category.blank?
    category = Fabricate(:deal_category, instance: Instance.first, name: category_name)
  end

  Fabricate(:deal, instance: Instance.first, organization: organization, person: person, stage: stage, category: category, name: name)

end

Given /^I go to the deals page$/ do
  visit '/deals'
end

Then /^I should see (\d+) deals?$/ do |number_of_deals|
  page.find('table.deals-table tbody').all('tr.deal').length.should == number_of_deals.to_i
end

Then /^I should be on the page for that deal$/ do
  page.current_path.should =~ /^\/deals\/[a-f0-9]+$/
end

Given /^I go to the page for (that|the) deal$/ do |_|
  visit "/deals/#{Deal.first.id}"
end

When /^I start changing the deal pricing$/ do
  page.find(:css, '.block.pricing h6 small a').click
end

When /^I save the deal pricing$/ do
  page.find(:css, '.block.pricing .inplace-editable-form button').click
  sleep 0.5
end

Then /^I should see the deal price "([^"]*)"$/ do |value|
  within(:css, '.block.pricing .inplace-editable-view') do
    page.should have_content(value)
  end
end

Given /^I start changing the deal stage$/ do
  page.find(:css, '.block.stage .inplace-editable .inplace-editable-view a').click
end

Given /^I save the deal stage$/ do
  page.find(:css, '.block.stage .inplace-editable .inplace-editable-form button').click
  sleep 0.5
end

Then /^I should see the stage "([^"]*)" for the deal$/ do |name|
  within(:css, '.block.stage .inplace-editable .inplace-editable-view span') do
    page.should have_content(name)
  end
end

Given /^I start changing the deal category$/ do
  page.find(:css, '.block.category .inplace-editable .inplace-editable-view a').click
end

Then /^I should see the category "([^"]*)" for the deal$/ do |name|
  within(:css, '.block.category .inplace-editable-view') do
    page.should have_content(name)
  end
end

Given /^I save the deal category$/ do
  page.find(:css, '.block.category .inplace-editable .inplace-editable-form button').click
  sleep 0.5
end
