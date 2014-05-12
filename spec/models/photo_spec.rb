# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  product_id :integer
#  file       :string(255)
#  starred    :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Photo do
  subject { create :photo }
  let(:product) { create :product }
  let(:user) { create :user }

  describe 'when creates' do
    context 'a product with already many photos' do
      subject { build :photo, product: product, starred: false }
      let(:photo2) { create :photo, product: product, starred: true }

      it 'does not change the photo' do
        photo2
        subject.save!
        subject.starred.should == false
      end
    end

    context 'a product without photos' do
      subject { build :photo, product: product, starred: false }

      it 'stars the photo' do
        subject.save!
        subject.starred.should == true
      end
    end
  end

  describe '#random_starred' do
    context 'with a product with at least one other photos' do
      subject { create :photo, product: product, starred: false }
      let(:photo2) { create :photo, product: product, starred: true }

      it 'stars one of the other photo' do
        photo2
        subject
        photo2.send(:random_starred)
        subject.reload.starred.should == true
      end
    end
  end
end
