Then /^I should see (\d+) twitter accounts?$/ do |number_of_twitter_accounts|
  page.find(:css, 'ul.twitter-accounts').all(:css, 'li[data-twitter-account-id]').length.should == number_of_twitter_accounts.to_i
end

When /^I save the twitter account$/ do
  page.find(:css, 'ul.twitter-accounts').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) twitter accounts? for the (\w+)$/ do |number_of_twitter_accounts, model_class|
  model = model_class.classify.constantize.first
  number_of_twitter_accounts.to_i.times do
    Fabricate(:twitter_account, tweetable: model)
  end
end

When /^I delete the first twitter account$/ do

  page.execute_script <<-JS
    var twitterRow = $('li[data-twitter-account-id]:first');
    var deleteLink = $('a.inline-remove', twitterRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end
