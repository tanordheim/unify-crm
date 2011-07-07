# encoding: utf-8
#

require 'spec_helper'

describe Comment do
  describe '#attributes' do
    it { should have_field(:body).of_type(String).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:commentable) }
    it { should validate_presence_of(:user) }
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
    it { should allow_mass_assignment_of(:commentable) }
    it { should allow_mass_assignment_of(:commentable_id) }
    it { should allow_mass_assignment_of(:commentable_type) }
    it { should allow_mass_assignment_of(:user) }
    it { should allow_mass_assignment_of(:user_id) }
    it { should allow_mass_assignment_of(:body) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end
end
