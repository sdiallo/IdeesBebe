# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  category_id :integer
#

require 'spec_helper'

describe Product do
  it_behaves_like Slugable do
    subject { FactoryGirl.create :product, name: "momé dad hOme" }
  end

  subject { FactoryGirl.create :product }

  context 'when create' do
    it 'fails without name' do
      FactoryGirl.build(:product, name: "").should_not be_valid
    end

    it 'fails if the name is already taken' do
      FactoryGirl.build(:product, name: subject.name).should_not be_valid
    end

    it 'fails if the description is too long' do
      FactoryGirl.build(:product, description: "1000"*1000).should_not be_valid
    end
  end


  describe '#starred_asset' do

    context 'with assets' do
      let(:asset) { FactoryGirl.create :product_asset, product: subject, starred: true }

      it 'return the starred asset' do
        asset
        subject.starred_asset.model.id.should == asset.id
      end
    end

    context 'with no assets' do

      it 'return nil' do
        subject.starred_asset.should == nil
      end
    end
  end

  describe '#has_maximum_upload?' do

    context 'with already too many assets' do
      let(:asset) { FactoryGirl.create :product_asset, product: subject }
      let(:asset2) { FactoryGirl.create :product_asset, product: subject }

      it 'return true' do
        asset
        asset2
        subject.has_maximum_upload?.should == true
      end
    end

    context 'without too many assets' do

      it 'return false' do
        subject.has_maximum_upload?.should == false
      end
    end
  end
end
