# encoding: utf-8
#

Fabricator(:employment) do
  person!
  organization!
  title { Faker::Company.catch_phrase }
  since { Date.today - rand(1..5).years }
end
