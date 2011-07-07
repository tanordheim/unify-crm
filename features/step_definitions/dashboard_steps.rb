Given /^I have (\d+) dashboard widgets? configured$/ do |number_of_widgets|
  number_of_widgets.to_i.times do
    Fabricate(:widget_configuration, user: User.first)
  end
end

Given /^I go to the dashboard$/ do
  visit '/'
end

Then /^I should see (\d+) dashboard widgets?$/ do |number_of_widgets|
  page.all('article.widget').length.should == number_of_widgets.to_i
end

When /^I add a new widget$/ do
  page.find(:css, 'a', text: 'Add new widget').click
end

When /^I select the widget "([^"]*)"$/ do |name|
  page.find(:css, '.modal').find(:css, 'a', text: name).click
end

Then /^I should be on the dashboard$/ do
  page.current_path.should == '/'
end
