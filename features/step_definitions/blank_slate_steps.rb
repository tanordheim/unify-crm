Then /^I should see the blank slate for "([^"]*)"$/ do |type|
  within(:css, '.content .blank-slate h5') do
    page.should have_content(type)
  end
end
