# encoding: utf-8
#

require 'spec_helper'

describe DealStage do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:percent).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:color).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should have_many(:deals) }
    pending 'Add dependent: restrict on deals'
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:percent) }
    it { should validate_inclusion_of(:percent).to_allow((0..100).to_a) }
    it { should validate_uniqueness_of(:percent).scoped_to(:instance_id) }
    it { should validate_presence_of(:color) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:percent) }
    it { should allow_mass_assignment_of(:color) }
  end
end
