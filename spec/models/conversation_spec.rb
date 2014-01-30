require 'spec_helper'

describe Conversation do

  describe '#last_message' do
    let(:product) { FactoryGirl.create :product, user: user }
    let(:user) { FactoryGirl.create :user }
    let(:user2) { FactoryGirl.create :user }
    let(:message) { FactoryGirl.create :message, sender_id: user2.id, conversation: subject, content: 'test'}
    subject { FactoryGirl.create :conversation, product_id: product.id, user_id: user2.id }

    before(:each) do
      product
      user2
      message
    end

    it 'returns the newest' do
      subject.last_message.id.should == message.id
    end

    context 'with 4 messages' do
      let(:message1) { FactoryGirl.create :message, sender_id: user.id, conversation: subject, content: 'test'}
      let(:message2) { FactoryGirl.create :message, sender_id: user2.id, conversation: subject, content: 'test'}
      let(:message3) { FactoryGirl.create :message, sender_id: user.id, conversation: subject, content: 'test'}

      it 'returns the newest' do
        message1
        message2
        message3
        subject.last_message.id.should == message3.id
      end
    end
  end
end
