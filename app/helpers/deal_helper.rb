# encoding: utf-8
#

# Helpers for the Deal model class.
module DealHelper

  # Returns the value of a deal in pure text format.
  #
  # @param [ Deal ] deal The deal to find value of.
  #
  # @return [ String ] The value of the deal in text format.
  def deal_value_details(deal)

    text = ''
    unless deal.price_type_name == :fixed
      if deal.duration.blank? || deal.duration == 0
        text = I18n.t("deals.value.#{deal.price_type_name.to_s}", price: format_currency(deal.price))
      else
        text = I18n.t("deals.value.#{deal.price_type_name.to_s}_with_duration", price: format_currency(deal.price), duration: deal.duration)
      end
    end

    text.blank? ? nil : content_tag(:small, text, class: 'muted')

  end

  # Returns a collection of price types for a deal in a format ready to use in a
  # collection input element.
  def deal_price_type_collection
    Deal::PRICE_TYPES.keys.sort.map do |price_type|
      [I18n.t("deals.price_types.#{Deal::PRICE_TYPES[price_type]}"), price_type]
    end
  end

  # Returns the label for a deal stage.
  #
  # @param [ DealStage ] stage The stage to return label for.
  #
  # @return [ String ] The DOM element for the stage, or nil if the stage was
  #   blank.
  def deal_stage_label(stage)
    return nil if stage.blank?
    content_tag(:span, stage.name, style: "background-color: #{stage.color};", class: 'label')
  end
  
end
