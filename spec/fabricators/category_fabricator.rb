# encoding: utf-8
#

Fabricator(:category) do
  instance!
  name { Faker::Lorem.sentence }
  color { ['#c50000', '#f55c99', '#009900', '#660099', '#3185c5', '#666666'].sample }
end

Fabricator(:deal_category, from: :category, class_name: 'DealCategory')
Fabricator(:event_category, from: :category, class_name: 'EventCategory')
Fabricator(:project_category, from: :category, class_name: 'ProjectCategory')
Fabricator(:ticket_category, from: :category, class_name: 'TicketCategory')
