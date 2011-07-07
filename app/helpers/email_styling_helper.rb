# encoding: utf-8
#

# Helpers for styling e-mails.
module EmailStylingHelper

  FONT_FAMILY = '"Helvetica Neue", Helvetica, Arial, sans-serif'
  LINE_HEIGHT = '18px'
  FONT_COLOR = '#333333'
  FONT_SIZE = '13px'

  # Returns the CSS for the primary headers.
  #
  # @return [ String ] Primary header CSS.
  def email_primary_header_css
    email_css(
      "font-family: #{FONT_FAMILY}",
      "line-height: #{LINE_HEIGHT}",
      "color: #{FONT_COLOR}",
      'font-size: 30px',
      'font-weight: bold',
      'margin: 0 0 18px 0',
      'padding: 0 0 17px 0',
      'border-bottom: 1px solid #eeeeee'
    )
  end

  # Returns the CSS for the primary header subtexts.
  #
  # @return [ String ] Primary header subtext CSS.
  def email_primary_header_subtext_css
    email_css(
      "font-family: #{FONT_FAMILY}",
      "line-height: #{LINE_HEIGHT}",
      'font-size: 18px',
      'font-weight: normal',
      'color: #999999'
    )
  end

  # Returns the CSS for tables.
  #
  # @return [ String ] Table CSS.
  def email_table_css
    email_css(
      'width: 100%',
      'border-collapse: collapse',
      'border-spacing: 0',
      "font-family: #{FONT_FAMILY}",
      "font-size: #{FONT_SIZE}",
      "color: #{FONT_COLOR}"
    )
  end

  # Returns the CSS for a table header column.
  #
  # @return [ String ] Table header column CSS.
  def email_table_header_css
    email_css(
      'vertical-align: bottom',
      'font-weight: bold',
      'text-align: left',
      'padding: 8px',
      "line-height: #{LINE_HEIGHT}"
    )
  end

  # Returns the CSS for a table cell.
  #
  # @return [ String ] Table cell CSS.
  def email_table_cell_css
    email_css(
      'vertical-align: top',
      'padding: 8px',
      "line-height: #{LINE_HEIGHT}",
      'border-top: 1px solid #dddddd'
    )
  end

  # Returns the CSS for a small bold header.
  #
  # @return [ String ] Small bold header CSS.
  def email_bold_header_css
    email_css(
      'margin: 0',
      'padding: 0',
      "line-height: #{LINE_HEIGHT}",
      "font-size: #{FONT_SIZE}",
      "color: #{FONT_COLOR}"
    )
  end

  # Returns the CSS for muted text.
  #
  # @return [ String ] Muted text CSS.
  def email_muted_text_css
    email_css(
      'color: #999999'
    )
  end

  # Returns the CSS for labels.
  #
  # @return [ String ] Label CSS.
  def email_label_css
    email_css(
      "font-family: #{FONT_FAMILY}",
      "line-height: #{LINE_HEIGHT}",
      'padding: 2px 4px 3px',
      'font-size: 11px',
      'font-weight: bold',
      'color: #ffffff',
      'text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25)'
    )
  end

  # Returns the CSS for paragraphs.
  #
  # @return [ String ] Paragraph CSS.
  def email_paragraph_css
    email_css(
      "font-family: #{FONT_FAMILY}",
      "line-height: #{LINE_HEIGHT}",
      "font-size: #{FONT_SIZE}",
      "color: #{FONT_COLOR}",
      'padding: 0',
      'margin: 0 0 17px 0'
    )
  end

  private

  # Returns an array of CSS attributes as a string.
  #
  # @param [ Array ] css The array of CSS attributes.
  #
  # @return [ String ] The array of CSS attributes converted into a string.
  def email_css(*args)
    args.join('; ') + ';'
  end

end
