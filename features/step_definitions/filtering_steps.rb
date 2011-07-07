When /^I set the "([^"]*)" filter to "([^"]*)"$/ do |type, value|

  filter_block = page.find(:css, 'ul.filter')
  filter_link = filter_block.find(:xpath, ".//a[@data-filter=\"#{type}\"]")
  container = filter_block.find(:xpath, ".//a[@data-filter=\"#{type}\"]/..")

  # Click the filter link to open up the selector.
  filter_link.click

  # Apply the filter.
  within(container) do
    page.find(:css, 'a', text: value).click
  end

  sleep 0.2 # Sleep a bit for the filter to get applied via Ajax.

end

When /^I enter "([^"]*)" for the "([^"]*)" filter$/ do |value, type|

  # Set the value of the input field and simulate the user pressing enter to
  # apply the filter.
  page.execute_script <<-JS
    var event = jQuery.Event('keypress', { which: $.ui.keyCode.ENTER });
    var inputField = $('input[data-filter="#{type}"]');
    inputField.val('#{value}');
    inputField.trigger(event);
  JS

  sleep 0.2 # Sleep for a bit for the filter to get applied via Ajax.

end
