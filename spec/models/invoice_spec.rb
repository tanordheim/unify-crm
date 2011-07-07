# encoding: utf-8
#

require 'spec_helper'

describe Invoice do
  describe '#attributes' do
    it { should have_field(:state).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:billed_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:due_on).of_type(Date).with_default_value_of(nil) }
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:biller_reference).of_type(String).with_default_value_of(nil) }
    it { should have_field(:organization_reference).of_type(String).with_default_value_of(nil) }
    it { should have_field(:net_cost).of_type(Float).with_default_value_of(0.0) }
    it { should have_field(:taxable_amount).of_type(Float).with_default_value_of(0.0) }
    it { should have_field(:tax_cost).of_type(Float).with_default_value_of(0.0) }
    it { should have_field(:total_cost).of_type(Float).with_default_value_of(0.0) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:organization) }
    it { should belong_to(:project) }
    it { should embed_one(:frozen_data) }
    it { should embed_many(:lines) }
    it { should accept_nested_attributes_for(:lines) }
    it { should embed_many(:payments) }
  end

  describe '#indexes' do
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:state) }
    it { should validate_inclusion_of(:state).to_allow(Invoice::STATES.keys.map(&:to_i)) }
    it { should validate_presence_of(:billed_on) }
    it { should validate_presence_of(:due_on) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:organization) }
    it { should allow_mass_assignment_of(:organization_id) }
    it { should allow_mass_assignment_of(:project) }
    it { should allow_mass_assignment_of(:project_id) }
    it { should allow_mass_assignment_of(:lines_attributes) }
    it { should allow_mass_assignment_of(:state) }
    it { should allow_mass_assignment_of(:billed_on) }
    it { should allow_mass_assignment_of(:due_on) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:biller_reference) }
    it { should allow_mass_assignment_of(:organization_reference) }
    it { should_not allow_mass_assignment_of(:net_price) }
    it { should_not allow_mass_assignment_of(:taxable_amount) }
    it { should_not allow_mass_assignment_of(:vat_cost) }
    it { should_not allow_mass_assignment_of(:total_price) }
  end

  context '#identifier' do
    it 'should not give non-generated invoices an identifier' do
      Fabricate(:invoice, state: Invoice::STATES.key(:draft)).identifier.should be_blank
    end

    it 'should generate an identifier when generating the invoice' do
      invoice = Fabricate(:invoice, state: Invoice::STATES.key(:draft))
      invoice.generate!
      invoice.identifier.should_not be_blank
    end
  end

  context '#frozen data' do
    let(:instance) do
      i = Fabricate.build(:instance)
      i.organization.name = 'Test Instance'
      i.organization.street_name = 'Instance Street Name'
      i.organization.zip_code = 'Instance Zip Code'
      i.organization.city = 'Instance City'
      i.organization.vat_number = 'Vat Number'
      i.organization.bank_account_number = 'Bank Account Number'
      i.save!
      i
    end

    let(:organization) do
      o = Fabricate(:organization, instance: instance, name: 'Test Organization')
      Fabricate(:address, addressable: o, street_name: 'Organization Street Name', zip_code: 'Organization Zip Code', city: 'Organization City')
      o
    end

    let(:project) { Fabricate(:project, instance: instance, key: 'TEST_PROJECT', name: 'Test Project') }
    let(:product) { Fabricate(:product, key: 'TEST_PRODUCT') }

    let(:frozen_invoice) do
      i = Fabricate(:invoice, instance: instance, organization: organization, project: project, state: Invoice::STATES.key(:draft).to_i, lines: [
        Fabricate.build(:invoice_line, invoice: nil, quantity: 1, price_per: 100, product: product)
      ])
      i.generate!
      i
    end
    let(:invoice) do
      Fabricate(:invoice, instance: instance, organization: organization, project: project, state: Invoice::STATES.key(:draft).to_i, lines: [
        Fabricate.build(:invoice_line, invoice: nil, quantity: 1, price_per: 100, product: product)
      ])
    end

    it 'should build an empty frozen invoice data instance when instantiating' do
      Invoice.new.frozen_data.should_not be_blank
    end

    it 'should freeze the biller data' do
      frozen_invoice.frozen_data.biller_name.should == 'Test Instance'
      frozen_invoice.frozen_data.biller_street_name.should == 'Instance Street Name'
      frozen_invoice.frozen_data.biller_zip_code.should == 'Instance Zip Code'
      frozen_invoice.frozen_data.biller_city.should == 'Instance City'
      frozen_invoice.frozen_data.biller_vat_number.should == 'Vat Number'
      frozen_invoice.frozen_data.biller_bank_account_number.should == 'Bank Account Number'
    end

    it 'should freeze organization data' do
      frozen_invoice.frozen_data.organization_name.should == 'Test Organization'
      frozen_invoice.frozen_data.organization_identifier.should == organization.identifier
      frozen_invoice.frozen_data.organization_street_name.should == 'Organization Street Name'
      frozen_invoice.frozen_data.organization_zip_code.should == 'Organization Zip Code'
      frozen_invoice.frozen_data.organization_city.should == 'Organization City'
    end

    it 'should freeze project data' do
      frozen_invoice.frozen_data.project_name.should == 'Test Project'
      frozen_invoice.frozen_data.project_identifier.should == project.identifier
      frozen_invoice.frozen_data.project_key.should == 'TEST_PROJECT'
    end

    it 'should freeze the invoice lines' do
      frozen_invoice.lines.first.frozen_product_key.should == 'TEST_PRODUCT'
    end

    describe '#accessors' do
      it 'should return the same biller data for frozen and non-frozen invoices' do
        invoice.biller_name.should == frozen_invoice.biller_name
        invoice.biller_street_name.should == frozen_invoice.biller_street_name
        invoice.biller_zip_code.should == frozen_invoice.biller_zip_code
        invoice.biller_city.should == frozen_invoice.biller_city
        invoice.biller_vat_number.should == frozen_invoice.biller_vat_number
        invoice.biller_bank_account_number.should == frozen_invoice.biller_bank_account_number
      end

      it 'should return the same organization data for frozen and non-frozen invoices' do
        invoice.organization_name.should == frozen_invoice.organization_name
        invoice.organization_identifier.should == frozen_invoice.organization_identifier
        invoice.organization_street_name.should == frozen_invoice.organization_street_name
        invoice.organization_zip_code.should == frozen_invoice.organization_zip_code
        invoice.organization_city.should == frozen_invoice.organization_city
      end

      it 'should return the same project data for frozen and non-frozen invoices' do
        invoice.project_name.should == frozen_invoice.project_name
        invoice.project_identifier.should == frozen_invoice.project_identifier
        invoice.project_key.should == frozen_invoice.project_key
      end

      it 'should return the same product data for frozen and non-frozen invoices' do
        invoice.lines.first.product_key.should == frozen_invoice.lines.first.product_key
      end
    end
  end

  describe '#calculating totals' do
    let(:instance) { Fabricate(:instance) }

    let(:outgoing_tax_account) { Fabricate(:account, instance: instance, code: 2700, name: 'Outgoing tax') }
    let(:outgoing_tax) { Fabricate(:tax_code, instance: instance, code: 3, name: 'Outgoing tax', target_account: outgoing_tax_account, percentage: 25) }

    let(:sales_income_account) { Fabricate(:account, instance: instance, code: 3000, name: 'Sales income, taxable', tax_code: outgoing_tax) }
    let(:non_taxable_sale_account) { Fabricate(:account, instance: instance, code: 3001, name: 'Sales income, not taxable', tx_code: nil) }

    let(:product) { Fabricate(:product, instance: instance, account: sales_income_account) }
    let(:non_taxable_product) { Fabricate(:product, instance: instance, account: non_taxable_sale_account) }

    let(:invoice) do
      invoice = Fabricate.build(:invoice, :instance => instance, lines: [])
      invoice.lines.build(:product => product, :description => 'Line 1', :quantity => 2, :price_per => 250)
      invoice.lines.build(:product => non_taxable_product, :description => 'Line 2', :quantity => 5, :price_per => 100)
      invoice.save!
      invoice
    end

    it 'should calculate the total net cost' do
      invoice.net_cost.should == 1000
    end

    it 'should calculate the taxable amount' do
      invoice.taxable_amount.should == 500
    end

    it 'should calculate the tax cost' do
      invoice.tax_cost.should == 125
    end

    it 'should calculate the total price' do
      invoice.total_cost.should == 1125
    end
  end

  context '#ledger transactions' do
    let(:instance) { Fabricate(:instance) }

    let(:sales_income_account) { Fabricate(:account, instance: instance, code: 3000, name: 'Sales income, taxable', tax_code: nil) }
    let(:product) { Fabricate(:product, instance: instance, account: sales_income_account) }

    let(:invoice) do
      invoice = Fabricate.build(:invoice, :instance => instance, state: Invoice::STATES.key(:draft).to_i)
      invoice.lines.build(:product => product, :description => 'Line 1', :quantity => 2, :price_per => 250)
      invoice.lines.build(:product => product, :description => 'Line 2', :quantity => 5, :price_per => 100)
      invoice.save!
      invoice
    end

    it 'should create a ledger transaction when generating the invoice' do
      invoice.generate!
      LedgerTransaction.count.should == 1
      LedgerTransaction.first.lines.count.should == invoice.lines.count + 1
    end

    it 'should flag the generated ledger as locked' do
      invoice.generate!
      invoice.instance.ledger_transactions.first.locked.should == true
    end

    it 'should should not create a ledger when updating the invoice' do
      invoice.generate!
      invoice.billed_on = invoice.billed_on + 1.day
      invoice.save!
      LedgerTransaction.count.should == 1
      LedgerTransaction.first.lines.count.should == invoice.lines.count + 1
    end
  end
end
