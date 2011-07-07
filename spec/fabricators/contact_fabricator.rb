# encoding: utf-8
#

Fabricator(:contact) do
  instance!
end

Fabricator(:organization, :from => :contact, :class_name => 'Organization') do
  name { Faker::Company.name }
end

Fabricator(:person, :from => :contact, :class_name => 'Person') do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end
