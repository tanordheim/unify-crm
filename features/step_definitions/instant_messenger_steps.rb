Then /^I should see (\d+) instant messengers?$/ do |number_of_instant_messengers|
  page.find(:css, 'ul.instant-messengers').all(:css, 'li[data-instant-messenger-id]').length.should == number_of_instant_messengers.to_i
end

When /^I save the instant messenger$/ do
  page.find(:css, 'ul.instant-messengers').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) instant messengers? for the (\w+)$/ do |number_of_instant_messengers, model_class|
  model = model_class.classify.constantize.first
  number_of_instant_messengers.to_i.times do
    Fabricate(:instant_messenger, instant_messageable: model)
  end
end

When /^I delete the first instant messenger$/ do

  page.execute_script <<-JS
    var imRow = $('li[data-instant-messenger-id]:first');
    var deleteLink = $('a.inline-remove', imRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end
