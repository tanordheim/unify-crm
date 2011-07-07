# encoding: utf-8
#

# Base class for all dashboard widgets.
class DashboardWidget < Apotomo::Widget

  # Set up the widget after initializing the instance.
  after_initialize :setup!

  private

  # Set up the widget.
  def setup!(event)
    @current_instance = options[:instance]
    @current_user = options[:user]
    @config = options[:config]
  end

end
