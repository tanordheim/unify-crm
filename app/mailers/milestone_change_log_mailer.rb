# encoding: utf-8
#

# Notifies project members about a milestone change log.
class MilestoneChangeLogMailer < ActionMailer::Base

  layout 'email'
  helper :formatting
  helper :email_styling

  # Send a change-log email to a user.
  def change_log_email(milestone, sender, user)

    @project = milestone.project
    @milestone = milestone
    @resolved_tickets = milestone.tickets.completed.sorted_by_due_date
    @user = user

    sender_name = sender.name
    sender_email = if sender.email_addresses.primary.blank? || sender.email_addresses.primary.address.blank?
                     'noreply@unifyhq.com'
                   else
                     sender.email_addresses.primary.address
                   end

    mail(to: "#{user.name} <#{user.email_addresses.primary.address}>", from: "#{sender_name} <#{sender_email}>", subject: "#{milestone.project.name}: #{milestone.name} Change Log")
  end

end
