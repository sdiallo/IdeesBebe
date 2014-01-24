# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  product_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Message do
  let(:product) { FactoryGirl.create :product, user: user }
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  subject { FactoryGirl.create :message, sender: user2, receiver: user, product: product}

  describe 'when creates a message' do

    it 'sends a new_message from buyer email' do
      expect {
        subject
        Delayed::Worker.new.work_off
      }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.from_buyer.subject')).count }.by 1
    end

    context 'when the sender is the owner of the product' do
      let(:product) { FactoryGirl.create :product, user: user }
      let(:user) { FactoryGirl.create :user }
      let(:user2) { FactoryGirl.create :user }
      subject { FactoryGirl.create :message, sender: user, receiver: user2, product: product}

      it 'sends a new_message from seller email' do
        expect {
          subject
          Delayed::Worker.new.work_off
        }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.from_seller.subject')).count }.by 1
      end
    end
  end

  describe '#from_seller?' do

    context 'when the sender is not the owner of the product' do

      it 'returns false' do
        subject.from_seller?.should == false
      end
    end

    context 'when the sender is the owner of the product' do
      let(:product) { FactoryGirl.create :product, user: user }
      let(:user) { FactoryGirl.create :user }
      let(:user2) { FactoryGirl.create :user }
      subject { FactoryGirl.create :message, sender: user, receiver: user2, product: product}

      it 'returns true' do
        subject.from_seller?.should == true
      end
    end
  end
end
