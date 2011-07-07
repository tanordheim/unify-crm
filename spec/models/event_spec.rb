# encoding: utf-8
#

require 'spec_helper'

describe Event do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:starts_at).of_type(DateTime).with_default_value_of(nil) }
    it { should have_field(:ends_at).of_type(DateTime).with_default_value_of(nil) }
    it { should have_field(:all_day).of_type(Boolean).with_default_value_of(false) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should embed_many(:assignees) }
    it { should accept_nested_attributes_for(:assignees) }
    it { should embed_many(:external_attendees) }
    it { should accept_nested_attributes_for(:external_attendees) }
    it { should belong_to(:category) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:assignees) }
    it { should validate_presence_of(:starts_at) }
    it { should validate_presence_of(:ends_at) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:category) }
    it { should allow_mass_assignment_of(:category_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:assignees_attributes) }
    it { should allow_mass_assignment_of(:external_attendees_attributes) }
    it { should allow_mass_assignment_of(:starts_at) }
    it { should allow_mass_assignment_of(:ends_at) }
    it { should allow_mass_assignment_of(:all_day) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe '#all day-flag' do
    let(:short_event) { Fabricate(:event, starts_at: DateTime.now.beginning_of_day + 10.hours, ends_at: DateTime.now.beginning_of_day + 11.hours, all_day: false) }
    let(:long_event) { Fabricate(:event, starts_at: DateTime.now.beginning_of_day + 10.hours, ends_at: DateTime.now.beginning_of_day + 49.hours, all_day: false) }

    it 'should leave all day-flag as-is when the event does not span multiple days' do
      short_event.all_day.should == false
    end

    it 'should set all day-flag to true if the event spans multiple days' do
      long_event.all_day.should == true
    end
  end
end
