# encoding: utf-8
#

Fabricator(:user) do
  instance!
  username { Faker::Internet.user_name }
  password { 'password' }
  password_confirmation { 'password' }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  title { Faker::Company.catch_phrase }
end
