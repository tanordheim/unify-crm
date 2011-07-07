# encoding: utf-8
#

module Mongoid #:nodoc

  # Adds support for comments on a Mongoid::Document class.
  module Comments

    extend ActiveSupport::Concern

    included do

      # Add a comment association.
      has_many :comments, as: :commentable, dependent: :destroy

    end

    # Returns all available comments, both for this entity and comments made
    # on relevant associated entities.
    #
    # @return [ Mongoid::Criteria ] A Mongoid criteria containing all comments for
    #   this entity and its relevant associated entities.
    def all_comments

      # Build an array of all object IDs related to, and including, this
      # organization.
      object_ids = ([id] + [commentable_object_ids]).flatten.compact.uniq

      # Return all matching comments.
      Comment.where(instance_id: instance.id).any_in(commentable_id: object_ids)

    end

    private

    # Return a list of all object IDs of related objects which should have
    # their comments included in the comment list for this entity.
    #
    # This should not include the ID of the current entity, that value is
    # implicit.
    #
    # @return [ Array ] An array of object IDs.
    def commentable_object_ids
      []
    end

  end

end
