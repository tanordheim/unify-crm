# encoding: utf-8
#

require 'spec_helper'

describe Deal do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:price).of_type(Float).with_default_value_of(0.0) }
    it { should have_field(:price_type).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:duration).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:probability).of_type(Integer).with_default_value_of(50) }
    it { should have_field(:expecting_close_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:closed_on).of_type(Date).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:organization) }
    it { should belong_to(:person) }
    it { should belong_to(:stage) }
    it { should belong_to(:category) }
    it { should belong_to(:source) }
    it { should belong_to(:user) }
    it { should have_many(:comments).with_dependent(:destroy) }
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:stage) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:probability) }
    it { should validate_inclusion_of(:probability).to_allow((0..100).to_a) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:organization) }
    it { should allow_mass_assignment_of(:organization_id) }
    it { should allow_mass_assignment_of(:person) }
    it { should allow_mass_assignment_of(:person_id) }
    it { should allow_mass_assignment_of(:stage) }
    it { should allow_mass_assignment_of(:stage_id) }
    it { should allow_mass_assignment_of(:category) }
    it { should allow_mass_assignment_of(:category_id) }
    it { should allow_mass_assignment_of(:source) }
    it { should allow_mass_assignment_of(:source_id) }
    it { should allow_mass_assignment_of(:user) }
    it { should allow_mass_assignment_of(:user_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:price) }
    it { should allow_mass_assignment_of(:price_type) }
    it { should allow_mass_assignment_of(:duration) }
    it { should allow_mass_assignment_of(:probability) }
    it { should allow_mass_assignment_of(:expecting_close_on) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe '#sequence' do
    let(:instance) { Fabricate(:instance) }
    let(:deal) { Fabricate(:deal, instance: instance) }

    it 'should assign a sequence' do
      deal.identifier.should == 10000
    end
  end

  describe '#auto stage assignment' do
    let(:instance) { Fabricate(:instance) }

    let(:lost_stage) { Fabricate(:deal_stage, instance: instance, percent: 0) }
    let(:won_stage) { Fabricate(:deal_stage, instance: instance, percent: 100) }
    let(:presentation_stage) { Fabricate(:deal_stage, instance: instance, percent: 20) }
    let(:delivery_stage) { Fabricate(:deal_stage, instance: instance, percent: 75) }

    before(:each) do
      lost_stage && won_stage && presentation_stage && delivery_stage
    end

    it 'should assign the lowest possible stage when no stage is assigned' do
      Fabricate(:deal, instance: instance, stage: nil).stage_id.should == presentation_stage.id
    end
  end
  
  describe '#probabilities' do
    let(:won_stage) { Fabricate(:deal_stage, percent: 100) }
    let(:lost_stage) { Fabricate(:deal_stage, percent: 0) }
    let(:normal_stage) { Fabricate(:deal_stage, percent: 50) }

    it 'should set probability to 100% if the deal is won' do
      Fabricate(:deal, stage: won_stage, probability: 75).probability.should == 100
    end

    it 'should set probability to 0% if the deal is lost' do
      Fabricate(:deal, stage: lost_stage, probability: 75).probability.should == 0
    end

    it 'should not touch probability when using a normal stage' do
      Fabricate(:deal, stage: normal_stage, probability: 75).probability.should == 75
    end
  end

  describe '#price types' do
    it 'should set duration to nil if fixed price' do
      Fabricate(:deal, price: 100, price_type: Deal::PRICE_TYPES.key(:fixed), duration: 10).duration.should be_blank
    end

    it 'should keep duration for hourly price' do
      Fabricate(:deal, price: 100, price_type: Deal::PRICE_TYPES.key(:per_hour), duration: 10).duration.should == 10
    end

    it 'should keep duration for monthly price' do
      Fabricate(:deal, price: 100, price_type: Deal::PRICE_TYPES.key(:per_month), duration: 10).duration.should == 10
    end

    it 'should keep duration for yearly price' do
      Fabricate(:deal, price: 100, price_type: Deal::PRICE_TYPES.key(:per_year), duration: 10).duration.should == 10
    end
  end

  describe '#closed on' do
    let(:won_stage) { Fabricate(:deal_stage, percent: 100) }
    let(:lost_stage) { Fabricate(:deal_stage, percent: 0) }
    let(:normal_stage) { Fabricate(:deal_stage, percent: 50) }

    it 'should set closed_on when setting a won stage' do
      Fabricate(:deal, stage: won_stage).closed_on.should_not be_blank
    end

    it 'should set closed_on when setting a lost stage' do
      Fabricate(:deal, stage: lost_stage).closed_on.should_not be_blank
    end

    it 'should not set closed_on when setting a normal stage' do
      Fabricate(:deal, stage: normal_stage).closed_on.should be_blank
    end

    it 'should unset closed_on when changing from a closed to a non-closed stage' do
      d = Fabricate(:deal, stage: won_stage)
      d.stage = normal_stage
      d.save
      d.closed_on.should be_blank
    end
  end
end
