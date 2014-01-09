require 'spec_helper'

describe ProductAssetsController do
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  let(:product) { FactoryGirl.create :product, user_id: user.id}
  let(:product2) { FactoryGirl.create :product, user_id: user2.id}


  before(:each) { sign_in user }

  describe 'DELETE #destroy' do
  
    context 'for the product assets' do
      let(:asset2) { FactoryGirl.create :product_asset, product: product2 }
      let(:asset3) { FactoryGirl.create :product_asset, product: product }
      subject { FactoryGirl.create :product_asset, product: product }

      context 'with my product' do
        it 'destroys asset' do
          asset3
          subject
          delete :destroy, { id: subject }
          ProductAsset.exists?(subject).should == false        
        end

        it 'redirect to #edit' do
          asset3
          subject
          delete :destroy, { id: subject.id }
          response.should redirect_to edit_product_path(product.slug)
        end

        context 'with a failed destroy' do
          it 'flash an error' do
            ProductAsset.any_instance.stub(:destroy).and_return(false)
            subject
            delete :destroy, { id: subject.id }
            flash[:alert].should_not be_nil
          end
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

  describe 'PUT #update' do
    let(:asset2) { FactoryGirl.create :product_asset, product: product }
    subject { FactoryGirl.create :product_asset, product: product }

    context 'with my product' do
      it 'unstars the other starred asset' do
        asset2
        subject
        put :update, { id: subject.id, product_asset: { starred: true } }       
        asset2.reload.starred.should == false
      end

      it 'stars the asset' do
        asset2
        subject
        put :update, { id: subject.id, product_asset: { starred: true } }
        subject.reload.starred.should == true
      end

      it 'redirect to #edit' do
        subject
        put :update, { id: subject.id, product_asset: { starred: true } }
        response.should redirect_to edit_product_path(product.slug)
      end

      context 'with a failed changed' do
        it 'flash an error' do
          ProductAsset.any_instance.stub(:update).and_return(false)
          subject
          put :update, { id: subject.id, product_asset: { starred: true } }
          flash[:alert].should_not be_nil
        end
      end
    end

    context 'with product from other' do
      let(:asset2) { FactoryGirl.create :product_asset, product: product2 }

      it 'redirect to forbidden' do
        put :update, { id: asset2.id }
        response.should redirect_to forbidden_path
      end
    end
  end
end