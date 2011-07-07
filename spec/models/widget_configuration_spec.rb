# encoding: utf-8
#

require 'spec_helper'

describe WidgetConfiguration do
  describe '#attributes' do
    it { should have_field(:type).of_type(Symbol).with_default_value_of(nil) }
    it { should have_field(:column).of_type(Integer).with_default_value_of(0) }
  end

  describe '#associations' do
    it { should be_embedded_in(:user) }
  end

  describe '#validations' do
    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type).to_allow(WidgetConfiguration::TYPES) }
    it { should validate_presence_of(:column) }
    it { should validate_inclusion_of(:column).to_allow(WidgetConfiguration::COLUMNS) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:type) }
    it { should allow_mass_assignment_of(:column) }
  end

  describe '#widget id' do
    let(:widget_configuration) { Fabricate.build(:widget_configuration, type: :my_tickets) }

    it 'should generate a unique widget id for the widget configuration' do
      widget_configuration.widget_id.should == "my_tickets_#{widget_configuration.id.to_s}"
    end
  end
end
