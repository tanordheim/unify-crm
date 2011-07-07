# encoding: utf-8
#

require 'spec_helper'

describe Account do
  describe '#attributes' do
    it { should have_field(:number).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:type).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:balance).of_type(Float).with_default_value_of(0.0) }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:tax_code) }
    it { should have_many(:products) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number).scoped_to(:instance_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type).to_allow(Account::TYPES.keys.map(&:to_i)) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:tax_code) }
    it { should allow_mass_assignment_of(:tax_code_id) }
    it { should allow_mass_assignment_of(:number) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:type) }
    it { should_not allow_mass_assignment_of(:balance) }
  end
end
