# encoding: utf-8
#

# This is an person input for SimpleForm that allows the user to type to find
# people registered in the database.
class PersonInput < SimpleForm::Inputs::Base

  def input

    # Build the hidden field containing the actual value.
    hidden_field = @builder.hidden_field(attribute_name)

    # Build the field containing the name of the person.
    default_value = if @builder.object.respond_to?(:person) && !@builder.object.send(:person).blank?
      @builder.object.send(:person).name
    else
      ''
    end
    label_field = @builder.template.text_field_tag(:"#{attribute_name}_label", default_value, input_html_options.merge(:'data-autocompletion-source' => '/people/typeahead'))

    [hidden_field, label_field].join('').html_safe

  end

end
