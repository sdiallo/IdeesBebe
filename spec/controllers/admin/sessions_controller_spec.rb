require 'spec_helper'

describe Admin::SessionsController do
  subject { FactoryGirl.create :user, is_admin: true }
  before(:each) { request.env["devise.mapping"] = Devise.mappings[:user] }
  
  describe 'GET #new' do

    it 'render 200' do
      get :new
      response.code.should == '200'
    end

    context 'when the user is already logged in' do
      before(:each) { sign_in subject }

      it 'redirect to dashboard' do
        get :new
        response.should redirect_to admin_dashboard_index_path
      end

      context 'when the user is not an admin' do
        subject { FactoryGirl.create :user, is_admin: false }

        it 'redirect to forbidden' do
          get :new
          response.should redirect_to admin_dashboard_index_path
        end
      end
    end
  end
end