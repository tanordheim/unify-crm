# encoding: utf-8
#

Fabricator(:comment) do
  instance!
  user!
  body { Faker::Lorem.sentence }

  # If no commentable is assigned to the comment, associate it with an
  # organization.
  after_build do |comment|
    if comment.commentable.blank?
      comment.commentable = Fabricate(:organization)
    end
  end
end

Fabricator(:scm_comment, from: :comment, class_name: 'ScmComment') do
  scm { ScmComment::SCMS.keys.sample.to_i }
  repository { "http://github.com/#{Faker::Internet.user_name}/#{Faker::Internet.user_name}" }
  reference { SecureRandom.hex(16) }
end
