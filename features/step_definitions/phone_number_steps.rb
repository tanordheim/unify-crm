Then /^I should see (\d+) phone numbers?$/ do |number_of_phone_numbers|
  page.find(:css, 'ul.phone-numbers').all(:css, 'li[data-phone-number-id]').length.should == number_of_phone_numbers.to_i
end

When /^I save the phone number$/ do
  page.find(:css, 'ul.phone-numbers').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) phone numbers? for the (\w+)$/ do |number_of_phone_numbers, model_class|
  model = model_class.classify.constantize.first
  number_of_phone_numbers.to_i.times do
    Fabricate(:phone_number, phoneable: model)
  end
end

When /^I delete the first phone number$/ do

  page.execute_script <<-JS
    var phoneNumberRow = $('li[data-phone-number-id]:first');
    var deleteLink = $('a.inline-remove', phoneNumberRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end
