# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Report do

  describe 'when creates' do
    let(:user4) { FactoryGirl.create :user }
    let(:user3) { FactoryGirl.create :user }
    let(:user2) { FactoryGirl.create :user }
    let(:report4) { FactoryGirl.create :report, product: product, user: user2 }
    let(:report3) { FactoryGirl.create :report, product: product, user: user3 }
    let(:report2) { FactoryGirl.create :report, product: product, user: user4 }
    let(:user) { FactoryGirl.create :user }
    let(:admin) { FactoryGirl.create :user, is_admin: true }
    let(:product) { FactoryGirl.create :product, owner: user }

    context 'when it is the third report for a given product' do
      before(:each) do
        report2
        report3
      end

      it 'the product allowed field becomes nil (waiting admin check)' do
        expect {
          report4
        }.to change{product.allowed}.to nil
      end

      it 'sends an email to the admin' do
        admin
        report4
        expect {
          Delayed::Worker.new.work_off
        }.to change{deliveries_with_subject(I18n.t('notifier.admin_need_to_check.subject', product: product.name)).count}.by 1
      end
    end
  end
end
