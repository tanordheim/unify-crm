Given /^I receive a commit from Github with the message "([^"]*)"$/ do |message|

  json = File.open(File.join(Rails.root, 'features', 'support', 'files', 'github_service_hook_comment.json'), 'r').read
  json.gsub!('#COMMIT_MESSAGE#', [Ticket.first.identifier, message].join(' '))

  post('/github/service_hook', payload: json)

end
