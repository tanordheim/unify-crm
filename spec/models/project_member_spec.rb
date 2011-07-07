# encoding: utf-8
#

require 'spec_helper'

describe ProjectMember do
  describe '#attributes' do
  end

  describe '#associations' do
    it { should be_embedded_in(:project) }
    it { should belong_to(:user) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:user) }
    it { should validate_uniqueness_of(:user) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:project) }
    it { should_not allow_mass_assignment_of(:project_id) }
    it { should allow_mass_assignment_of(:user) }
    it { should allow_mass_assignment_of(:user_id) }
  end
end
