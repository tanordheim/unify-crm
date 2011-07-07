# encoding: utf-8
#

# This is a date selector input for SimpleForm that supports time selection as
# well as date selection.
class DateTimeInput < SimpleForm::Inputs::Base

  def input
    @builder.text_field(attribute_name, input_html_options)
  end

end
