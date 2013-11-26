require 'spec_helper'

describe AssetsController do
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  let(:product) { FactoryGirl.create :product, user_id: user.id}
  let(:product2) { FactoryGirl.create :product, user_id: user2.id}


  before(:each) { sign_in user }

  describe 'DELETE #destroy' do
    let(:asset2) { FactoryGirl.create :asset, referencer_id: user2.profile.id, referencer_type: 'Profile' }
    subject { FactoryGirl.create :asset, referencer_id: user.profile.id, referencer_type: 'Profile' }
    
    context 'for the user avatar' do

      context 'with my profile' do
        it 'destroys asset' do
          subject
          delete :destroy, { id: subject.id }
          Asset.exists?(subject.id).should == nil        
        end

        it 'redirect to #edit' do
          subject
          delete :destroy, { id: subject.id }
          response.should redirect_to edit_profile_path(user.slug)
        end
      end

      context 'with profile from other' do
        it 'redirect to forbidden' do
          subject
          delete :destroy, { id: asset2.id }
          response.should redirect_to forbidden_path
        end
      end
    end

    context 'for the product assets' do
    let(:asset2) { FactoryGirl.create :asset, referencer_id: product2.id, referencer_type: product2.class.name }
    let(:asset3) { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name }
    subject { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name }

      context 'with my product' do
        it 'destroys asset' do
          asset3
          subject
          delete :destroy, { id: subject.id }
          Asset.exists?(subject.id).should == nil        
        end

        it 'redirect to #edit' do
          asset3
          subject
          delete :destroy, { id: subject.id }
          response.should redirect_to edit_product_path(product.slug)
        end
      end

      context 'with product from other' do
        it 'redirect to forbidden' do
          delete :destroy, { id: asset2.id }
          response.should redirect_to forbidden_path
        end
      end
    end
  end

  describe 'PUT #become_starred' do
    let(:asset2) { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name }
    subject { FactoryGirl.create :asset, referencer_id: product.id, referencer_type: product.class.name }

    context 'with my product' do
      it 'unstars the other starred asset' do
        asset2
        subject
        put :become_starred, { id: subject.id }       
        asset2.reload.starred.should == false        
      end

      it 'stars the asset' do
        asset2
        subject
        put :become_starred, { id: subject.id }
        subject.reload.starred.should == true        
      end

      it 'redirect to #edit' do
        subject
        put :become_starred, { id: subject.id }
        response.should redirect_to edit_product_path(product.slug)
      end
    end

    context 'with product from other' do
      let(:asset2) { FactoryGirl.create :asset, referencer_id: product2.id, referencer_type: product2.class.name }

      it 'redirect to forbidden' do
        put :become_starred, { id: asset2.id }
        response.should redirect_to forbidden_path
      end
    end
  end
end