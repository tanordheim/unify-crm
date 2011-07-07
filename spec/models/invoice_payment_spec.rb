# encoding: utf-8
#

require 'spec_helper'

describe InvoicePayment do
  describe '#attributes' do
    it { should have_field(:amount).of_type(Float).with_default_value_of(nil) }
    it { should have_field(:paid_on).of_type(Date).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:invoice).as_inverse_of(:payments) }
    it { should belong_to(:payment_form) }
  end

  describe '#validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:paid_on) }
    it { should validate_presence_of(:payment_form) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end
  
  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:payment_form) }
    it { should allow_mass_assignment_of(:payment_form_id) }
    it { should allow_mass_assignment_of(:amount) }
    it { should allow_mass_assignment_of(:paid_on) }
  end

  context '#registering payment' do
    let(:instance) { Fabricate(:instance) }
    let(:organization) { Fabricate(:organization, :instance => instance) }
    let(:account) { Fabricate(:account, :instance => instance) }
    let(:product) { Fabricate(:product, :instance => instance, account: account) }
    let(:invoice) do
      invoice = Fabricate.build(:invoice, instance: instance, organization: organization, project: nil, state: Invoice::STATES.key(:draft).to_i, lines: [])
      invoice.lines << Fabricate.build(:invoice_line, :invoice => nil, :product => product, :quantity => 1, :price_per => 1000.0)
      invoice.save!
      invoice.generate!
      invoice
    end
    let(:payment_account) { Fabricate(:account, :instance => instance) }
    let(:payment_form) { Fabricate(:payment_form, :instance => instance, :account => payment_account) }
    let(:payment) { Fabricate(:invoice_payment, :invoice => invoice, :payment_form => payment_form, amount: 1000.0) }
    let(:partial_payment) { Fabricate(:invoice_payment, :invoice => invoice, :payment_form => payment_form, amount: 100.0) }

    it 'should create a ledger transaction when receiving a payment' do
      payment # Creates the payment.
      LedgerTransaction.count.should == 2 # One ledger for the invoice, one for the payment.
    end

    it 'should flag the ledger transactions as locked when receiving a payment' do
      payment # Creates the payment.
      LedgerTransaction.all.to_a.map(&:locked).should == [true, true]
    end

    it 'should not create ledger transaction when updating payment' do
      payment
      payment.amount = 999.0
      payment.save!
      LedgerTransaction.count.should == 2 # One ledger for the invoice, one for the payment.
    end

    it 'should flag the invoice as partially paid when receiving a partial payment' do
      partial_payment # Creates a partial payment on the invoice
      invoice.reload
      invoice.partially_paid?.should be_true
    end

    it 'should flag the invoice as paid when receiving the full payment' do
      payment # Creates the full payment on the invoice
      invoice.reload
      invoice.paid?.should be_true
    end
  end
end
