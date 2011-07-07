# encoding: utf-8
#

# Manages the dashboard widgets for a user in the Unify instance.
class DashboardWidgetsController < ApplicationController

  respond_to :js

  expose(:widget_configurations) { current_user.widget_configurations }
  expose(:widget) do
    if params[:id]
      current_user.widget_configurations.find(params[:id])
    else
      current_user.widget_configurations.build(params[:widget_configuration])
    end
  end

  # GET /dashboard_widgets/new
  #
  # Presents the user with a list of dashboard widgets that can be added to the
  # dashboard.
  def new
    respond_with(widget_configurations)
  end

  # POST /dashboard_widgets
  #
  # Creates a new dashboard widget for the user.
  def create
    flash[:notice] = 'The new dashboard widget was added.' if widget.save
    respond_with(widget)
  end

  # DELETE /dashboard_widgets/:id
  #
  # Removes a widget from the users dashboard.
  def destroy
    flash[:notice] = 'The widget was removed.' if widget.destroy
    respond_with(widget)
  end

  # POST /dashboard_widgets/reorder
  #
  # Reorders widgets, both sort order within a column and what column they
  # should be placed in.
  def reorder

    columns = {
      '0' => params[:positions][:left] || [],
      '1' => params[:positions][:middle] || [],
      '2' => params[:positions][:right] || []
    }

    # Go through all columns and position the widgets in the correct column
    # according to the input data.
    columns.each do |index, widgets|
      widgets.each do |widget_id|
        widget = widget_configurations.find(widget_id)
        widget.column = index
      end
    end

    # Go through all widgets and order them according to the input.
    new_widget_configurations = []
    [columns['0'], columns['1'], columns['2']].flatten.each_with_index do |widget_id, index|
      new_widget_configurations << widget_configurations.find(widget_id)
    end
    current_user.widget_configurations = new_widget_configurations
    current_user.save

    render nothing: true

  end

end
