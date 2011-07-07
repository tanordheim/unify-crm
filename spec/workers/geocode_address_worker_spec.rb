# encoding: utf-8
#

require 'spec_helper'

describe GeocodeAddressWorker do
  let(:organization) { Fabricate(:organization) }
  let(:address) { Fabricate(:address, addressable: organization) }

  before(:each) { address } # Preload the address for each example.

  it 'should perform geocode lookup' do
    Address.any_instance.should_receive(:geocode).with(no_args())
    GeocodeAddressWorker.perform('Organization', organization.id, address.id)
  end

  it 'should perform time zone lookup' do
    Address.any_instance.should_receive(:set_time_zone_from_coordinates).with(no_args())
    GeocodeAddressWorker.perform('Organization', organization.id, address.id)
  end

  it 'should re-save the address' do
    Address.any_instance.should_receive(:save!).with(no_args())
    GeocodeAddressWorker.perform('Organization', organization.id, address.id)
  end
end
