Then /^I should see (\d+) e-mail (addresses|address)$/ do |number_of_email_addresses, _|
  page.find(:css, 'ul.email-addresses').all(:css, 'li[data-email-address-id]').length.should == number_of_email_addresses.to_i
end

When /^I save the e-mail address$/ do
  page.find(:css, 'ul.email-addresses').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) e-mail (addresses|address) for the (\w+)$/ do |number_of_email_addresses, _, model_class|
  model = model_class.classify.constantize.first
  number_of_email_addresses.to_i.times do
    Fabricate(:email_address, emailable: model)
  end
end

When /^I delete the first e-mail address$/ do

  page.execute_script <<-JS
    var emailRow = $('li[data-email-address-id]:first');
    var deleteLink = $('a.inline-remove', emailRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end
