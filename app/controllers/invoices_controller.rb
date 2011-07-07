# encoding: utf-8
#

# Manages the invoices for a Unify instance.
class InvoicesController < ApplicationController

  include FilteredResult::Controller
  
  respond_to :html, :js
  respond_to :pdf, only: :show

  expose(:invoices) { current_instance.invoices.filter_results(filters).page(params[:page]).per(15) }
  expose(:invoice) do
    if params[:id].blank?
      current_instance.invoices.build(params[:invoice])
    else
      current_instance.invoices.find(params[:id])
    end
  end

  expose(:organizations) { current_instance.contacts.organizations.active.sorted_by_name }
  expose(:projects) { current_instance.projects.active.sorted_by_name }
  expose(:products) { current_instance.products.sorted_by_name }
  
  set_navigation_section :accounting

  # Set up the filters for the invoice list.
  add_filter :order, type: :sort, fields: [
    { key: :due_on, field: :due_on, direction: :desc },
    { key: :billed_on, field: :billed_on, direction: :desc },
    { key: :identifier, field: :sequence, direction: :asc }
  ]

  # GET /invoices
  #
  # Displays a list of all available invoices.
  def index
    respond_with(invoices)
  end

  # GET /invoices/:id
  #
  # Displays information about an invoice.
  def show
    respond_with(invoice) do |format|
      format.pdf { render :template => "/invoices/pdf/#{pdf_template}", :layout => false }
    end
  end

  # GET /invoices/new
  #
  # Displays the form used to create a new invoice.
  def new
    respond_with(invoice)
  end

  # POST /invoices
  #
  # Creates a new invoice.
  def create
    flash[:notice] = 'The invoice was successfully created.' if invoice.save
    respond_with(invoice)
  end

  # GET /invoices/:id/edit
  #
  # Displays the form used to edit an invoice.
  def edit
    respond_with(invoice)
  end

  # PUT /invoices/:id
  #
  # Updates an invoice.
  def update
    flash[:notice] = 'The invoice was successfully updated.' if invoice.update_attributes(params[:invoice])
    respond_with(invoice)
  end

  # GET /invoices/:id/generate_pdf
  #
  # Displays the PDF format selector for PDF generation of the invoice.
  def generate_pdf
    respond_with(invoice)
  end

  # POST /invoices/:id/generate
  #
  # Generates an invoice, flagging it as unpaid.
  def generate
    invoice.generate!
    flash[:notice] = "The invoice has been generated and assigned the identifier #{invoice.identifier}"
    respond_with(invoice)
  end
  
  private

  # Returns the PDF template to use when rendering an invoice to PDF.
  def pdf_template
    valid_templates = %w(standard f90)
    params[:template] && valid_templates.include?(params[:template]) ? params[:template] : valid_templates.first
  end

end
