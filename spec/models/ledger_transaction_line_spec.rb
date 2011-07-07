# encoding: utf-8
#

require 'spec_helper'

describe LedgerTransactionLine do
  describe '#attributes' do
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:debit).of_type(Float).with_default_value_of(nil) }
    it { should have_field(:credit).of_type(Float).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:ledger_transaction).as_inverse_of(:lines) }
    it { should belong_to(:account) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    let(:transaction) do
      Fabricate.build(:ledger_transaction)
    end

    let(:line) do
      transaction.lines.last.debit = 10000.00
      transaction.lines.last.credit = 10000.00
      transaction.lines.last
    end

    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:description) }

    it 'should require either debit or credit' do
      line.debit = nil
      line.credit = nil
      line.should_not be_valid
    end

    it 'should not require credit if debit is set' do
      line.credit = nil
      line.should be_valid
    end

    it 'should not require debit if credit is set' do
      line.debit = nil
      line.should be_valid
    end
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:account) }
    it { should allow_mass_assignment_of(:account_id) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:debit) }
    it { should allow_mass_assignment_of(:credit) }
  end

  describe '#sequence' do
    let(:line) { Fabricate(:ledger_transaction_line) }
    let(:transaction) { Fabricate(:ledger_transaction) }

    it 'should assign a sequence' do
      line.identifier.should == 1
    end

    it 'should assign sequence when saved through transaction' do
      transaction.lines.map(&:identifier).sort.should == [1, 2]
    end
  end
  
  context '#only allow debit or credit' do
    let(:transaction) do
      Fabricate(:ledger_transaction)
    end

    let(:line_with_debit_and_credit) do
      t = transaction
      t.lines.last.debit = 10000.00
      t.lines.last.credit = 10000.00
      t.save
      t.reload
      t.lines.last
    end

    it 'should nullify debit if both debit and credit is set' do
      line_with_debit_and_credit.debit.should be_blank
    end
  end
end
