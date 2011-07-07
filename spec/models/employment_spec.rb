require 'spec_helper'

describe Employment do
  describe '#attributes' do
    it { should have_field(:title).of_type(String).with_default_value_of(nil) }
    it { should have_field(:since).of_type(Date).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:person) }
    it { should belong_to(:organization) }
  end

  describe '#validations' do
    it { should validate_presence_of(:organization) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:organization) }
    it { should allow_mass_assignment_of(:organization_id) }
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:since) }
  end
end
