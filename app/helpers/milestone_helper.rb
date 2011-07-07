# encoding: utf-8
#

# Helpers for the Milestone model class.
module MilestoneHelper

  # Returns the path to a milestone.
  def milestone_path(milestone)
    project_milestone_path(milestone.project, milestone)
  end

end
