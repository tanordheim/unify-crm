# encoding: utf-8
#

# Determines how responses are handled for the RESTful APIs.
class ApiResponder < ActionController::Responder

  # Checks whether the resource responds to the current format or not.
  #
  # @return [ TrueClass, FalseClass ] True if the resource responds to the
  #   current format, false otherwise.
  def resourceful?
    super || Presenter.has_presenter_for?(resource, format)
  end

  # Always return nil as the api location to prevent respond_with on
  # POST/PUT/DELETE actions attempting to redirect to the resource.
  # 
  # @return [ String ] The api location for the current action.
  def api_location
    nil
  end

end
