Given /^I have (\d+) organizations?$/ do |number_of_organizations|
  number_of_organizations.to_i.times do
    Fabricate(:organization, instance: Instance.first)
  end
end

Given /^I have (\d+) (person|people)$/ do |number_of_people, _|
  number_of_people.to_i.times do
    Fabricate(:person, instance: Instance.first)
  end
end

When /^I go to the contacts page$/ do
  visit '/contacts'
end
