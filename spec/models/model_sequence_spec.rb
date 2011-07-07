# encoding: utf-8
#

require 'spec_helper'

describe ModelSequence do
  describe '#attributes' do
    it { should have_field(:model_class).of_type(String).with_default_value_of(nil) }
    it { should have_field(:current_value).of_type(Integer).with_default_value_of(0) }
  end

  describe '#associations' do
    it { should be_embedded_in(:sequenceable) }
  end

  describe '#validations' do
    it { should validate_presence_of(:model_class) }
    it { should validate_uniqueness_of(:model_class).case_insensitive }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:sequenceable) }
    it { should_not allow_mass_assignment_of(:sequenceable_type) }
    it { should_not allow_mass_assignment_of(:sequenceable_id) }
  end

  describe '#incrementing' do
    let(:sequence) { Fabricate(:model_sequence) }

    it 'should increment by 1' do
      sequence.increment!.should == 1
      sequence.current_value.should == 1
      sequence.increment!.should == 2
      sequence.current_value.should == 2
    end

    it 'should remember the new value' do
      sequence.increment!
      sequence.reload
      sequence.current_value.should == 1
    end
  end
end
