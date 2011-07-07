# encoding: utf-8
#

# SCM comments are comments generated through commits in an SCM. This must be
# implemented as some kind of post-commit-hook in the SCM that calls a
# controller in Unify with the commit information.
class ScmComment < Comment

  SCMS = {
    '0' => :github
  }

  # Define the fields for the SCM comment.
  field :scm, type: Integer
  field :repository, type: String
  field :reference, type: String

  # Scm comments can have one or more files embedded within them.
  embeds_many :files, class_name: 'ScmCommentFile' do
    def added; with_action(:add); end
    def changed; with_action(:change); end
    def removed; with_action(:remove); end

    def with_action(action)
      @target.select { |f| f.action_name == action }
    end
  end

  # Validate that the SCM comment has an SCM set, and that it contains a valid
  # value. Also, make the scm attribute assignable through mass assignment.
  validates :scm, presence: true, inclusion: { in: SCMS.keys.map(&:to_i) }
  attr_accessible :scm

  # Validate that the SCM comment has a repository set, and make the repository
  # attribute assignable through mass assignment.
  validates :repository, presence: true
  attr_accessible :repository

  # Validate that the SCM comment has a reference set, and make the reference
  # attribute assignable through mass assignment.
  validates :reference, presence: true
  attr_accessible :reference
  
  # Returns the name of the scm associated with this scm comment.
  #
  # @return [ Symbol ] A name identifying the scm code for this scm comment.
  def scm_name
    SCMS[scm.to_s]
  end
 
end
