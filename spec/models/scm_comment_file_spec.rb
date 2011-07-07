# encoding: utf-8
#

require 'spec_helper'

describe ScmCommentFile do
  describe '#attributes' do
    it { should have_field(:action).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:path).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:scm_comment).as_inverse_of(:files) }
  end

  describe '#validations' do
    it { should validate_presence_of(:action) }
    it { should validate_inclusion_of(:action).to_allow(ScmCommentFile::ACTIONS.keys.map(&:to_i)) }
    it { should validate_presence_of(:path) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:action) }
    it { should allow_mass_assignment_of(:path) }
  end
end
