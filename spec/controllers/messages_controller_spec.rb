require 'spec_helper'

describe MessagesController do

  let(:product) { FactoryGirl.create :product, user: user }
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  subject { FactoryGirl.create :message }
  
  before(:each) do
    sign_in user
  end

  describe '#create' do

    it 'creates the message' do
      expect {
        post :create, product_id: product.id, message: { sender_id: user2.id, content: 'test' }
      }.to change{ Message.count }.by 1
    end

    it 'creates an associated conversation' do
      expect {
        post :create, product_id: product.id, message: { sender_id: user2.id, content: 'test' }
      }.to change{ Conversation.count }.by 1
    end

    it 'redirect to the product page' do
      post :create, product_id: product.id, message: { sender_id: user2.id, content: 'test' }
      response.should redirect_to product_path(product.slug)
    end

    context 'with already a conversation' do
      subject { FactoryGirl.create :message, conversation: conversation }
      let(:conversation) { FactoryGirl.create :conversation, user_id: user2.id, product: product }

      it 'does not create an associated conversation' do
        subject
        expect {
          post :create, product_id: product.id, message: { sender_id: user2.id, content: 'test' }
        }.to change{ Conversation.count }.by 0
      end

      it 'use the conversation' do
        subject
        post :create, product_id: product.id, message: { sender_id: user2.id, content: 'test' }
        Message.last.conversation_id.should == conversation.id
      end
    end

    context 'with an incorrect comment' do

      it 'raise an error' do
        Message.any_instance.stub(:save).and_return(false)
        Message.any_instance.stub(:errors).and_return([:content, "Too short"])
        post :create, product_id: product.id, message: { sender_id: user2.id, content: '' }
        flash[:error].should_not be_nil
      end
    end

    context 'with a failed create' do

      it 'raise an error' do
        Message.any_instance.stub(:save).and_return(false)
        Message.any_instance.stub(:errors).and_return([])
        post :create, product_id: product.id, message: { sender_id: user2.id, content: 'test' }
        flash[:error].should_not be_nil
      end
    end
  end
end