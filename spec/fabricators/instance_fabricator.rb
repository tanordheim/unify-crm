# encoding: utf-8
#

Fabricator(:instance) do
  subdomain { sequence(:subdomain) { |i| [Faker::Internet.domain_word, i].join('') } }
  organization! { |instance| Fabricate.build(:instance_organization, :instance => instance) }
end
