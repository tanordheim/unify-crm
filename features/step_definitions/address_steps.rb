Then /^I should see (\d+) (addresses|address)$/ do |number_of_addresses, _|
  page.find(:css, 'ul.addresses').all(:css, 'li[data-address-id]').length.should == number_of_addresses.to_i
end

When /^I save the address$/ do
  page.find(:css, 'ul.addresses').all('button').first.click
  sleep 0.2 # Sleep for the results to be returned via Ajax.
end

Given /^I have (\d+) (addresses|address) for the (\w+)/ do |number_of_addresses, _, model_class|
  model = model_class.classify.constantize.first
  number_of_addresses.to_i.times do
    Fabricate(:address, addressable: model)
  end
end

When /^I delete the first address$/ do

  page.execute_script <<-JS
    var addressRow = $('li[data-address-id]:first');
    var deleteLink = $('a.inline-remove', addressRow);
    deleteLink.click();
  JS

  sleep 1 # Sleep for the record to be removed.

end
