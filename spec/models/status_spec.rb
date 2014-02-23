require 'spec_helper'

describe Status do

  describe 'when updates' do
    let(:product) { FactoryGirl.create :product, owner: user }
    let(:user) { FactoryGirl.create :user, response_time: 0 }
    let(:user2) { FactoryGirl.create :user, response_time: 0 }
    subject { FactoryGirl.create :status, user_id: user2.id, product: product }
    let(:message) { FactoryGirl.create :message, sender_id: user2.id, status: subject, receiver_id: user.id, content: 'test'}

    context 'when the product is inactive and closed the status' do
      let(:product) { FactoryGirl.create :product, owner: user }
      
      it 'reactive the product' do
        product.update_attributes!(active: false)
        message
        subject.update_attributes!(closed: true)
        subject.product.reload.active.should == true
      end
    end
  end
end
