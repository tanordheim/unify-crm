# encoding: utf-8
#

# Helpers for the Category model class.
module CategoryHelper

  # Returns the label for a category.
  #
  # @param [ Category ] category The category to return label for.
  #
  # @return [ String ] The DOM element for the category, or nil if the category
  #   was blank.
  def category_label(category, *args)

    return nil if category.blank?

    options = args.extract_options!
    options[:label] ||= category.name
    content_tag(:span, options[:label], style: "background-color: #{category.color};", class: 'label')

  end

  # Returns a collection of locations for an email address in a format ready to
  # use in a collection input element.
  def email_address_location_collection
    EmailAddress::LOCATIONS.keys.sort.map do |location|
      [I18n.t("email_addresses.location.#{EmailAddress::LOCATIONS[location]}"), location]
    end
  end

end
