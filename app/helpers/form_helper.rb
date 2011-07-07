# encoding: utf-8
#

# Helpers for form functionality.
module FormHelper

  # Renders an entity information form.
  #
  # @param [ Mongoid::Document ] entity The instance of the entity to build a
  #   form for.
  def entity_info_form(entity, &block)
    actual_entity = entity.is_a?(Array) ? entity.last : entity
    css_classes = ['entity-info']
    css_classes << 'in-editing' if actual_entity.new_record? || params[:editor] == 'true'
    simple_form_for entity, remote: true, html: { class: css_classes.join(' ') }, &block
  end

  # Render a template for a set of dynamic fields.
  #
  # @param [ FormBuilder ] builder The form builder used to render the form for
  #   the model.
  # @param [ Symbol ] association The name of the association on the model to
  #   render a dynamic field template for.
  #
  # @return [ String ] The HTML template for the association.
  def form_template(builder, association, options = {})

    # Set some options.
    options[:object] ||= builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= "#{association.to_s}/field"
    options[:form_builder_local] ||= :form

    template = builder.simple_fields_for(association, options[:object], child_index: "new_#{association.to_s}") do |form|
      render(partial: options[:partial], locals: { options[:form_builder_local] => form })
    end

    content_tag(:script, template, :'data-association' => association.to_s, type: 'text/html')

  end

end
