# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  closed     :boolean
#  done       :boolean
#  created_at :datetime
#  updated_at :datetime
#  satisfied  :boolean
#

require 'spec_helper'

describe Status do

  describe 'when updates' do
    let(:product) { FactoryGirl.create :product, owner: user }
    let(:user) { FactoryGirl.create :user, response_time: 0 }
    let(:user2) { FactoryGirl.create :user, response_time: 0 }
    subject { FactoryGirl.create :status, user_id: user2.id, product: product }
    let(:message) { FactoryGirl.create :message, sender_id: user2.id, status: subject, receiver_id: user.id, content: 'test'}

    context 'when the selling the product' do
      
      it 'mark the product as selled' do
        message
        subject.update_attributes!(done: true)
        subject.product.reload.selled?.should == true
      end

      it 'sends an email' do
        message
        expect {
          subject.update_attributes!(done: true)
          Delayed::Worker.new.work_off
        }.to change{deliveries_with_subject(I18n.t('notifier.signalized_as_buyer.subject', product: product.name)).count}.by 1
      end
    end
  end
end
