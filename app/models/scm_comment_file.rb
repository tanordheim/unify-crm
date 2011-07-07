# encoding: utf-8
#

# SCM comment files defines a file that have changed in some way within a SCM
# commit.
class ScmCommentFile

  ACTIONS = {
    '0' => :add,
    '1' => :change,
    '2' => :remove
  }

  # Scm comment files are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the SCM comment file.
  field :action, type: Integer
  field :path, type: String

  # Scm comment files are embedded in scm comments.
  embedded_in :scm_comment, inverse_of: :files

  # Validate that the scm comment file has an action set and that it's a valid
  # action. Also, make the action attribute assignable through mass assignment.
  validates :action, presence: true, inclusion: { in: ACTIONS.keys.map(&:to_i) }
  attr_accessible :action

  # Validate that the scm comment file has a path set, and make the path
  # attribute assignable through mass assignment.
  validates :path, presence: true
  attr_accessible :path
  
  # Returns the name of the action associated with this scm comment file.
  #
  # @return [ Symbol ] A name identifying the action code for this scm comment
  #   file.
  def action_name
    ACTIONS[action.to_s]
  end
  
end
