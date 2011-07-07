# encoding: utf-8
#

# Defines the configuration of a widget for a user in the Unify instance.
class WidgetConfiguration

  TYPES = [
    :my_tickets
  ]

  COLUMNS = [0, 1, 2]
  
  # Widget configurations are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the widget configuration.
  field :type, type: Symbol
  field :column, type: Integer, default: 0

  # Widget configurations are embedded within users.
  embedded_in :user

  # Validate that the widget configuration has a type set, and that it contains
  # a valid value. Also, make the type column assignable through mass
  # assignment.
  validates :type, presence: true, inclusion: { in: TYPES }
  attr_accessible :type

  # Validate that the widget configuration has a column set, and that it
  # contains a valid value. Also, make the column attribute assignable through
  # mass assignment.
  validates :column, presence: true, inclusion: { in: COLUMNS }
  attr_accessible :column

  # Returns an unique widget ID for this widget configuration.
  #
  # @return [ String ] An unique widget ID.
  def widget_id
    [type.to_s, id.to_s].join('_')
  end

end
