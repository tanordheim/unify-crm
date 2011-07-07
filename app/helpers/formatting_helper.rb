# encoding: utf-8
#

# Helpers for text formatting.
module FormattingHelper

  # Format text as a comment or description.
  #
  # @param [ String ] text The text to format.
  #
  # @return [ String ] The formatted text.
  def format_comment_text(text)
    
    # Convert newlines to breaks.
    formatted = newline_to_br(text)

    # Auto-link URLs in the text.
    formatted = auto_link(formatted)

    # Return the formatted text.
    formatted

  end
  def format_description_text(text); format_comment_text(text); end

  # Convert newlines in a text block to break tags.
  #
  # @param [ String ] text The text to convert.
  #
  # @return [ String ] The converted text.
  def newline_to_br(text)
    text = '' if text.nil?
    text = text.dup
    text = sanitize(text)
    text.gsub!(/\r\n?/, "\n") # \r\n and \r -> \n
    text.gsub!(/\n/, '<br>')
    text.html_safe
  end

end
