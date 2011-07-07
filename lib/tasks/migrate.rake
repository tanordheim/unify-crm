namespace :migrate do

  desc 'Remove the now deprecated tasks collection'
  task :remove_tasks_collection => :environment do
    Mongoid.master.drop_collection('tasks')
  end

  desc 'Set the _scheduled value on all tickets'
  task :add_scheduled_to_tickets => :environment do
    Ticket.all.each(&:save)
  end

end
