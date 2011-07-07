# encoding: utf-8
#

# Helpers for the Comment model class.
module CommentsHelper

  # Returns the URL to the new comment action for the specified commentable.
  #
  # @param [ Mongoid::Document ] commentable The commentable to find new
  #   comment-action URL for.
  #
  # @return [ String ] The URL to the new comment action for the commentable.
  def new_comment_path_for(commentable)
    new_comment_path(comment: { commentable_type: commentable.class.name, commentable_id: commentable.id.to_s })
  end

  # Returns the name of the commentable associated with the comment.
  #
  # @param [ Comment ] comment The comment to find the commentable name for.
  #
  # @return [ String ] The name of the commentable for the comment.
  def commentable_name(comment)
    if comment.commentable.is_a?(Ticket)
      comment.commentable.identifier
    else
      comment.commentable.name
    end
  end

  # Returns the URL of the commentable associated with the comment.
  #
  # @param [ Comment ] comment The comment to find the commentable URL for.
  #
  # @return [ String ] The URL to the commentable for the comment.
  def commentable_url(comment)
    url_for(comment.commentable)
  end

  # Returns the URL to a scm comment repository.
  #
  # @param [ ScmComment ] comment The comment to find repository URL for.
  #
  # @return [ String ] The full URL to the repository.
  def scm_comment_repository_url(comment)
    send(:"#{comment.scm_name}_comment_repository_url", comment)
  end


  # Returns the URL to a scm comment file.
  # 
  # @param [ ScmCommentFile ] file The file to find the URL for.
  #
  # @return [ String ] The full URL to the file.
  def scm_comment_file_url(file)
    send(:"#{file.scm_comment.scm_name}_comment_file_url", file)
  end

  private

  # Returns the URL to the repository for a Github comment.
  #
  # @param [ ScmComment ] comment The comment to find repository URL for.
  #
  # @return [ String ] The full URL to the repository.
  def github_comment_repository_url(comment)
    [comment.repository, 'commit', comment.reference].join('/')
  end
  
  # Returns the URL to a file for a Github SCM comment.
  # 
  # @param [ ScmCommentFile ] file The file to find the URL for.
  #
  # @return [ String ] The full URL to the file.
  def github_comment_file_url(file)
    [file.scm_comment.repository, 'blob', file.scm_comment.reference, file.path].join('/')
  end

end
