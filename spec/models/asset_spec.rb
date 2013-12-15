# == Schema Information
#
# Table name: assets
#
#  id              :integer          not null, primary key
#  file            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  referencer_id   :integer
#  referencer_type :string(255)
#  starred         :boolean          default(FALSE)
#  uploading       :boolean          default(FALSE)
#

require 'spec_helper'

describe Asset do
  subject { FactoryGirl.create :asset }
  let(:product) { FactoryGirl.create :product }
  let(:user) { FactoryGirl.create :user }

  describe '#product_referencer?' do
    context 'with a product' do
      subject { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name }

      it 'returns true' do
        subject.send(:product_referencer?).should == true
      end
    end

    context 'with other resources' do
      subject { FactoryGirl.create :asset, referencer_id: user.profile.id, referencer_type: user.profile.class.name }

      it 'returns false' do
        subject.send(:product_referencer?).should == false
      end
    end
  end


  describe '#stars_if_first' do
    context 'a product with already many assets' do
      subject { FactoryGirl.build :asset, referencer_id: product.id, referencer_type: product.class.name, starred: false }
      let(:asset2) { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name, starred: true }

      it 'does not change the asset' do
        asset2
        subject.send(:stars_if_first)
        subject.starred.should == false
      end
    end

    context 'a product without assets' do
      subject { FactoryGirl.build :asset, referencer_id: product.id, referencer_type: product.class.name, starred: false }

      it 'stars the asset' do
        subject.send(:stars_if_first)
        subject.starred.should == true
      end
    end
  end

  describe '#random_starred' do
    context 'with a product with at least one other assets' do
      subject { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name, starred: false }
      let(:asset2) { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name, starred: true }

      it 'stars one of the other asset' do
        asset2
        subject
        asset2.send(:random_starred)
        subject.reload.starred.should == true
      end
    end
  end
end
