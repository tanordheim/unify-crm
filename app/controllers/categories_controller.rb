# encoding: utf-8
#

# Superclass for the controllers used to manage each type of categories for the
# Unify instance.
class CategoriesController < ApplicationController

  respond_to :html, :js

  expose(:param_name) { "#{category_type.to_s}_category".to_sym }
  expose(:categories) { current_instance.categories.send(category_type.to_s.pluralize).sorted_by_name }
  expose(:category) do
    if params[:id].blank?

      c = "#{category_type.to_s}_category".classify.constantize.new(params[param_name])
      c.instance = current_instance
      c
      
    else
      current_instance.categories.send(category_type.to_s.pluralize).find(params[:id])
    end
  end

  # GET /<type>_categories
  #
  # Displays a list of categories for the specified type.
  def index
    respond_with(categories)
  end

  # GET /<type>_categories/new
  #
  # Displays the form used to create a new category for the specified type.
  def new
    respond_with(category)
  end

  # POST /<type>_categories
  #
  # Creates a new category for the specified type.
  def create
    flash[:notice] = 'The category was successfully created.' if category.save
    respond_with(category)
  end

  # GET /<type>_categories/:id/edit
  #
  # Displays the form used to modify a category of the specified type.
  def edit
    respond_with(category)
  end

  # PUT /<type>_categories/:id
  #
  # Updates a category of the specified type.
  def update
    flash[:notice] = 'The category was successfully updated.' if category.update_attributes(params[param_name])
    respond_with(category)
  end

  # DELETE /<type>_categories/:id
  #
  # Removes a category of the specified type.
  def destroy
    flash[:notice] = 'The category was successfully removed.' if category.destroy
    respond_with(category)
  end

end
