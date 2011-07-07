# encoding: utf-8
#

Fabricator(:account) do
  instance!
  number { sequence(:number) }
  name { Faker::Lorem.sentence }
  type { Account::TYPES.keys.sample.to_i }
end

Fabricator(:organization_account, :from => :account, :class_name => 'OrganizationAccount') do
  organization!
  type { 0 }
end
