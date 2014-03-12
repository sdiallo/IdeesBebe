require 'spec_helper'

describe ReportsController do

  let(:product) { FactoryGirl.create :product, owner: user2 }
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  
  before(:each) do
    sign_in user
  end

  describe '#create' do

    it 'creates the report' do
      product
      expect {
        post :create, product_id: product.slug
      }.to change{Report.count}.by 1
    end

    it 'redirect to product show' do
      product
      post :create, product_id: product.slug
      response.should redirect_to product_path(product.slug)
    end
  end
end
