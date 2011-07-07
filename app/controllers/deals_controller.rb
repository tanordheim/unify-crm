# encoding: utf-8
#

# Manages the deals for a Unify instance.
class DealsController < ApplicationController

  include FilteredResult::Controller
  
  respond_to :html, :js, :json

  expose(:deals) { current_instance.deals.filter_results(filters).page(params[:page]).per(10) }
  expose(:deal) do
    if params[:id].blank?
      current_instance.deals.build(params[:deal])
    else
      current_instance.deals.find(params[:id])
    end
  end
  expose(:comments) { deal.all_comments.sorted_by_created_time.page(params[:comment_page]).per(10) }
  expose(:commentable) { deal }

  expose(:categories) { current_instance.categories.deals.sorted_by_name }
  expose(:stages) { current_instance.deal_stages.sorted_by_percentage }
  expose(:sources) { current_instance.sources.sorted_by_name }
  expose(:users) { current_instance.users.sorted_by_name }

  set_navigation_section :deals

  # Set up the filters for the deal lists.
  add_filter :stage, type: :association, field: :stage_id, include_blank: 'All', collection: lambda { |instance| instance.stages }
  add_filter :category, type: :association, field: :category_id, include_blank: 'Any Category', collection: lambda { |instance| instance.categories }
  add_filter :keywords, type: :search
  add_filter :order, type: :sort, fields: [
    { key: :name, field: :name, direction: :asc },
    { key: :probability, field: :probability, direction: :asc },
    { key: :close_date, field: :expecting_close_on, direction: :asc }
  ]
  
  # GET /deals
  #
  # Displays all deals.
  def index
    respond_with(deals)
  end

  # GET /deals/:id
  #
  # Shows information about a deal.
  def show
    respond_with(deal)
  end

  # GET /deals/new
  #
  # Displays the form used to create a new deal.
  def new
    respond_with(deal)
  end

  # POST /deals
  #
  # Creates a new deal.
  def create
    flash[:notice] = 'The deal was successfully created.' if deal.save
    respond_with(deal)
  end

  # PUT /deals/:id
  #
  # Updates a deal.
  def update
    flash[:notice] = 'The deal was successfully updated.' if deal.update_attributes(params[:deal])
    respond_with(deal)
  end

end
