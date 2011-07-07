# encoding: utf-8
#

require 'spec_helper'

describe Person do
  describe '#attributes' do
    it { should be_subclass_of(Contact) }
    it { should have_field(:first_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:last_name).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should embed_many(:employments) }
    it { should accept_nested_attributes_for(:employments) }
    it { should have_many(:deals).with_dependent(:destroy) }
  end

  describe '#validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:first_name) }
    it { should allow_mass_assignment_of(:last_name) }
    it { should allow_mass_assignment_of(:employments_attributes) }
  end
  
  context '#merging first name and last name into name' do
    it 'should merge when both first and last name is present' do
      p = Fabricate.build(:person, first_name: 'First', last_name: 'Last')
      p.valid?
      p.name.should == 'First Last'
    end

    it 'should merge when only first name is present' do
      p = Fabricate.build(:person, first_name: 'First', last_name: nil)
      p.valid?
      p.name.should == 'First'
    end

    it 'should merge when only last name is present' do
      p = Fabricate.build(:person, first_name: nil, last_name: 'Last')
      p.valid?
      p.name.should == 'Last'
    end
  end

  describe '#sequence' do
    let(:instance) { Fabricate(:instance) }
    let(:person) { Fabricate(:person, instance: instance) }

    it 'should assign a sequence' do
      person.identifier.should == 10000
    end
  end
end
