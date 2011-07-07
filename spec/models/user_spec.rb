# encoding: utf-8
#

require 'spec_helper'

describe User do
  describe '#attributes' do
    it { should have_field(:username).of_type(String).with_default_value_of(nil) }
    it { should have_field(:password_digest).of_type(String).with_default_value_of(nil) }
    it { should have_field(:first_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:last_name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:title).of_type(String).with_default_value_of(nil) }
    it { should have_field(:single_access_token).of_type(String).with_default_value_of(nil) }
    it { should be_timestamped_document }
  end

  describe '#associations' do
    it { should belong_to(:instance) }
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
    it { should embed_many(:widget_configurations) }
  end

  describe '#validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).scoped_to(:instance_id).case_insensitive }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:title) }

    it 'should require password for new users' do
      Fabricate.build(:user, password: nil, password_confirmation: nil).should_not be_valid
      Fabricate.build(:user, password: 'test', password_confirmation: 'test').should be_valid
    end

    it 'should not require password when updating users' do
      u = Fabricate(:user)
      u.password = nil
      u.password_confirmation = nil
      u.should be_valid
    end

    it 'should require password when changing password' do
      u = Fabricate(:user)
      u.password = 'something'
      u.should_not be_valid
    end

    it 'should require password when changing password' do
      u = Fabricate(:user)
      u.password = 'something'
      u.should_not be_valid
    end
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should_not allow_mass_assignment_of(:instance) }
    it { should_not allow_mass_assignment_of(:instance_id) }
    it { should allow_mass_assignment_of(:username) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should_not allow_mass_assignment_of(:password_digest) }
    it { should allow_mass_assignment_of(:first_name) }
    it { should allow_mass_assignment_of(:last_name) }
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:phone_numbers_attributes) }
    it { should allow_mass_assignment_of(:email_addresses_attributes) }
    it { should allow_mass_assignment_of(:websites_attributes) }
    it { should allow_mass_assignment_of(:instant_messengers_attributes) }
    it { should allow_mass_assignment_of(:twitter_accounts_attributes) }
    it { should allow_mass_assignment_of(:addresses_attributes) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  describe '#full name' do
    it 'should return the full name of the user' do
      u = Fabricate.build(:user, :first_name => 'Test', :last_name => 'User')
      u.name.should == 'Test User'
    end
  end

  describe '#primary phone number' do
    let(:user) do

      u = Fabricate.build(:user)

      # Add one of each phone number
      PhoneNumber::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:phone_number, phoneable: u, location: location.to_i)
      end

      u

    end

    it 'should return work phone as primary if available' do
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :work
    end

    it 'should return mobile phone as primary if available' do
      user.phone_numbers.delete_if { |n| n.location == PhoneNumber::LOCATIONS.key(:work).to_i }
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :mobile
    end

    it 'should return fax number as primary if available' do
      user.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :fax
    end

    it 'should return pager number as primary if available' do
      user.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :pager
    end

    it 'should return home number as primary if available' do
      user.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax pager).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :home
    end

    it 'should return skype number as primary if available' do
      user.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax pager home).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :skype
    end

    it 'should return other as primary if available' do
      user.phone_numbers.delete_if do |n|
        remove_locations = PhoneNumber::LOCATIONS.select { |k, v| %w(work mobile fax pager home skype).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      PhoneNumber::LOCATIONS[user.phone_numbers.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no phone numbers' do
      user.phone_numbers.clear
      user.phone_numbers.primary.should be_blank
    end
  end

  describe '#primary email address' do
    let(:user) do

      u = Fabricate.build(:user)

      # Add one of each email address
      EmailAddress::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:email_address, emailable: u, location: location.to_i)
      end

      u

    end

    it 'should return work address as primary if available' do
      EmailAddress::LOCATIONS[user.email_addresses.primary.location.to_s].should == :work
    end

    it 'should return home address as primary if available' do
      user.email_addresses.delete_if { |n| n.location == EmailAddress::LOCATIONS.key(:work).to_i }
      EmailAddress::LOCATIONS[user.email_addresses.primary.location.to_s].should == :home
    end

    it 'should return other as primary if available' do
      user.email_addresses.delete_if do |n|
        remove_locations = EmailAddress::LOCATIONS.select { |k, v| %w(work home).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      EmailAddress::LOCATIONS[user.email_addresses.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no email addresses' do
      user.email_addresses.clear
      user.email_addresses.primary.should be_blank
    end
  end

  describe '#primary website' do
    let(:user) do

      u = Fabricate.build(:user)

      # Add one of each website
      Website::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:website, websiteable: u, location: location.to_i)
      end

      u

    end

    it 'should return work website as primary if available' do
      Website::LOCATIONS[user.websites.primary.location.to_s].should == :work
    end

    it 'should return personal website as primary if available' do
      user.websites.delete_if { |n| n.location == Website::LOCATIONS.key(:work).to_i }
      Website::LOCATIONS[user.websites.primary.location.to_s].should == :personal
    end

    it 'should return other as primary if available' do
      user.websites.delete_if do |n|
        remove_locations = Website::LOCATIONS.select { |k, v| %w(work personal).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      Website::LOCATIONS[user.websites.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no websites' do
      user.websites.clear
      user.websites.primary.should be_blank
    end
  end

  describe '#primary instant messenger' do
    let(:user) do

      u = Fabricate.build(:user)

      # Add one of each instant messenger protocol for each location.
      InstantMessenger::PROTOCOLS.keys.shuffle.each do |protocol|
        InstantMessenger::LOCATIONS.keys.shuffle.each do |location|
          Fabricate.build(:instant_messenger, instant_messageable: u, protocol: protocol.to_i, location: location.to_i)
        end
      end

      u

    end

    it 'should return work IM as primary if available' do
      InstantMessenger::LOCATIONS[user.instant_messengers.primary.location.to_s].should == :work
    end

    it 'should return personal IM as primary if available' do
      user.instant_messengers.delete_if { |n| n.location == InstantMessenger::LOCATIONS.key(:work).to_i }
      InstantMessenger::LOCATIONS[user.instant_messengers.primary.location.to_s].should == :personal
    end

    it 'should return other as primary if available' do
      user.instant_messengers.delete_if do |n|
        remove_locations = InstantMessenger::LOCATIONS.select { |k, v| %w(work personal).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      InstantMessenger::LOCATIONS[user.instant_messengers.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no IMs' do
      user.instant_messengers.clear
      user.instant_messengers.primary.should be_blank
    end
  end

  describe '#primary twitter account' do
    let(:user) do

      u = Fabricate.build(:user)

      # Add one of each twitter account
      TwitterAccount::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:twitter_account, tweetable: u, location: location.to_i)
      end

      u

    end

    it 'should return personal twitter account as primary if available' do
      TwitterAccount::LOCATIONS[user.twitter_accounts.primary.location.to_s].should == :personal
    end

    it 'should return business twitter account as primary if available' do
      user.twitter_accounts.delete_if { |n| n.location == TwitterAccount::LOCATIONS.key(:personal).to_i }
      TwitterAccount::LOCATIONS[user.twitter_accounts.primary.location.to_s].should == :business
    end

    it 'should return other as primary if available' do
      user.twitter_accounts.delete_if do |n|
        remove_locations = TwitterAccount::LOCATIONS.select { |k, v| %w(personal business).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      TwitterAccount::LOCATIONS[user.twitter_accounts.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no twitter accounts' do
      user.twitter_accounts.clear
      user.twitter_accounts.primary.should be_blank
    end
  end

  describe '#primary address' do
    let(:user) do

      u = Fabricate.build(:user)

      # Add one of each address
      Address::LOCATIONS.keys.shuffle.each do |location|
        Fabricate.build(:address, addressable: u, location: location.to_i)
      end

      u

    end

    it 'should return work address as primary if available' do
      Address::LOCATIONS[user.addresses.primary.location.to_s].should == :work
    end

    it 'should return private address as primary if available' do
      user.addresses.delete_if { |n| n.location == Address::LOCATIONS.key(:work).to_i }
      Address::LOCATIONS[user.addresses.primary.location.to_s].should == :home
    end

    it 'should return other as primary if available' do
      user.addresses.delete_if do |n|
        remove_locations = Address::LOCATIONS.select { |k, v| %w(work home).include?(v.to_s) }
        remove_locations.keys.map(&:to_i).include?(n.location)
      end
      Address::LOCATIONS[user.addresses.primary.location.to_s].should == :other
    end

    it 'should return no default if there are no addresses' do
      user.addresses.clear
      user.addresses.primary.should be_blank
    end
  end

  describe '#single access token' do
    let(:user) { Fabricate(:user) }

    it 'should create a token when creating a user' do
      user.single_access_token.should_not be_blank
    end

    it 'should not change token when updating user' do
      old_token = user.single_access_token
      user.save!
      old_token.should == user.single_access_token
    end
  end
end
