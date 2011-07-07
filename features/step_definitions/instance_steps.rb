Given /^I go to the login page$/ do
  visit '/session/new'
end

Given /^I am using the Unify instance "([^"]*)"$/ do |subdomain|
  Capybara.default_host = "#{subdomain}.unify.dev"
  Capybara.server_port = 9887
  Capybara.app_host = "http://#{subdomain}.unify.dev:9887" # if Capybara.current_driver == :webkit
  header('Host', "#{subdomain}.unify.dev")
end

Given /^I am logged in as a user$/ do

  step %{I have a Unify instance}

  # Create a user for the instance.
  user = Fabricate.build(:user, username: 'user', password: 'password', password_confirmation: 'password', instance: Instance.first, first_name: 'Cucumber', last_name: 'User')
  user.email_addresses << Fabricate.build(:email_address, emailable: user, location: EmailAddress::LOCATIONS.key(:work).to_i, address: 'cucumber@unifyhq.com')
  user.save!

  step %{I go to the login page}
  step %{I fill in "username" with "user"}
  step %{I fill in "password" with "password"}
  step %{I submit the form}
  step %{I should be logged in}

end

Then /^I should be logged in$/ do
  page.find(:css, '.application-header .secondary-navigation a', text: 'Log out')
end

Given /^I go to the instance page$/ do
  visit '/instance'
end

Given /^I have a Unify instance$/ do
  instance = Fabricate(:instance, subdomain: 'cucumber')
  step %{I am using the Unify instance "#{instance.subdomain}"}
end
