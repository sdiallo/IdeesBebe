require 'spec_helper'

describe MessagesController do

  let(:product) { FactoryGirl.create :product, user: user }
  let(:user) { FactoryGirl.create :user }
  subject { FactoryGirl.create :message }
  
  before(:each) do
    sign_in user
  end

  describe '#create' do
    subject { FactoryGirl.build :message }

    it 'create the message' do
      expect {
        post :create, message: { receiver_id: product.user.id, product_id: product.id, content: 'test' }
      }.to change{ Message.count }.by 1
    end

    it 'redirect to the product page' do
      post :create, message: { receiver_id: product.user.id, product_id: product.id, content: 'test' }
      response.should redirect_to product_path(product.slug)
    end

    context 'with an incorrect comment' do

      it 'raise an error' do
        Message.any_instance.stub(:save).and_return(false)
        Message.any_instance.stub(:errors).and_return([:content, "Too short"])
        post :create, message: { receiver_id: product.user.id, product_id: product.id, content: '' }
        flash[:error].should_not be_nil
      end
    end

    context 'with a failed create' do

      it 'raise an error' do
        Message.any_instance.stub(:save).and_return(false)
        Message.any_instance.stub(:errors).and_return([])
        post :create, message: { receiver_id: product.user.id, product_id: product.id, content: 'test' }
        flash[:error].should_not be_nil
      end
    end
  end
end