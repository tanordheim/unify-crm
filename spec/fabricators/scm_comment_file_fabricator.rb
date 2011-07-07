# encoding: utf-8
#

Fabricator(:scm_comment_file) do
  scm_comment!
  action { ScmCommentFile::ACTIONS.keys.sample.to_i }
  path { Faker::Company.bs.underscore }
end
