# encoding: utf-8
#

# Manages the products for a Unify instance.
class ProductsController < ApplicationController

  respond_to :html, :js
  expose(:products) { current_instance.products.sorted_by_name }
  expose(:product) do
    if params[:id].blank?
      current_instance.products.build(params[:product])
    else
      current_instance.products.find(params[:id])
    end
  end

  expose(:accounts) { current_instance.accounts.without_organization_accounts.sorted_by_number }

  set_navigation_section :accounting

  # GET /products
  #
  # Displays a list of all available products.
  def index
    respond_with(products)
  end

  # GET /products/new
  #
  # Displays the form used to create a new product.
  def new
    respond_with(product)
  end

  # POST /products
  #
  # Creates a new product.
  def create
    flash[:notice] = 'The product was successfully created.' if product.save
    respond_with(product)
  end

  # GET /products/:id/edit
  #
  # Displays the form used to edit a product.
  def edit
    respond_with(product)
  end

  # PUT /products/:id
  #
  # Updates a product.
  def update
    flash[:notice] = 'The product was successfully updated.' if product.update_attributes(params[:product])
    respond_with(product)
  end
  
end
