# encoding: utf-8
#

require 'spec_helper'

describe FrozenInvoiceData do
  describe '#attributes' do
    it { should have_field(:biller_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:biller_street_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:biller_zip_code).of_type(String).with_default_value_of(nil) }
    it { should have_field(:biller_city).of_type(String).with_default_value_of(nil) }
    it { should have_field(:biller_vat_number).of_type(String).with_default_value_of(nil) }
    it { should have_field(:biller_bank_account_number).of_type(String).with_default_value_of(nil) }
    it { should have_field(:organization_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:organization_identifier).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:organization_street_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:organization_zip_code).of_type(String).with_default_value_of(nil) }
    it { should have_field(:organization_city).of_type(String).with_default_value_of(nil) }
    it { should have_field(:project_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:project_identifier).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:project_key).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:invoice).as_inverse_of(:frozen_data) }
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end
end
