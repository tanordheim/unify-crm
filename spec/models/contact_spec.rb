# encoding: utf-8
#

require 'spec_helper'

describe Contact do
  describe '#attributes' do
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:background).of_type(String).with_default_value_of(nil) }
    it { should have_field(:deleted).of_type(Boolean).with_default_value_of(false) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
    it { should belong_to(:source) }
    it { should embed_many(:phone_numbers) }
    it { should accept_nested_attributes_for(:phone_numbers) }
    it { should embed_many(:email_addresses) }
    it { should accept_nested_attributes_for(:email_addresses) }
    it { should embed_many(:websites) }
    it { should accept_nested_attributes_for(:websites) }
    it { should embed_many(:twitter_accounts) }
    it { should accept_nested_attributes_for(:twitter_accounts) }
    it { should embed_many(:addresses) }
    it { should accept_nested_attributes_for(:addresses) }
    it { should have_many(:comments).with_dependent(:destroy) }
  end

  describe '#validations' do
    it { should validate_presence_of(:instance) }
    it { should validate_presence_of(:name) }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:source) }
    it { should allow_mass_assignment_of(:source_id) }
    it { should allow_mass_assignment_of(:background) }
    it { should allow_mass_assignment_of(:phone_numbers_attributes) }
    it { should allow_mass_assignment_of(:email_addresses_attributes) }
    it { should allow_mass_assignment_of(:websites_attributes) }
    it { should allow_mass_assignment_of(:instant_messengers_attributes) }
    it { should allow_mass_assignment_of(:twitter_accounts_attributes) }
    it { should allow_mass_assignment_of(:addresses_attributes) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe '#primary phone number' do
    let(:contact) do

      c = Fabricate.build(:contact)

      # Add one of each phone number
      PhoneNumber::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:phone_number, phoneable: c, location: location.to_i)
      end

      c

    end

    it 'should return work phone as primary if available' do
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :work
    end

    it 'should return mobile phone as primary if available' do
      contact.phone_numbers.delete_if { |n| n.location == PhoneNumber::LOCATIONS.key(:work).to_i }
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :mobile
    end

    it 'should return fax number as primary if available' do
      contact.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :fax
    end

    it 'should return pager number as primary if available' do
      contact.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :pager
    end

    it 'should return home number as primary if available' do
      contact.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax pager).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :home
    end

    it 'should return skype number as primary if available' do
      contact.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax pager home).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :skype
    end

    it 'should return other as primary if available' do
      contact.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax pager home skype).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[contact.phone_numbers.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no phone numbers' do
      contact.phone_numbers.clear
      contact.phone_numbers.primary.should be_blank
    end
  end

  describe '#primary email address' do
    let(:contact) do

      c = Fabricate.build(:contact)

      # Add one of each email address
      EmailAddress::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:email_address, emailable: c, location: location.to_i)
      end

      c

    end

    it 'should return work address as primary if available' do
      EmailAddress::LOCATIONS[contact.email_addresses.primary.location.to_s].should == :work
    end

    it 'should return home address as primary if available' do
      contact.email_addresses.delete_if { |n| n.location == EmailAddress::LOCATIONS.key(:work).to_i }
      EmailAddress::LOCATIONS[contact.email_addresses.primary.location.to_s].should == :home
    end

    it 'should return other as primary if available' do
      contact.email_addresses.delete_if do |n|
        remove_locations = EmailAddress::LOCATIONS.select { |k, v| %w(work home).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      EmailAddress::LOCATIONS[contact.email_addresses.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no email addresses' do
      contact.email_addresses.clear
      contact.email_addresses.primary.should be_blank
    end
  end

  describe '#primary website' do
    let(:contact) do

      c = Fabricate.build(:contact)

      # Add one of each website
      Website::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:website, websiteable: c, location: location.to_i)
      end

      c

    end

    it 'should return work website as primary if available' do
      Website::LOCATIONS[contact.websites.primary.location.to_s].should == :work
    end

    it 'should return personal website as primary if available' do
      contact.websites.delete_if { |n| n.location == Website::LOCATIONS.key(:work).to_i }
      Website::LOCATIONS[contact.websites.primary.location.to_s].should == :personal
    end

    it 'should return other as primary if available' do
      contact.websites.delete_if do |n|
        remove_locations = Website::LOCATIONS.select { |k, v| %w(work personal).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      Website::LOCATIONS[contact.websites.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no websites' do
      contact.websites.clear
      contact.websites.primary.should be_blank
    end
  end

  describe '#primary instant messenger' do
    let(:contact) do

      c = Fabricate.build(:contact)

      # Add one of each instant messenger protocol for each location.
      InstantMessenger::PROTOCOLS.keys.shuffle.each do |protocol|
        InstantMessenger::LOCATIONS.keys.shuffle.each do |location|
          Fabricate.build(:instant_messenger, instant_messageable: c, protocol: protocol.to_i, location: location.to_i)
        end
      end

      c

    end

    it 'should return work IM as primary if available' do
      InstantMessenger::LOCATIONS[contact.instant_messengers.primary.location.to_s].should == :work
    end

    it 'should return personal IM as primary if available' do
      contact.instant_messengers.delete_if { |n| n.location == InstantMessenger::LOCATIONS.key(:work).to_i }
      InstantMessenger::LOCATIONS[contact.instant_messengers.primary.location.to_s].should == :personal
    end

    it 'should return other as primary if available' do
      contact.instant_messengers.delete_if do |n|
        remove_locations = InstantMessenger::LOCATIONS.select { |k, v| %w(work personal).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      InstantMessenger::LOCATIONS[contact.instant_messengers.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no IMs' do
      contact.instant_messengers.clear
      contact.instant_messengers.primary.should be_blank
    end
  end

  describe '#primary twitter account' do
    let(:contact) do

      c = Fabricate.build(:contact)

      # Add one of each twitter account
      TwitterAccount::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:twitter_account, tweetable: c, location: location.to_i)
      end

      c

    end

    it 'should return personal twitter account as primary if available' do
      TwitterAccount::LOCATIONS[contact.twitter_accounts.primary.location.to_s].should == :personal
    end

    it 'should return business twitter account as primary if available' do
      contact.twitter_accounts.delete_if { |n| n.location == TwitterAccount::LOCATIONS.key(:personal).to_i }
      TwitterAccount::LOCATIONS[contact.twitter_accounts.primary.location.to_s].should == :business
    end

    it 'should return other as primary if available' do
      contact.twitter_accounts.delete_if do |n|
        remove_locations = TwitterAccount::LOCATIONS.select { |k, v| %w(personal business).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      TwitterAccount::LOCATIONS[contact.twitter_accounts.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no twitter accounts' do
      contact.twitter_accounts.clear
      contact.twitter_accounts.primary.should be_blank
    end
  end

  describe '#primary address' do
    let(:contact) do

      c = Fabricate.build(:contact)

      # Add one of each address
      Address::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:address, addressable: c, location: location.to_i)
      end

      c

    end

    it 'should return work address as primary if available' do
      Address::LOCATIONS[contact.addresses.primary.location.to_s].should == :work
    end

    it 'should return private address as primary if available' do
      contact.addresses.delete_if { |n| n.location == Address::LOCATIONS.key(:work).to_i }
      Address::LOCATIONS[contact.addresses.primary.location.to_s].should == :home
    end

    it 'should return other as primary if available' do
      contact.addresses.delete_if do |n|
        remove_locations = Address::LOCATIONS.select { |k, v| %w(work home).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      Address::LOCATIONS[contact.addresses.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no addresses' do
      contact.addresses.clear
      contact.addresses.primary.should be_blank
    end
  end

  describe '#address geocoding' do
    before(:each) { ResqueSpec.reset! }

    let(:contact) do
      o = Fabricate.build(:organization)
      Fabricate.build(:address, addressable: o)
      o.save!
      o
    end

    let(:address) { contact.addresses.first }

    it 'should queue a lookup when creating an address' do
      contact
      GeocodeAddressWorker.should have_queue_size_of(1)
      GeocodeAddressWorker.should have_queued('Organization', contact.id, address.id)
    end

    it 'should queue a lookup when changing street name' do
      address.street_name = 'Test Street Name'
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(2)
      GeocodeAddressWorker.should have_queued('Organization', contact.id, address.id)
    end

    it 'should queue a lookup when changing zip code' do
      address.zip_code = 'Test Zip Code'
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(2)
      GeocodeAddressWorker.should have_queued('Organization', contact.id, address.id)
    end

    it 'should queue a lookup when changing city' do
      address.city = 'Test City'
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(2)
      GeocodeAddressWorker.should have_queued('Organization', contact.id, address.id)
    end

    it 'should queue a lookup when changing state' do
      address.state = 'Test State'
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(2)
      GeocodeAddressWorker.should have_queued('Organization', contact.id, address.id)
    end

    it 'should queue a lookup when changing country' do
      address.country = 'Test Country'
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(2)
      GeocodeAddressWorker.should have_queued('Organization', contact.id, address.id)
    end

    it 'should not queue a lookup without changing anything' do
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(1)
    end

    it 'should not queue a lookup when changing location' do
      address.location = 999
      contact.save!
      GeocodeAddressWorker.should have_queue_size_of(1)
    end
  end
end
