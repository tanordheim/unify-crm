Given /^I have (\d+) tickets? for that project$/ do |number_of_tickets|
  number_of_tickets.to_i.times do
    category = Fabricate(:ticket_category, instance: Instance.first)
    Fabricate(:ticket, instance: Instance.first, project: Project.first, category: category, user: User.first, status: Ticket::STATUSES.key(:open))
  end
end

When /^I go to the tickets page for (the|that) project$/ do |_|
  visit "/projects/#{Project.first.id}/tickets"
end

Then /^I should see (\d+) tickets?$/ do |number_of_tickets|
  page.find('table.tickets tbody').all('tr').length.should == number_of_tickets.to_i
end

Given /^I have the ticket "([^"]*)" for that project$/ do |name|
  category = Fabricate(:ticket_category, instance: Instance.first)
  Fabricate(:ticket, instance: Instance.first, project: Project.first, category: category, status: Ticket::STATUSES.key(:open), user: User.first, name: name)
end

Given /^I have the ticket "([^"]*)" with category "([^"]*)" for that project$/ do |name, category_name|
  category = Fabricate(:ticket_category, instance: Instance.first, name: category_name)
  Fabricate(:ticket, instance: Instance.first, project: Project.first, category: category, status: Ticket::STATUSES.key(:open), user: User.first, name: name)
end

Given /^I have the ticket "([^"]*)" with category "([^"]*)" for that project with priority "([^"]*)" and due on "([^"]*)"$/ do |name, category_name, priority, due_on|

  step %{I have the ticket "#{name}" with category "#{category_name}" for that project}

  ticket = Ticket.first
  ticket.priority = Ticket::PRIORITIES.key(priority.underscore.to_sym).to_i
  ticket.due_on = due_on
  ticket.save!
  
end

Given /^I have the ticket "([^"]*)" for that milestone$/ do |name|
  category = Fabricate(:ticket_category, instance: Instance.first)
  Fabricate(:ticket, instance: Instance.first, project: Project.first, category: category, status: Ticket::STATUSES.key(:open), user: User.first, milestone: Project.first.milestones.first, name: name)
end

Given /^I have the ticket "([^"]*)" with category "([^"]*)" for that milestone$/ do |name, category_name|
  category = Fabricate(:ticket_category, instance: Instance.first, name: category_name)
  Fabricate(:ticket, instance: Instance.first, project: Project.first, category: category, status: Ticket::STATUSES.key(:open), user: User.first, milestone: Project.first.milestones.first, name: name)
end

Given /^I have the ticket "([^"]*)" with category "([^"]*)" for that milestone with priority "([^"]*)" and due on "([^"]*)"$/ do |name, category_name, priority, due_on|

  step %{I have the ticket "#{name}" with category "#{category_name}" for that milestone}

  ticket = Ticket.first
  ticket.priority = Ticket::PRIORITIES.key(priority.underscore.to_sym).to_i
  ticket.due_on = due_on
  ticket.save!

end

Given /^I go to the page for (the|that) ticket$/ do |_|
  visit "/projects/#{Project.first.id}/tickets/#{Ticket.first.id}"
end

Then /^I should be on the page for that ticket$/ do
  page.current_path.should =~ /^\/projects\/[a-f0-9]+\/tickets\/[a-f0-9]+$/
end

Then /^I should be on the tickets page for (that|the) project$/ do |_|
  page.current_path.should =~ /^\/projects\/[a-f0-9]+\/tickets$/
end

Then /^I should see the ticket status "([^"]*)"$/ do |status|
  within(:css, '.ticket-header li.status') do
    page.should have_content(status)
  end
end

When /^I close the ticket$/ do
  handle_js_confirm do
    step %{I click the "Close ticket" content action}
  end
end

When /^I close the first ticket$/ do
  page.find(:css, 'table.tickets tbody tr:first').find('a.close-action').click
end

When /^I reopen the ticket$/ do
  handle_js_confirm do
    step %{I click the "Reopen this ticket" content action}
  end
end

When /^I reopen the first ticket$/ do
  page.find(:css, 'table.tickets tbody tr:first').find('a.reopen-action').click
end

When /^I start progress on the ticket$/ do
  step %{I click the "Start progress" content action}
end

When /^I start progress on the first ticket$/ do
  page.find(:css, 'table.tickets tbody tr:first').find('a.start-progress-action').click
end

When /^I stop progress on the ticket$/ do
  step %{I click the "Stop progress" content action}
end

When /^I stop progress on the first ticket$/ do
  page.find(:css, 'table.tickets tbody tr:first').find('a.stop-progress-action').click
end

Then /^I should see the following tickets?:$/ do |expected_table|

  # The results are rendered in another AJAX request after the alert is
  # displayed, so we need to sleep for a bit to get the updated ticket list
  # displayed.
  sleep 1

  table = page.find(:css, 'table.tickets').all('tbody tr').map do |row|
    row.all('.name, .category, .priority, .status, .due-on, .assignee').map do |cell|
      cell.text.strip
    end
  end
  # puts "Expected table: #{expected_table.inspect}"
  # puts "Got table: #{table.inspect}"
  expected_table.diff!(table)

end
