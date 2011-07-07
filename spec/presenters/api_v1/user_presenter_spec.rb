# encoding: utf-8
#

require 'spec_helper'

describe API_V1::UserPresenter do

  let(:format) { :api_v1 }

  let(:instance) { Fabricate(:instance) }
  
  let(:user) { Fabricate(:user, instance: instance) }

  shared_examples_for API_V1::UserPresenter do
    it 'should define the user id' do
      user_json.should have_key(:id)
      user_json[:id].should == user.id
    end

    it 'should define the user username' do
      user_json.should have_key(:username)
      user_json[:username].should == user.username
    end
    
    it 'should define the user first name' do
      user_json.should have_key(:first_name)
      user_json[:first_name].should == user.first_name
    end

    it 'should define the user last name' do
      user_json.should have_key(:last_name)
      user_json[:last_name].should == user.last_name
    end

    it 'should define the user title' do
      user_json.should have_key(:title)
      user_json[:title].should == user.title
    end
  end
  
  context '#singular user' do
    let(:presenter) { Presenter.presenter_for(user, format) }
    let(:json) { presenter.present(user) }
    let(:user_json) { json[:user] }

    it 'should have an outer user element' do
      json.keys.size.should == 1
      json.should have_key(:user)
    end

    it_behaves_like API_V1::UserPresenter
  end

  context '#collections' do
    let(:users) { [user] }
    let(:presenter) { Presenter.presenter_for(users, format) }
    let(:json) { presenter.present(users) }
    let(:user_json) { json[:users].first }

    it 'should have an outer users element containing the list of users' do
      json.keys.size.should == 1
      json.should have_key(:users)
      json[:users].should be_an(Array)
      json[:users].size.should == 1
    end

    it_behaves_like API_V1::UserPresenter
  end
end
