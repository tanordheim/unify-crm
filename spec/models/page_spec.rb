# encoding: utf-8
#

require 'spec_helper'

describe Page do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:body).of_type(String).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:project) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:project) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:body) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should_not allow_mass_assignment_of(:project) }
    it { should_not allow_mass_assignment_of(:project_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:body) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end
end
