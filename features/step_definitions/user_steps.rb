Given /^I have (\d+) additional users?$/ do |number_of_users|
  number_of_users.to_i.times do
    Fabricate(:user, instance: Instance.first)
  end
end

Given /^I go to the users page$/ do
  visit '/users'
end

Then /^I should see (\d+) users$/ do |number_of_users|
  page.find('table.users tbody').all('tr').length.should == number_of_users.to_i
end

Then /^I should be on the page for that user$/ do
  page.current_path.should =~ /^\/users\/[a-f0-9]+$/
end

Given /^I go to the page for (that|the) user$/ do |_|
  visit "/users/#{User.where(:username.ne => 'user').first.id}"
end

When /^I send an API request for that user$/ do
  step %{I send an API request to "/users/#{User.where(:username.ne => 'user').first.id}"}
end
