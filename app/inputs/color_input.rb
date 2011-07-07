# encoding: utf-8
#

# Color palette input field.
class ColorInput < SimpleForm::Inputs::Base

  def input
    @builder.text_field(attribute_name, input_html_options)
  end

end
