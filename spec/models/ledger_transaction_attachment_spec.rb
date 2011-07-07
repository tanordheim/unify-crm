# encoding: utf-8
#

require 'spec_helper'

describe LedgerTransactionAttachment do
  describe '#attributes' do
    it { should have_field(:filename).of_type(String).with_default_value_of(nil) }
    it { should have_field(:content_type).of_type(String).with_default_value_of(nil) }
    it { should have_field(:size).of_type(Integer).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:ledger_transaction).as_inverse_of(:attachments) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:attachment) }
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:content_type) }
    it { should validate_presence_of(:size) }

    it 'should not require an attachment when updating' do
      attachment = Fabricate(:ledger_transaction_attachment)
      attachment.attachment = nil
      attachment.valid?.should be_true
    end

    it 'should not require an attachment when updating via update_attributes' do
      attachment = Fabricate(:ledger_transaction_attachment)
      attachment.update_attributes({'id' => attachment.id.to_s})
      attachment.valid?.should be_true
    end

    it 'should keep the old attachment when updating with specifying a new attachment' do
      transaction = Fabricate(:ledger_transaction)
      attachment = Fabricate(:ledger_transaction_attachment, ledger_transaction: transaction)
      attachment.attachment = nil
      attachment.save!
      transaction.reload
      transaction.attachments.first.attachment.should_not be_blank
    end
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:attachment) }
    it { should_not allow_mass_assignment_of(:file_name) }
    it { should_not allow_mass_assignment_of(:content_type) }
    it { should_not allow_mass_assignment_of(:size) }
  end

  describe '#sequence' do
    let(:transaction) { Fabricate(:ledger_transaction) }
    let(:attachment) { Fabricate(:ledger_transaction_attachment, transaction: transaction) }

    it 'should assign a sequence' do
      attachment.identifier.should == 1
    end

    it 'should assign sequence when saved through transaction' do
      t = Fabricate(:ledger_transaction, attachments: [Fabricate.build(:ledger_transaction_attachment, transaction: nil)])
      t.attachments.first.identifier.should == 1
    end
  end
end
