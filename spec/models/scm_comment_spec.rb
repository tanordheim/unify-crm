# encoding: utf-8
#

require 'spec_helper'

describe ScmComment do
  describe '#attributes' do
    it { should have_field(:scm).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:repository).of_type(String).with_default_value_of(nil) }
    it { should have_field(:reference).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should embed_many(:files) }
  end

  describe '#validations' do
    it { should validate_presence_of(:scm) }
    it { should validate_inclusion_of(:scm).to_allow(ScmComment::SCMS.keys.map(&:to_i)) }
    it { should validate_presence_of(:repository) }
    it { should validate_presence_of(:reference) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:scm) }
    it { should allow_mass_assignment_of(:repository) }
    it { should allow_mass_assignment_of(:reference) }
  end
end
