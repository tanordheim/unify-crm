# encoding: utf-8
#

Fabricator(:model_sequence) do
  model_class { sequence(:model_class) { |i| "ModelClass_#{i}" } }

  # If no sequenceable is assigned to the model sequence, associate it with an
  # instance.
  after_build do |model_sequence|
    if model_sequence.sequenceable.blank?
      model_sequence.sequenceable = Fabricate(:instance)
    end
  end
end
