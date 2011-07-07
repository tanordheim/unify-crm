# encoding: utf-8
#

require 'spec_helper'

describe Source do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should have_many(:contacts) }
    it { should have_many(:deals) }
    it { should have_many(:projects) }
    pending 'Add dependent: restrict on sources'
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:name) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:name) }
  end
end
