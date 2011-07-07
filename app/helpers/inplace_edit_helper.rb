# encoding: utf-8
#

# Helpers for in-place editing of model data.
module InplaceEditHelper

  # Render a inplace editable block.
  #
  # @param [ Mongoid::Document ] model The model that should be inplace edited.
  # @param [ Symbol ] attribute The name of an attribute that should be modified
  #   by the inline editable.
  #
  # @return [ String ] The DOM of the inplace editable block.
  def inplace_editable(model, *args)

    if args.length == 2
      attribute = args[0]
      options = args[1]
    else
      attribute = nil
      options = args.extract_options!
    end

    form_partial = options.delete(:form_partial)
    view_partial = options.delete(:view_partial)

    if !form_partial.blank? && !view_partial.blank?
      inplace_editable_from_partials(model, form_partial, view_partial, options)
    else
      inplace_editable_from_attribute(model, attribute, options)
    end

  end

  private

  # Renders an inplace editable block for a specific attribute.
  #
  # @param [ Mongoid::Document ] model The model that should be inplace edited.
  # @param [ Symbol ] attribute The attribute that should be changed with this
  #   inline editable block.
  #
  # @return [ String ] The DOM of the inplace editable block.
  def inplace_editable_from_attribute(model, attribute, options)

    # Set some defaults.
    options[:type] ||= 'text'
    options[:collection] ||= []
    options[:display_with] ||= :inplace_editable_default_display_with

    # If the attribute is an _id-attribute, use the actual association object
    # for display purpoases.
    display_attribute = (attribute.to_s =~ /_id$/ ? attribute.to_s.gsub(/_id$/, '') : attribute.to_s).to_sym

    # Delegate building the form input to the appropriate method.
    field_type = options.delete(:type)
    view = content_tag(:span, send(options[:display_with], model.send(display_attribute)), class: 'inplace-editable-view', :'data-toggle' => 'inplace-editable')
    edit = send(:"inplace_editable_#{field_type}_form", model, attribute, options)

    # Render the DOM element.
    content_tag(:span, view + edit, class: 'inplace-editable', :'data-model' => model.class.name.underscore, :'data-model-id' => model.id.to_s, :'data-model-url' => url_for(model), :'data-attribute' => attribute.to_s, :'data-editable-id' => SecureRandom.hex(16))

  end

  # The default "display_with", this only returns the value passed in.
  #
  # @param [ String ] value The input value.
  #
  # @return [ String ] Returns the input value as-is.
  def inplace_editable_default_display_with(value); value; end

  # Render a inplace editable block using predefined partials.
  #
  # @param [ Mongoid::Document ] model The model that should be inplace edited.
  # @param [ String ] form_partial The form partial to use for generating the
  #   form.
  # @param [ String ] view_partial The view partial to use for generating the
  #   form.
  #
  # @return [ String ] The DOM of the inplace editable block.
  def inplace_editable_from_partials(model, form_partial, view_partial, options)
    view = content_tag(:span, render(partial: view_partial, locals: { model: model }), class: 'inplace-editable-view')
    edit = content_tag(:span, render(partial: form_partial, locals: { model: model }), class: 'inplace-editable-form')
    content_tag(:span, view + edit, class: 'inplace-editable', :'data-model' => model.class.name.underscore, :'data-model-id' => model.id.to_s, :'data-model-url' => url_for(model), :'data-view-partial' => view_partial, :'data-editable-id' => SecureRandom.hex(16))
  end

end
