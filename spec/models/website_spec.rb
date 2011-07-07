# encoding: utf-8
#

require 'spec_helper'

describe Website do
  describe '#attributes' do
    it { should have_field(:location).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:url).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:websiteable) }
  end

  describe '#validations' do
    it { should validate_presence_of(:location) }
    it { should validate_inclusion_of(:location).to_allow(Website::LOCATIONS.keys.map(&:to_i)) }
    it { should validate_presence_of(:url) }
    it { should validate_format_of(:url).to_allow('http://example.com') }
    it { should validate_format_of(:url).to_allow('http://example.com/example.html') }
    it { should validate_format_of(:url).to_allow('https://example.com') }
    it { should validate_format_of(:url).to_allow('https://example.com/example.html') }
    it { should validate_format_of(:url).not_to_allow('htt://example.com') }
    it { should validate_format_of(:url).not_to_allow('htt://example.com/example.html') }
    it { should validate_format_of(:url).not_to_allow('totally invalid url') }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:location) }
    it { should allow_mass_assignment_of(:url) }
  end
end
