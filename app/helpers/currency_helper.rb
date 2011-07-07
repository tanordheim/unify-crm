# encoding: utf-8
#

# Helpers for dealing with currency formatting and conversion.
module CurrencyHelper

  # Format a money value into the currency for the current instance.
  #
  # @param [ Float ] value The money value to format.
  #
  # @return [ String ] The formatted money value.
  def format_currency(value)
    format_options = {
      :format => '%n',
      :separator => ',',
      :delimiter => ' '
    }
    number_to_currency(value, format_options)
  end
  
end
