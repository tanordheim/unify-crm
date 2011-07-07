# encoding: utf-8
#

# This is a percentage input for SimpleForm that shows a percentage field as a
# slider.
class PercentageInput < SimpleForm::Inputs::Base

  def input
    slider_id = [@builder.object.class.name.underscore, attribute_name, 'slider'].join('_')
    [
      @builder.template.content_tag(:span, '', class: 'percentage-slider', id: slider_id),
      @builder.template.content_tag(:span, '', class: 'percentage-value'),
      @builder.hidden_field(attribute_name, input_html_options)
    ].join('').html_safe
  end

end
