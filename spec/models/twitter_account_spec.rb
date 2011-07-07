# encoding: utf-8
#

require 'spec_helper'

describe TwitterAccount do
  describe '#attributes' do
    it { should have_field(:location).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:username).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:tweetable) }
  end

  describe '#validations' do
    it { should validate_presence_of(:location) }
    it { should validate_inclusion_of(:location).to_allow(TwitterAccount::LOCATIONS.keys.map(&:to_i)) }
    it { should validate_presence_of(:username) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:location) }
    it { should allow_mass_assignment_of(:username) }
  end
end
