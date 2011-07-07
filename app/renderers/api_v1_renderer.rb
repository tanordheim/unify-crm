# encoding: utf-8
#

# Describe how requests for version 1 of the REST API will be rendered.
ActionController::Renderers.add(:api_v1) do |resource, options|
  self.content_type = Mime::API_V1
  presenter = Presenter.presenter_for(resource, :api_v1)
  presented_resource = presenter ? presenter.present(resource) : resource
  render options.merge(:json => presented_resource)
end
