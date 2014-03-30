require 'spec_helper'

describe Admin::BaseController do
  subject { FactoryGirl.create :user, is_admin: false }
  before(:each) { request.env["devise.mapping"] = Devise.mappings[:user] }
  controller do
    def index
      render text: 'Admin namespace !!!'
    end
  end
  
  describe 'Admin namespace accessibility' do

    it 'redirect to admin connection' do
      get :index
      response.should redirect_to admin_path
    end

    context 'when the user is connected and is not an admin' do

      it 'redirect to forbidden' do
        sign_in subject
        get :index
        response.should redirect_to forbidden_path
      end
    end
  end
end