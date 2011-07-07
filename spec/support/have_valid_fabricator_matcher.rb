# encoding: utf-8
#

RSpec::Matchers.define :have_valid_fabricator do |fabricator_name|

  match do |subject|
    name = fabricator_name.blank? ? subject.class.name.underscore.to_sym : fabricator_name
    Fabricate(name).new_record? == false
  end

  failure_message_for_should do |subject|
    "expected #{subject.class.name} to have a valid fabricator"
  end

  failure_message_for_should_not do |subject|
    "expected #{subject.class.name} not to have a valid fabricator"
  end

  description do
    "have a valid fabricator"
  end

end
