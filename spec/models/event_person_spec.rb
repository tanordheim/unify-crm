# encoding: utf-8
#

require 'spec_helper'

describe EventPerson do
  describe '#attributes' do
  end

  describe '#associations' do
    it { should be_embedded_in(:event) }
    it { should belong_to(:person) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:person) }
    it { should validate_uniqueness_of(:person) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:event) }
    it { should_not allow_mass_assignment_of(:event_id) }
    it { should allow_mass_assignment_of(:person) }
    it { should allow_mass_assignment_of(:person_id) }
  end
end
