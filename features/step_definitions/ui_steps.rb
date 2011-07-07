# Handle JavaScript confirm dialogs.
def handle_js_confirm(accept = true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
ensure
  page.evaluate_script "window.confirm = window.original_confirm_function"  
end

When /^I click the "([^"]*)" content action$/ do |text|
  page.find(:css, '.sidebar .content-navigation .nav-list a', text: text).click
end

Then /^I should see the "([^"]*)" entity header$/ do |header|
  within(:css, '.entity-header h1') do
    page.should have_content(header)
  end
end

Given /^I click the tab "([^"]*)"$/ do |text|
  page.find(:css, '.tabs ul li a', text: text).click
end

When /^I click the link "([^"]*)"$/ do |text|
  page.find(:css, '.content a, .modal a', :text => text).click
end

Then /^I should get a download with the filename "([^"]*)"$/ do |filename|
  page.response_headers['Content-Disposition'].should include("attachment; filename=\"#{filename}\"")
end

Then /^I should see the alert "([^"]*)"$/ do |message|
  within(:css, '#flash-alert') do
    page.should have_content(message)
  end
end

When /^I reload the page$/ do
  visit(current_path)
end
