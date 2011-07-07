Given /^I have (\d+) comments? for the (\w+)$/ do |number_of_comments, model_class|
  @last_comment_time ||= Time.now - 1.hour
  @last_comment_time = @last_comment_time + 1.minute
  model = model_class.classify.constantize.last
  number_of_comments.to_i.times do
    c = Fabricate.build(:comment, commentable: model, instance: model.instance)
    c.created_at = @last_comment_time
    c.save!
  end
end

Then /^I should see (\d+) comments?$/ do |number_of_comments|
  page.find(:css, 'table.comments-table').all(:css, 'tr[data-comment-id]').length.should == number_of_comments.to_i
end

# Given /^I enter the comment "([^"]*)"$/ do |text|
#   step %{I fill in "comment_body" with "#{text}"}
# end
# 
# When /^I enter the comment "([^"]*)" in the dialog$/ do |text|
#   page.find('.modal #comment_body').set(text)
# end
# 
# Then /^I should see (\d+) comments?$/ do |number_of_comments|
#   page.find('.comments').all('.comment').length.should == number_of_comments.to_i
# end
# 
# Then /^I should see the comment "([^"]*)" for "([^"]*)"$/ do |text, subject|
#   within(:css, '.comments > .comment:first p:not(.details)') do
#     page.should have_content(text)
#   end
#   within(:css, '.comments > .comment:first p.details a:last') do
#     page.should have_content(subject)
#   end
# end
# 
# Given /^I have the comment "([^"]*)" for that (\w+)$/ do |text, class_name|
#   @last_comment_time ||= Time.now - 1.hour
#   @last_comment_time = @last_comment_time + 1.minute
#   model_class = class_name.classify.constantize
#   model = model_class.last
#   c = Fabricate.build(:comment, commentable: model, instance: model.instance, body: text)
#   c.created_at = @last_comment_time
#   c.save!
# end
# 
# Then /^I should see the following comments?:$/ do |expected_table|
#   table = page.find(:css, '.comments').all('.comment').map do |row|
#     [
#       row.find('p:not(.details)').text,
#       row.find('p.details a:last').text
#     ]
#   end
#   expected_table.diff!(table)
# end
# 
# Given /^I have the scm comment "([^"]*)" for that (\w+) with (\d+) new files, (\d+) changed files and (\d+) removed files$/ do |text, class_name, new_files, changed_files, removed_files|
# 
#   @last_comment_time ||= Time.now - 1.hour
#   @last_comment_time = @last_comment_time + 1.minute
#   model_class = class_name.classify.constantize
#   model = model_class.last
# 
#   c = Fabricate.build(:scm_comment, commentable: model, instance: model.instance, body: text)
# 
#   new_files.to_i.times do
#     Fabricate.build(:scm_comment_file, scm_comment: c, action: ScmCommentFile::ACTIONS.key(:add).to_i)
#   end
#   changed_files.to_i.times do
#     Fabricate.build(:scm_comment_file, scm_comment: c, action: ScmCommentFile::ACTIONS.key(:change).to_i)
#   end
#   removed_files.to_i.times do
#     Fabricate.build(:scm_comment_file, scm_comment: c, action: ScmCommentFile::ACTIONS.key(:remove).to_i)
#   end
# 
#   c.created_at = @last_comment_time
#   c.save!
# 
# end
