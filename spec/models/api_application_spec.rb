# encoding: utf-8
#

require 'spec_helper'

describe ApiApplication do
  describe '#attributes' do
    it { should have_field(:token).of_type(String).with_default_value_of(nil) }
    it { should have_field(:key).of_type(String).with_default_value_of(nil) }
    it { should have_field(:name).of_type(String).with_default_value_of(nil) }
    it { should have_field(:sso_enabled).of_type(Boolean).with_default_value_of(false) }
    it { should have_field(:sso_callback_url).of_type(String).with_default_value_of(nil) }
  end

  describe '#associations' do
    it { should be_embedded_in(:instance) }
  end

  describe '#validations' do
    it { should validate_presence_of(:token) }
    it { should validate_uniqueness_of(:token) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
    it { should validate_presence_of(:name) }

    it 'should not require sso callback url if sso access is disabled' do
      Fabricate.build(:api_application, sso_enabled: false, sso_callback_url: nil).should be_valid
    end

    it 'should require sso callback url if sso access is enabled' do
      Fabricate.build(:api_application, sso_enabled: true, sso_callback_url: nil).should_not be_valid
      Fabricate.build(:api_application, sso_enabled: true, sso_callback_url: 'test').should be_valid
    end
  end

  describe '#fabrication' do
    it { should have_valid_fabricator }
  end

  describe '#mass assignment' do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:_id) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:key) }
    it { should allow_mass_assignment_of(:sso_enabled) }
    it { should allow_mass_assignment_of(:sso_callback_url) }
  end

  describe '#token' do
    it 'should create token when instantiating model' do
      ApiApplication.new.token.should_not be_blank
    end

    it 'should not change token when updating model' do
      app = Fabricate(:api_application)
      token = app.token
      app.save!
      app.token.should == token
    end
  end

  describe '#sso callback url' do
    let(:application) { Fabricate(:api_application) }
    let(:user) { Fabricate(:user) }

    it 'should return an SSO callback URL for callback URLs containing parameters' do
      application.sso_callback_url = 'http://example.com/?foo=bar'
      application.stub(:encrypt_sso_token_for_user).and_return('TEST_TOKEN')
      application.sso_callback_url_for(user).should == 'http://example.com/?foo=bar&sso_token=TEST_TOKEN'
    end

    it 'should return an SSO callback URL for callback URLs not containing parameters' do
      application.sso_callback_url = 'http://example.com/'
      application.stub(:encrypt_sso_token_for_user).and_return('TEST_TOKEN')
      application.sso_callback_url_for(user).should == 'http://example.com/?sso_token=TEST_TOKEN'
    end
  end
end
