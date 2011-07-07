# encoding: utf-8
#

# Comments are user-generated (either via a form in Unify or through external
# means like e-mail) comments on an entity stored in Unify. It's a polymorphic
# model that can be used in any model.
class Comment

  # Comments are Mongoid documents.
  include Mongoid::Document

  # Log created and updated-time.
  include Mongoid::Timestamps
  
  # Define the fields for the comment.
  field :body, type: String

  # Comments are associated with instances.
  belongs_to :instance

  # Comments can be associated with any object as a polymorphic association
  # named 'commentable' using the :as option in the has_many directive. Also,
  # make the commentable attributes assignable through mass assignment.
  belongs_to :commentable, polymorphic: true
  attr_accessible :commentable, :commentable_id, :commentable_type

  # Comments are associated with the user that wrote them, and make the user
  # attributes assignable through mass assignment.
  belongs_to :user
  attr_accessible :user, :user_id
  
  # Validate that the comment is associated with an instance.
  validates :instance, presence: true

  # Validate that the comment is associated with a commentable.
  validates :commentable, presence: true

  # Validate that the comment is associated with a user.
  validates :user, presence: true

  # Validate that the comment has a body set, and make the body attribute
  # assignable through mass assignment.
  validates :body, presence: true
  attr_accessible :body

  # Sort comments by the time they were created.
  scope :sorted_by_created_time, order_by(:created_at.desc)
  
end
