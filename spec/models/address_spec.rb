# encoding: utf-8
#

require 'spec_helper'

describe Address do
  describe '#attributes' do
    it { should have_field(:location).of_type(Integer).with_default_value_of(nil) }
    it { should have_field(:street_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:zip_code).of_type(String).with_default_value_of(nil) }
    it { should have_field(:city).of_type(String).with_default_value_of(nil) }
    it { should have_field(:state).of_type(String).with_default_value_of(nil) }
    it { should have_field(:country).of_type(String).with_default_value_of(nil) }
    it { should have_field(:coordinates).of_type(Array).with_default_value_of([]) }
    it { should have_field(:time_zone).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:addressable) }
  end

  describe '#validations' do
    let(:empty_address) { Fabricate.build(:address, :street_name => nil, :zip_code => nil, :city => nil, :state => nil, :country => nil) }
    let(:address_with_street) { Fabricate.build(:address, :zip_code => nil, :city => nil, :state => nil, :country => nil) }
    let(:address_with_zip) { Fabricate.build(:address, :street_name => nil, :city => nil, :state => nil, :country => nil) }
    let(:address_with_city) { Fabricate.build(:address, :street_name => nil, :zip_code => nil, :state => nil, :country => nil) }
    let(:address_with_state) { Fabricate.build(:address, :street_name => nil, :zip_code => nil, :city => nil, :country => nil) }
    let(:address_with_country) { Fabricate.build(:address, :street_name => nil, :zip_code => nil, :city => nil, :state => nil) }
    
    it { should validate_presence_of(:location) }
    it { should validate_inclusion_of(:location).to_allow(Address::LOCATIONS.keys.map(&:to_i)) }

    it 'should not be valid without any address data' do
      empty_address.should_not be_valid
    end
    it 'should be valid with only street name' do
      address_with_street.should be_valid
    end
    it 'should be valid with only zip code' do
      address_with_zip.should be_valid
    end
    it 'should be valid with only city' do
      address_with_city.should be_valid
    end
    it 'should be valid with only state' do
      address_with_state.should be_valid
    end
    it 'should be valid with only country' do
      address_with_country.should be_valid
    end
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should allow_mass_assignment_of(:location) }
    it { should allow_mass_assignment_of(:street_name) }
    it { should allow_mass_assignment_of(:zip_code) }
    it { should allow_mass_assignment_of(:city) }
    it { should allow_mass_assignment_of(:state) }
    it { should allow_mass_assignment_of(:country) }
  end

  describe '#geocoded address data' do
    let(:address) do
      Fabricate(:address, street_name: 'Street Name', zip_code: 'Zip', city: 'City', state: 'State', country: 'Country')
    end

    it 'should include all data fields in address data' do
      address.send(:geocoded_address_data).should == 'Street Name, Zip, City, State, Country'
    end
  end
  
  describe '#latitude and longitude' do
    let(:address) { Fabricate.build(:address, coordinates: [10, 20]) }

    it 'should return coordinates' do
      # These are reversed from how we entered them since MongoDB stores
      # coordinates in reverse. See "Notes on MongoDB" at
      # https://github.com/alexreisner/geocoder.
      address.latitude.should == 20
      address.longitude.should == 10
    end

    it 'should return nil if there are no coordinates' do
      address.coordinates = []
      address.latitude.should == nil
      address.longitude.should == nil
      address.coordinates = nil
      address.latitude.should == nil
      address.longitude.should == nil
    end
  end
end
