# encoding: utf-8
#

# Manages the polymorphic comment model that can be used on any primary data
# type within Unify. This controller is only available via JavaScript AJAX
# calls, and has no HTML views.
class CommentsController < ApplicationController

  respond_to :js
  expose(:comment) do
    c = current_instance.comments.build(params[:comment])
    c.user = current_user
    c
  end
  expose(:commentable) do
    if params[:commentable_type] && params[:commentable_id]
      commentable_class = params[:commentable_type].singularize.classify.constantize
      commentable_class.find(params[:commentable_id])
    else
      comment.commentable
    end
  end
  expose(:comments) { commentable.all_comments.sorted_by_created_time.page(params[:comment_page]).per(10) }

  # GET /comments/:commentable_type/:commentable_id
  #
  # Displays the comment for the specified commentable.
  def index
    respond_with(comments)
  end

  # GET /comments/new
  #
  # Displays the form used to create a new comment.
  def new
    respond_with(comment)
  end

  # POST /comments
  #
  # Creates a new comment.
  def create
    flash[:notice] = 'The comment was successfully created.' if comment.save
    respond_with(comment)
  end

end
