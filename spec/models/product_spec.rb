require 'spec_helper'

describe Product do
  describe 'Correctly create product' do
    describe "#name_to_slug" do
      let(:product) { FactoryGirl.create :product, name: 'mom & dad @home!' }

      it "generate the right slug" do
        product
        product.slug.should == "mom_and_dad_at_home"
      end
    end
  end
end
