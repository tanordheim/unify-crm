# encoding: utf-8
#

require 'spec_helper'

describe Organization do
  describe '#attributes' do
    it { should be_subclass_of(Contact) }
    it { should have_field(:identifier).of_type(Integer) }
  end

  describe '#associations' do
    it { should have_many(:deals).with_dependent(:destroy) }
    it { should have_one(:organization_account).with_dependent(:destroy) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:name) }
  end

  describe '#sequence' do
    let(:instance) { Fabricate(:instance) }
    let(:organization) { Fabricate(:organization, instance: instance) }

    it 'should assign a sequence' do
      organization.identifier.should == 10000
    end
  end

  describe '#employees' do
    let(:instance) { Fabricate(:instance) }

    let(:organization_1) { Fabricate(:organization, instance: instance) }
    let(:organization_2) { Fabricate(:organization, instance: instance) }
    let(:organization_3) { Fabricate(:organization, instance: instance) }

    let(:person_1) do
      p = Fabricate.build(:person, instance: instance)
      Fabricate.build(:employment, person: p, organization: organization_2)
      p.save!
      p
    end

    let(:person_2) do
      p = Fabricate.build(:person, instance: instance)
      Fabricate.build(:employment, person: p, organization: organization_1)
      Fabricate.build(:employment, person: p, organization: organization_2)
      p.save!
      p
    end

    # Preload the people
    before(:each) { person_1 && person_2 }

    it 'should have one employee for the first organization' do
      organization_1.employees.length.should == 1
      organization_1.employees.map(&:id).should == [person_2.id]
    end

    it 'should have two employees for the second organization' do
      organization_2.employees.length.should == 2
      organization_2.employees.map(&:id).should include(person_1.id)
      organization_2.employees.map(&:id).should include(person_2.id)
    end

    it 'should have no employees for the third organization' do
      organization_3.employees.length.should == 0
    end
  end

  describe '#all comments' do
    let(:instance) { Fabricate(:instance) }

    let(:organization) { Fabricate(:organization, instance: instance) }
    let(:other_organization) { Fabricate(:organization, instance: instance) }

    let(:person_1) do
      p = Fabricate(:person, instance: instance)
      Fabricate(:employment, person: p, organization: organization)
      p
    end
    let(:person_2) do
      p = Fabricate(:person, instance: instance)
      Fabricate(:employment, person: p, organization: organization)
      p
    end
    let(:other_person) do
      p = Fabricate(:person, instance: instance)
      Fabricate(:employment, person: p, organization: other_organization)
      p
    end

    let(:deal_1) { Fabricate(:deal, instance: instance, organization: organization) }
    let(:deal_2) { Fabricate(:deal, instance: instance, organization: organization) }
    let(:other_deal) { Fabricate(:deal, instance: instance, organization: other_organization) }

    it 'should include the comments for the organization itself' do
      Fabricate(:comment, instance: instance, commentable: organization)
      organization.all_comments.size.should == 1
    end

    it 'should not include comments made for other organizations' do
      Fabricate(:comment, instance: instance, commentable: other_organization)
      organization.all_comments.size.should == 0
    end

    it 'should include comments made on an employee' do
      Fabricate(:comment, instance: instance, commentable: person_1)
      organization.all_comments.size.should == 1
    end

    it 'should include comments made on all employees' do
      Fabricate(:comment, instance: instance, commentable: person_1)
      Fabricate(:comment, instance: instance, commentable: person_2)
      organization.all_comments.size.should == 2
    end

    it 'should not include comments made on non-employees' do
      Fabricate(:comment, instance: instance, commentable: other_person)
      organization.all_comments.size.should == 0
    end

    it 'should include the comments made on deals' do
      Fabricate(:comment, instance: instance, commentable: deal_1)
      organization.all_comments.size.should == 1
    end

    it 'should include the comments made on all deals' do
      Fabricate(:comment, instance: instance, commentable: deal_1)
      Fabricate(:comment, instance: instance, commentable: deal_2)
      organization.all_comments.size.should == 2
    end

    it 'should not include the comments made on non-related deals' do
      Fabricate(:comment, instance: instance, commentable: other_deal)
      organization.all_comments.size.should == 0
    end
  end
end
