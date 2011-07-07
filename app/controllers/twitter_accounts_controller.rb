# encoding: utf-8
#

# Manages twitter accounts for a tweetable entity.
class TwitterAccountsController < ApplicationController

  respond_to :js

  expose(:tweetable_type) { find_tweetable_type }
  expose(:tweetable_id) { params[:"#{tweetable_type}_id"] }
  expose(:tweetable) { find_tweetable }
  expose(:twitter_account) do
    if params[:id]
      tweetable.twitter_accounts.find(params[:id])
    else
      tweetable.twitter_accounts.build(params[:twitter_account])
    end
  end

  # POST /<tweetable>/<tweetable_id>/twitter_accounts
  #
  # Create a new twitter account for the tweetable.
  def create
    flash[:notice] = 'The twitter account was successfully added.' if twitter_account.save
    respond_with(twitter_account)
  end

  # DELETE /<tweetable>/<tweetable_id>/twitter_accounts/:id
  #
  # Removes a twitter account from the tweetable.
  def destroy
    twitter_account.destroy
    flash[:notice] = 'The twitter account was successfully removed.'
    respond_with(twitter_account)
  end

  private

  # Find the tweetable type for the request.
  #
  # @return [ Symbol ] The name of the tweetable type.
  def find_tweetable_type
    %w(organization person).each do |type|
      param_name = [type, 'id'].join('_').to_sym
      requested_id = params[param_name]
      return type.to_sym unless requested_id.blank?
    end
    nil
  end

  # Find the requested tweetable.
  #
  # @return [ Mongoid::Document ] The tweetable Mongoid document.
  def find_tweetable
    tweetable_type.to_s.classify.constantize.find(tweetable_id)
  end

end
