# encoding: utf-8
#

require 'spec_helper'

describe ProjectCategory do
  describe '#attributes' do
    it { should be_subclass_of(Category) }
  end

  describe '#associations' do
    it { should have_many(:projects).as_inverse_of(:category).with_dependent(:nullify) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end
end
