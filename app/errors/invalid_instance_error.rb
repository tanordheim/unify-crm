# encoding: utf-8
#

# Raised when an invalid instance is requested.
class InvalidInstanceError < StandardError

  # Instantiate a new error.
  #
  # @param [ String ] requested_instance The instance that was requested and
  #   caused the error.
  def initialize(requested_instance)
    super("Invalid instance: #{requested_instance}")
  end

end
