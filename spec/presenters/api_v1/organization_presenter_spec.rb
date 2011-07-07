# encoding: utf-8
#

require 'spec_helper'

describe API_V1::OrganizationPresenter do

  let(:format) { :api_v1 }

  let(:instance) { Fabricate(:instance) }
  
  let(:organization) { Fabricate(:organization, instance: instance) }

  shared_examples_for API_V1::OrganizationPresenter do
    it 'should define the organization id' do
      organization_json.should have_key(:id)
      organization_json[:id].should == organization.id
    end

    it 'should define the organization identifier' do
      organization_json.should have_key(:identifier)
      organization_json[:identifier].should == organization.identifier
    end

    it 'should define the organization name' do
      organization_json.should have_key(:name)
      organization_json[:name].should == organization.name
    end
  end
  
  context '#singular organization' do
    let(:presenter) { Presenter.presenter_for(organization, format) }
    let(:json) { presenter.present(organization) }
    let(:organization_json) { json[:organization] }

    it 'should have an outer organization element' do
      json.keys.size.should == 1
      json.should have_key(:organization)
    end

    it_behaves_like API_V1::OrganizationPresenter
  end

  context '#collections' do
    let(:organizations) { [organization] }
    let(:presenter) { Presenter.presenter_for(organizations, format) }
    let(:json) { presenter.present(organizations) }
    let(:organization_json) { json[:organizations].first }

    it 'should have an outer organizations element containing the list of organizations' do
      json.keys.size.should == 1
      json.should have_key(:organizations)
      json[:organizations].should be_an(Array)
      json[:organizations].size.should == 1
    end

    it_behaves_like API_V1::OrganizationPresenter
  end
end
