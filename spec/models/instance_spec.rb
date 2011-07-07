# encoding: utf-8
#

require 'spec_helper'

describe Instance do
  describe '#attributes' do
    it { should have_field(:subdomain).of_type(String).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should embed_one(:organization) }
    it { should accept_nested_attributes_for(:organization) }
    it { should embed_many(:model_sequences) }
    it { should have_many(:comments).with_dependent(:destroy) }
    it { should have_many(:categories).with_dependent(:destroy) }
    it { should have_many(:events).with_dependent(:destroy) }
    it { should have_many(:users).with_dependent(:destroy) }
    it { should have_many(:contacts).with_dependent(:destroy) }
    it { should have_many(:deals).with_dependent(:destroy) }
    it { should have_many(:deal_stages).with_dependent(:destroy) }
    it { should have_many(:sources).with_dependent(:destroy) }
    it { should have_many(:projects).with_dependent(:destroy) }
    it { should have_many(:milestones).with_dependent(:destroy) }
    it { should have_many(:tickets).with_dependent(:destroy) }
    it { should have_many(:pages).with_dependent(:destroy) }
    it { should have_many(:accounts).with_dependent(:destroy) }
    it { should have_many(:tax_codes).with_dependent(:destroy) }
    it { should have_many(:payment_forms).with_dependent(:destroy) }
    it { should have_many(:ledger_transactions).with_dependent(:destroy) }
    it { should have_many(:invoices).with_dependent(:destroy) }
    it { should have_many(:products).with_dependent(:destroy) }
    it { should embed_many(:api_applications) }
  end

  describe '#validations' do
    it { should validate_presence_of(:subdomain) }
    it { should validate_uniqueness_of(:subdomain).case_insensitive }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:subdomain) }
    it { should allow_mass_assignment_of(:organization_attributes) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context '#organization' do
    it 'should build an empty organization when instantiating' do
      Instance.new.organization.should_not be_blank
    end
  end

  context '#model sequences' do
    let(:sequences) { Fabricate(:instance).model_sequences }

    it 'should build a model sequence for organizations when creating instance' do
      sequences.organization.should_not be_blank
    end

    it 'should start model sequence for organizations at 9999' do
      sequences.organization.current_value.should == 9999
    end

    it 'should build a model sequence for people when creating instance' do
      sequences.person.should_not be_blank
    end

    it 'should start model sequence for people at 9999' do
      sequences.person.current_value.should == 9999
    end

    it 'should build a model sequence for deals when creating instance' do
      sequences.deal.should_not be_blank
    end

    it 'should start model sequence for deals at 9999' do
      sequences.deal.current_value.should == 9999
    end

    it 'should build a model sequence for projects when creating instance' do
      sequences.project.should_not be_blank
    end
    
    it 'should start model sequence for projects at 9999' do
      sequences.project.current_value.should == 9999
    end

    it 'should build a model sequence for ledger transactions when creating instance' do
      sequences.ledger_transaction.should_not be_blank
    end
    
    it 'should start model sequence for ledger transactions at 0' do
      sequences.ledger_transaction.current_value.should == 0
    end

    it 'should build a model sequence for invoices when creating instance' do
      sequences.invoice.should_not be_blank
    end
    
    it 'should start model sequence for invoices at 9999' do
      sequences.invoice.current_value.should == 9999
    end

    it 'should not tamper with model sequences if they are already built' do
      i = Fabricate(:instance)
      number_of_sequences = i.model_sequences.size
      lambda { i.save! }.should_not raise_error
      i.model_sequences.size.should == number_of_sequences
    end
  end
end
