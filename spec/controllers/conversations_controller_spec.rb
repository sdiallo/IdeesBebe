require 'spec_helper'

describe ConversationsController do

  let(:product) { FactoryGirl.create :product, user: user }
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  subject { FactoryGirl.create :conversation, product: product, user_id: user2.id }
  
  before(:each) do
    sign_in user
  end

  describe 'GET #show' do
  end
end