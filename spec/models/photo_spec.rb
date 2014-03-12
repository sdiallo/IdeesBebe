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

describe Photo, :focus do
  subject { FactoryGirl.create :photo }
  let(:product) { FactoryGirl.create :product }
  let(:user) { FactoryGirl.create :user }

  describe '#stars_if_first' do
    context 'a product with already many photos' do
      subject { FactoryGirl.build :photo, product: product, starred: false }
      let(:photo2) { FactoryGirl.create :photo, product: product, starred: true }

      it 'does not change the photo' do
        photo2
        subject.send(:stars_if_first)
        subject.starred.should == false
      end
    end

    context 'a product without photos' do
      subject { FactoryGirl.build :photo, product: product, starred: false }

      it 'stars the photo' do
        subject.send(:stars_if_first)
        subject.starred.should == true
      end
    end
  end

  describe '#random_starred' do
    context 'with a product with at least one other photos' do
      subject { FactoryGirl.create :photo, product: product, starred: false }
      let(:photo2) { FactoryGirl.create :photo, product: product, starred: true }

      it 'stars one of the other photo' do
        photo2
        subject
        photo2.send(:random_starred)
        subject.reload.starred.should == true
      end
    end
  end
end
