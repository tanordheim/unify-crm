Then /^I should see (\d+) websites?$/ do |number_of_websites|
  page.find(:css, 'ul.websites').all(:css, 'li[data-website-id]').length.should == number_of_websites.to_i
end

When /^I save the website$/ do
  page.find(:css, 'ul.websites').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) websites? for the (\w+)$/ do |number_of_websites, model_class|
  model = model_class.classify.constantize.first
  number_of_websites.to_i.times do
    Fabricate(:website, websiteable: model)
  end
end

When /^I delete the first website$/ do

  page.execute_script <<-JS
    var websiteRow = $('li[data-website-id]:first');
    var deleteLink = $('a.inline-remove', websiteRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end
