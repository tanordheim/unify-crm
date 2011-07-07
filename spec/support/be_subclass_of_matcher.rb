# encoding: utf-8
#

RSpec::Matchers.define :be_subclass_of do |super_class|

  match do |subject|
    subject.class.superclass.name == super_class.name
  end

  failure_message_for_should do |subject|
    "expected #{subject.class.name} to be a subclass of #{super_class.name}"
  end

  failure_message_for_should_not do |subject|
    "expected #{subject.class.name} to not be a subclass of #{super_class.name}"
  end

  description do
    "be a subclass of #{super_class.name}"
  end

end
