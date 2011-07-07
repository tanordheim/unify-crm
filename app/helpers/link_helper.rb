# encoding: utf-8
#

# Helpers for linking to content.
module LinkHelper

  # Link to an e-mail address.
  # 
  # @param [ String ] address The e-mail address to link to.
  #
  # @return [ String ] The link to the e-mail address.
  def link_to_email(address)
    link_to address, "mailto:#{address}"
  end

end
