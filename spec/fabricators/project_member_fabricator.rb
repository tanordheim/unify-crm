# encoding: utf-8
#

Fabricator(:project_member) do
  project { Fabricate.build(:project, members: []) }
  user!
end
