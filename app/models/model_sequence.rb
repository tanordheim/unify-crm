# encoding: utf-8
#

# Defines a sequential ID series for an entity type within an instance. This
# allows us to have numbered sequences for each data type scoped to each
# instance in addition to the object id provided by Mongoid.
class ModelSequence

  # Model sequences are Mongoid documents.
  include Mongoid::Document

  # Define the fields for the model sequence.
  field :model_class, type: String
  field :current_value, type: Integer, default: 0

  # Model sequences can be embedded as a polymorphic association named
  # 'sequenceable' using the :as option on the embeds_many directive.
  embedded_in :sequenceable, polymorphic: true
  
  # Protect the ID attribute from mass assignment.
  attr_protected :id, :_id

  # Protect the sequenceable attributes from mass assignment.
  attr_protected :sequenceable, :sequenceable_type, :sequenceable_id

  # Validate that the model sequence has a model class set, and that the model
  # class is unique for this instance. Also, protect the model_class attribute
  # from mass assignment.
  validates :model_class, presence: true, uniqueness: { case_sensitive: false }
  attr_protected :model_class

  # Protect the current_value attribute from mass assignment.
  attr_protected :current_value

  # Increment the sequence by 1 and return the current value.
  #
  # This returns the value of current_value as it looks before incrementing it.
  #
  # @return [ Integer ] The current value of the sequence.
  def increment!
    inc(:current_value, 1)
  end

end
