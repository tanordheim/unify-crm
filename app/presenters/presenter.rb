# encoding: utf-8
#

# Define the module for the presenters for API version 1.
module API_V1; end;

# This is the base class for all presenters, regardless of format.
class Presenter

  # Checks if a presenter is available for the specified resource in the given
  # format.
  #
  # @param [ Object ] resource The resource to determine presenter for.
  # @param [ Symbol ] format The format to determine presenter for.
  #
  # @return [ TrueClass, FalseClass ] True if a presenter exists for the
  #   resource and format combination, false otherwise.
  def self.has_presenter_for?(resource, format)
    presenter_class_for(resource, format) ? true : false
  end

  # Returns the presenter to use for the specified resource and format.
  #
  # @param [ Object ] resource The resource to determine presenter for.
  # @param [ Symbol ] format The format to determine presenter for.
  #
  # @return [ Presenter ] A presenter for the resource and format combination,
  #   or nil if no presenter could be found.
  def self.presenter_for(resource, format)
    presenter_class_for(resource, format)
  end

  # Builds the presentation of the current resource.
  #
  # @param [ Object ] resource The resource to present.
  # 
  # @return [ Object ] The presented version of the resource.
  def self.present(resource)
    presenter = new(resource)
    presenter.present
  end
  
  # Initializes a new presenter instance, and assigns the resource that we need
  # to present.
  #
  # @param [ Object ] resource The resource to present.
  def initialize(resource)
    @resource = resource
  end

  # Builds the presentation of the current resource.
  #
  # If the current resource is a collection, it gets rendered by the
  # present_collection method. If its a single object, it gets rendered by the
  # present_singular method.
  #
  # @return [ Object ] The presented version of the resource.
  def present
    resource.is_a?(Mongoid::Criteria) || resource.is_a?(Array) ? present_collection : present_singular
  end

  protected
  
  # Returns the resource that we need to present.
  #
  # @return [ Object ] The object we're asked to present, define when the
  #   presenter is initialized.
  def resource
    @resource
  end

  # Compact a hash, removing all keys that have nil values.
  #
  # @param [ Hash ] hash The hash to compact.
  #
  # @return [ Hash ] The input hash with all keys having nil-values removed.
  def compact_hash(hash)
    hash.delete_if { |key, value| value.blank? }
  end

  # Presents the current resource as a collection.
  #
  # This should be overridden in subclasses.
  #
  # @param [ Object ] collection The collection to render - defaults to
  #   +resource+.
  #
  # @return [ Object ] The presented resource.
  def present_collection(collection = resource); nil; end
  
  # Presents the current resource as a singular object.
  #
  # This should be overridden in subclasses.
  #
  # @param [ Object ] object The object to render - defaults to +resource+.
  #
  # @return [ Object ] The presented resource.
  def present_singular(object); nil; end

  private

  # Determines the presenter class for the specified resource and format.
  #
  # This will prepend the format as the module name and append Presenter to the
  # resource name, for example:
  # (<#Node id: 1>, :api_v1) => API_V1::NodePresenter
  #
  # @param [ Object ] resource The resource to determine presenter class for.
  # @param [ Symbol ] format The format to determine presenter class for.
  #
  # @return [ Class ] The class that should be used for presenting the resource
  #   and format combination, or nil if no presenter class was found.
  def self.presenter_class_for(resource, format)
    namespace_for(format).const_get(presenter_name_for(resource))
  rescue NameError => e
    raise if e.is_a?(NoMethodError)
    nil
  end

  # Returns the module namespace for the presenter based on the format.
  #
  # @param [ Object ] format The format to determine module namespace for.
  #
  # @return [ Object ] The module namespace for the format, or nil if no module
  #   namespace could be identified.
  def self.namespace_for(format)
    Object.const_get(format.to_s.upcase)
  end

  # Returns the name of the class that should handle the presentation of the
  # specified resource.
  #
  # @param [ Object ] resource The resource to determine presenter class for.
  #
  # @return [ String ] The class name of the presenter that should handle
  #   presenting the resource.
  def self.presenter_name_for(resource)

    resource_class = if resource.is_a?(Mongoid::Criteria)
      resource.klass.name
    elsif resource.is_a?(Array) && !resource.empty?
      resource.first.class.name
    elsif resource.is_a?(ActiveModel::Errors)
      resource_class = 'ActiveModelErrors'
    else
      resource.class.name
    end

    # If the resource class has a module, then use its super class.
    if resource_class =~ /::/
      resource_class = resource_class.constantize.superclass.name
    end

    # Append 'Presenter' to the class name and use that as the presenter class
    # name.
    resource_class + 'Presenter'

  end

end
