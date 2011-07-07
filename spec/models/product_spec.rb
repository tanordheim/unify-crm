# encoding: utf-8
#

require 'spec_helper'

describe Product do
  describe '#attributes' do
    it { should have_field(:key).of_type(String).with_default_value_of(nil) }
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:price).of_type(Float).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:account) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key).scoped_to(:instance_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:account) }
    it { should allow_mass_assignment_of(:account_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:price) }
  end
end
