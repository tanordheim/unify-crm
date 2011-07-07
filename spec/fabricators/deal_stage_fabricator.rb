# encoding: utf-8
#

Fabricator(:deal_stage) do
  instance!
  name { Faker::Lorem.sentence }
  percent { sequence(:percentage) }
  color { ['#c50000', '#f55c99', '#009900'].sample }
end
