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
  subject { FactoryGirl.create :message, user: user, product: product}

  describe 'when creates a message' do

    it 'sends a new_message email' do
      expect {
        subject
        Delayed::Worker.new.work_off
      }.to change{ deliveries_with_subject(I18n.t('notifier.new_message.subject')).count }.by 1
    end
  end
end
