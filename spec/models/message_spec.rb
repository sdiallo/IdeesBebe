# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  sender_id   :integer
#  product_id  :integer
#  receiver_id :integer
#

require 'spec_helper'

describe Message do
  let(:product) { FactoryGirl.create :product, owner: user }
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  subject { FactoryGirl.create :message, sender_id: user2.id, product: product, receiver_id: user.id, content: 'test'}

  describe 'when creates a message' do

    it 'sends a new_message from buyer email' do
      expect {
        subject
        Delayed::Worker.new.work_off
      }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.from_buyer.subject')).count }.by 1
    end

    context 'when the sender is the owner of the product' do
      let(:message) { FactoryGirl.create :message, sender_id: user2.id, product: product, receiver_id: user.id, content: 'test'}
      subject { FactoryGirl.create :message, sender_id: user.id, product: product, receiver_id: user2.id, content: 'test'}

      it 'sends a new_message from seller email' do
        message
        expect {
          subject
          Delayed::Worker.new.work_off
        }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.from_owner.subject')).count }.by 1
      end
    end
  end

  describe 'Reminder mail to owner' do

    context 'when the owner has not respond after 3 days' do

      it 'sends an email' do
        subject
        Timecop.travel(subject.created_at + 3.days + 10.minutes) do
          Delayed::Worker.new.work_off
          deliveries_with_subject(I18n.t('notifier.reminder_owner.subject')).count.should == 1
        end
      end
    end

    context 'when the owner has respond before 3 days' do
      let(:message) { FactoryGirl.create :message, sender_id: user.id, product: product, receiver_id: user2.id, content: 'test'}

      it 'does not send an email' do
        subject
        message
        Timecop.travel(subject.created_at + 3.days + 10.minutes) do
          Delayed::Worker.new.work_off
          deliveries_with_subject(I18n.t('notifier.reminder_owner.subject')).count.should == 0
        end
      end
    end
  end

  describe '#from_owner?' do

    context 'when the sender is not the owner of the product' do

      it 'returns false' do
        subject.from_owner?.should == false
      end
    end

    context 'when the sender is the owner of the product' do
      subject { FactoryGirl.create :message, sender_id: user.id, product: product, receiver_id: user2.id, content: 'test'}

      it 'returns true' do
        subject.from_owner?.should == true
      end
    end
  end
end
