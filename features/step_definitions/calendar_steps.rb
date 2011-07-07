Given /^I go to the calendar page for the year (\d+), the month (\d+) and the day (\d+)$/ do |year, month, day|
  visit "/calendar/#{year}/#{month}/#{day}"
end

Then /^I should see the calendar for "([^"]*)" of (\d+)$/ do |month, year|
  within(:css, '.calendar .month-column header h4') do
    page.should have_content("#{month} #{year}")
  end
end

Then /^I should see the calendar details for "([^"]*)" (\d+)(th|rd)$/ do |month, day, _|
  within(:css, '.calendar .day-column header h4') do
    page.should have_content("#{month} #{day}")
  end
end
