# == Schema Information
#
# Table name: product_assets
#
#  id         :integer          not null, primary key
#  product_id :integer
#  file       :string(255)
#  starred    :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ProductAsset do
  subject { FactoryGirl.create :product_asset }
  let(:product) { FactoryGirl.create :product }
  let(:user) { FactoryGirl.create :user }

  describe '#stars_if_first' do
    context 'a product with already many assets' do
      subject { FactoryGirl.build :product_asset, product: product, starred: false }
      let(:asset2) { FactoryGirl.create :product_asset, product: product, starred: true }

      it 'does not change the asset' do
        asset2
        subject.send(:stars_if_first)
        subject.starred.should == false
      end
    end

    context 'a product without assets' do
      subject { FactoryGirl.build :product_asset, product: product, starred: false }

      it 'stars the asset' do
        subject.send(:stars_if_first)
        subject.starred.should == true
      end
    end
  end

  describe '#random_starred' do
    context 'with a product with at least one other assets' do
      subject { FactoryGirl.create :product_asset, product: product, starred: false }
      let(:asset2) { FactoryGirl.create :product_asset, product: product, starred: true }

      it 'stars one of the other asset' do
        asset2
        subject
        asset2.send(:random_starred)
        subject.reload.starred.should == true
      end
    end
  end
end
