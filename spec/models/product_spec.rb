require 'spec_helper'

describe Product do
  it_behaves_like Slugable do
    subject { FactoryGirl.create :product, name: "mom & dad @home!" }
  end

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

  context 'when update' do
    subject { FactoryGirl.create :product }
    let(:asset) { FactoryGirl.create :asset, product_id: subject.id }

    context 'when add an asset' do

      describe '#set_main_asset' do

        it 'stars the asset' do
          subject.set_main_asset asset
          subject.star_id.should == asset.id
        end
      end
    end
  end
end
