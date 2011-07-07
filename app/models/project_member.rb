# encoding: utf-8
#

# Project members defines a member related to a project.
class ProjectMember

  # Project members are Mongoid documents.
  include Mongoid::Document

  # Project members are embedded within projects, as an inversed association of
  # the members collection.
  embedded_in :project, inverse_of: :members

  # Project members are associated with users.
  belongs_to :user

  # Validate that the project member is associated with a user. Also, make the
  # user and user_id attributes assignble through mass assignment.
  validates :user, presence: true, uniqueness: true
  attr_accessible :user, :user_id

end
