# encoding: utf-8
#

require 'spec_helper'

describe TaxCode do
  describe '#attributes' do
    it { should have_field(:code).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:percentage).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:target_account) }
    it { should have_many(:accounts) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:target_account) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code).scoped_to(:instance_id) }
    it { should validate_presence_of(:percentage) }
    it { should validate_inclusion_of(:percentage).to_allow((0..100).to_a) }
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
    it { should allow_mass_assignment_of(:target_account) }
    it { should allow_mass_assignment_of(:target_account_id) }
    it { should allow_mass_assignment_of(:code) }
    it { should allow_mass_assignment_of(:percentage) }
    it { should allow_mass_assignment_of(:name) }
  end
end
