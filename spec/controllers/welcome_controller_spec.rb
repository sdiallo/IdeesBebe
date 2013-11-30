require 'spec_helper'

describe WelcomeController do

  describe 'GET #forbidden' do

    it 'render the forbidden views' do
      get :forbidden
      response.should render_template(:file => "#{Rails.root}/public/422.html")
    end

    it 'status to forbidden' do
      get :forbidden
      response.code.should == '403'
    end
  end
end