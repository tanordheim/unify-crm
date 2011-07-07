# encoding: utf-8
#

Fabricator(:ticket_progress) do

  # If no ticket trackable is assigned to the ticket progress, associate it with
  # a project.
  after_build do |progress|
    if progress.ticket_trackable.blank?
      progress.ticket_trackable = Fabricate(:project)
    end
  end
end
