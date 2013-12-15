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
# Indexes
#
#  index_products_on_category_id  (category_id)
#  index_products_on_user_id      (user_id)
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
      let(:asset) { FactoryGirl.create :asset, referencer_id: subject.id, referencer_type: subject.class.name, starred: true }

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
end
