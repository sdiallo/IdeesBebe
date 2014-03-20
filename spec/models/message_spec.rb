# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  sender_id   :integer
#  receiver_id :integer
#  status_id   :integer
#

require 'spec_helper'

describe Message do
  let(:product) { FactoryGirl.create :product, owner: user }
  let(:user) { FactoryGirl.create :user, response_time: 0 }
  let(:user2) { FactoryGirl.create :user, response_time: 0 }
  let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }
  subject { FactoryGirl.create :message, sender_id: user2.id, status: status, receiver_id: user.id, content: 'test'}

  describe 'when creates a message' do

    it 'sends a new_message from buyer email' do
      expect {
        subject
        Delayed::Worker.new.work_off
      }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.from_buyer.subject')).count }.by 1
    end

    context 'when the sender is the owner of the product' do
      let(:message) { FactoryGirl.create :message, sender_id: user2.id, status: status, receiver_id: user.id, content: 'test' }
      subject { FactoryGirl.create :message, sender_id: user.id, status: status, receiver_id: user2.id, content: 'test', created_at: message.created_at + 1.days }

      it 'sends a new_message from owner email' do
        message
        expect {
          subject
          Delayed::Worker.new.work_off
        }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.from_owner.subject')).count }.by 1
      end

      it 'sets the new average response time to the sender' do
        message
        subject.update_attributes!(created_at: message.created_at + 1.days)
        user.reload.response_time.should == 86400
      end

      context 'with three messages for 2 products' do

        let(:product2) { FactoryGirl.create :product, owner: user, name: 'Test1' }
        let(:status2) { FactoryGirl.create :status, user_id: user2.id, product: product2 }
        subject { FactoryGirl.create :message, sender_id: user.id, status: status, receiver_id: user2.id, content: 'test', created_at: message.created_at + 1.days }
        let(:message2) { FactoryGirl.create :message, sender_id: user2.id, status: status2, receiver_id: user.id, content: 'test', created_at: message.created_at + 2.days }
        let(:message3) { FactoryGirl.create :message, sender_id: user.id, status: status2, receiver_id: user2.id, content: 'test', created_at:  message.created_at + 4.days }
        let(:message4) { FactoryGirl.create :message, sender_id: user2.id, status: status2, receiver_id: user.id, content: 'test', created_at: message.created_at + 6.days }
        let(:message5) { FactoryGirl.create :message, sender_id: user.id, status: status2, receiver_id: user2.id, content: 'test', created_at: message.created_at + 6.days + 45.minutes }

        it 'sets correctly the new average response time to the sender' do
          message
          subject
          message2
          message3
          message4
          message5
          user.reload.response_time.should == 261900
        end
      end
    end

    context 'when the product is inactive and the owner replied to one user' do
      let(:product) { FactoryGirl.create :product, owner: user, active: false }
      let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }
      let(:message) { FactoryGirl.create :message, sender_id: user.id, status: status, receiver_id: user2.id, content: 'test'}

      it 'product becomes active' do
        product
        subject
        message
        product.reload.active.should == true
      end
    end
  end

  describe 'Reminder mail to owner' do

    it 'sends an email after 3 days' do
      subject
      Timecop.travel(subject.created_at + 3.days + 10.minutes) do
        Delayed::Worker.new.work_off
        deliveries_with_subject(I18n.t('notifier.reminder_owner_3_days.subject')).count.should == 1
      end
    end

    it 'sends an email after 7 days' do
      subject
      Timecop.travel(subject.created_at + 7.days + 10.minutes) do
        Delayed::Worker.new.work_off
        deliveries_with_subject(I18n.t('notifier.reminder_owner_7_days.subject')).count.should == 1
      end
    end

    context 'when the owner has respond before 3 days'  do
      let(:message) { FactoryGirl.create :message, sender_id: user.id, status: status, receiver_id: user2.id, content: 'test'}
      let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }

      it 'does not send an email' do
        subject
        message
        Timecop.travel(subject.created_at + 3.days + 10.minutes) do
          Delayed::Worker.new.work_off
          deliveries_with_subject(I18n.t('notifier.reminder_owner_3_days.subject')).count.should == 0
        end
      end
    end

    context 'when the owner has closed the status before 3 days'  do
      let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }

      it 'does not send an email' do
        subject
        status.update_attributes!(closed: true)
        Timecop.travel(subject.created_at + 3.days + 10.minutes) do
          Delayed::Worker.new.work_off
          deliveries_with_subject(I18n.t('notifier.reminder_owner_3_days.subject')).count.should == 0
        end
      end
    end


    context 'when the owner has closed the status before 7 days' do
      let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }

      it 'does not send an email' do
        subject
        status.update_attributes!(closed: true, updated_at: subject.created_at + 5.days)
        Timecop.travel(subject.created_at + 7.days + 10.minutes) do
          Delayed::Worker.new.work_off
          deliveries_with_subject(I18n.t('notifier.reminder_owner_7_days.subject')).count.should == 0
        end
      end
    end

    context 'when the owner has respond before 7 days' do
      let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }
      let(:message) { FactoryGirl.create :message, sender_id: user.id, status: status, receiver_id: user2.id, content: 'test'}

      it 'does not send an email' do
        subject
        message
        Timecop.travel(subject.created_at + 7.days + 10.minutes) do
          Delayed::Worker.new.work_off
          deliveries_with_subject(I18n.t('notifier.reminder_owner_7_days.subject')).count.should == 0
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
      let(:status) { FactoryGirl.create :status, user_id: user2.id, product: product }
      let(:message) { FactoryGirl.create :message, sender_id: user.id, status: status, receiver_id: user2.id, content: 'test'}

      it 'returns true' do
        subject
        message.from_owner?.should == true
      end
    end
  end
end
