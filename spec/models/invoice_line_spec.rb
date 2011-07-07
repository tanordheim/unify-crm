# encoding: utf-8
#

require 'spec_helper'

describe InvoiceLine do
  describe '#attributes' do
    it { should have_field(:description).of_type(String).with_default_value_of(nil) }
    it { should have_field(:price_per).of_type(Float).with_default_value_of(nil) }
    it { should have_field(:quantity).of_type(Integer).with_default_value_of(1) }
    it { should have_field(:net_cost).of_type(Float).with_default_value_of(nil) }
    it { should have_field(:tax_percentage).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:tax_cost).of_type(Float).with_default_value_of(nil) }
    it { should have_field(:total_cost).of_type(Float).with_default_value_of(nil) }
    it { should have_field(:frozen_product_key).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:invoice).as_inverse_of(:lines) }
    it { should belong_to(:product) }
  end

  describe '#validations' do
    it { should validate_presence_of(:product) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:price_per) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:product) }
    it { should allow_mass_assignment_of(:product_id) }
    it { should_not allow_mass_assignment_of(:frozen_product_key) }
    it { should allow_mass_assignment_of(:price_per) }
    it { should allow_mass_assignment_of(:quantity) }
  end

  describe '#calculating totals' do
    let(:instance) { Fabricate(:instance) }

    let(:outgoing_tax_account) { Fabricate(:account, instance: instance, code: 2700, name: 'Outgoing tax') }
    let(:outgoing_tax) { Fabricate(:tax_code, instance: instance, code: 3, name: 'Outgoing tax', target_account: outgoing_tax_account, percentage: 25) }

    let(:sales_income_account) { Fabricate(:account, instance: instance, code: 3000, name: 'Sales income, taxable', tax_code: outgoing_tax) }
    let(:non_taxable_sale_account) { Fabricate(:account, instance: instance, code: 3001, name: 'Sales income, not taxable', tx_code: nil) }

    let(:product) { Fabricate(:product, instance: instance, account: sales_income_account) }
    let(:non_taxable_product) { Fabricate(:product, instance: instance, account: non_taxable_sale_account) }
    
    let(:invoice_line) { Fabricate(:invoice_line, :product => product, :quantity => 2, :price_per => 100) }

    it 'should calculate total net cost' do
      invoice_line.net_cost.should == 200
    end

    it 'should hold a copy of the vat percentage' do
      invoice_line.tax_percentage.should == 25
    end

    it 'should calculate vat cost' do
      invoice_line.tax_cost.should == 50
    end

    it 'should calculate total cost' do
      invoice_line.total_cost.should == 250
    end

    describe '#non-taxable' do
      let(:product) { Fabricate(:product, instance: instance, account: non_taxable_sale_account) }

      it 'should hold a copy of the vat percentage' do
        invoice_line.tax_percentage.should == 0
      end
      
      it 'should calculate vat cost' do
        invoice_line.tax_cost.should == 0
      end

      it 'should calculate total cost' do
        invoice_line.total_cost.should == 200
      end
    end
  end
end
