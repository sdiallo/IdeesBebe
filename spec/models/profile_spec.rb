# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

require 'spec_helper'

describe Profile do
  subject { user.profile }
  let(:user) { FactoryGirl.create :user }

  describe '#has_avatar?' do

    context 'with an avatar' do
      it 'returns true' do
        subject.build_asset
        subject.save!
        subject.send(:has_avatar?).should == true
      end
    end

    context 'without an avatar' do
      it 'returns false' do
        subject.send(:has_avatar?).should == false
      end
    end
  end
end
