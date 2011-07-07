# encoding: utf-8
#

require 'spec_helper'

describe OrganizationAccount do
  describe '#attributes' do
    it { should have_field(:type).of_type(Integer).with_default_value_of(0) }
  end

  describe '#associations' do
    it { should belong_to(:organization) }
  end

  describe '#validations' do
    it { should validate_presence_of(:organization) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:organization) }
    it { should_not allow_mass_assignment_of(:organization_id) }
    it { should_not allow_mass_assignment_of(:type) }
    it { should_not allow_mass_assignment_of(:number) }
  end
end
