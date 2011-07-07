# encoding: utf-8
#

require 'spec_helper'

describe InstanceOrganization do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:street_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:zip_code).of_type(String).with_default_value_of(nil) }
    it { should have_field(:city).of_type(String).with_default_value_of(nil) }
    it { should have_field(:country).of_type(String).with_default_value_of(nil) }
    it { should have_field(:vat_number).of_type(String).with_default_value_of(nil) }
    it { should have_field(:bank_account_number).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:instance).as_inverse_of(:organization) }
  end

  describe '#validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:street_name) }
    it { should allow_mass_assignment_of(:zip_code) }
    it { should allow_mass_assignment_of(:city) }
    it { should allow_mass_assignment_of(:country) }
    it { should allow_mass_assignment_of(:vat_number) }
    it { should allow_mass_assignment_of(:bank_account_number) }
  end
end
