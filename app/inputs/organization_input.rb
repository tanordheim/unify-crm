# encoding: utf-8
#

# This is an organization input for SimpleForm that allows the user to type to
# find organizations registered in the database.
class OrganizationInput < SimpleForm::Inputs::Base

  def input

    # Build the hidden field containing the actual value.
    hidden_field = @builder.hidden_field(attribute_name)

    # Build the field containing the name of the organization.
    default_value = if @builder.object.respond_to?(:organization) && !@builder.object.send(:organization).blank?
      @builder.object.send(:organization).name
    else
      ''
    end
    label_field = @builder.template.text_field_tag(:"#{attribute_name}_label", default_value, input_html_options.merge(:'data-autocompletion-source' => '/organizations/typeahead'))

    [hidden_field, label_field].join('').html_safe

  end

end
