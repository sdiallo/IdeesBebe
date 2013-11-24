require 'spec_helper'

describe CommentsController do
  let(:user) { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }
  let(:product) { FactoryGirl.create :product, user_id: user.id}
  let(:product2) { FactoryGirl.create :product, user_id: user2.id}

  describe 'POST #create' do
    subject { FactoryGirl.build :comment }
    
    context 'for the product comments' do

      context 'with signed in user' do
        before(:each) do
          product
          sign_in user
        end
        
        it 'create the comment' do
          post :create, { product_id: product.slug, comment: { content: "test" } }
          product.reload.comments.first.should_not == nil        
        end

        it 'assign the comment to the product' do
          post :create, { product_id: product.slug, comment: { content: "test" } }
          product.reload.comments.first.product_id.should == product.id
        end

        it 'assign the comment to the user' do
          post :create, { product_id: product.slug, comment: { content: "test" } }
          product.reload.comments.first.user_id.should == user.id
        end
      end

      context 'with unsigned user' do
        it 'redirect to forbidden' do
          post :create, { product_id: product.slug, comment: { content: "test" } }
          response.should redirect_to forbidden_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for the product comments' do

      context 'with signed in user' do

        context 'with my comment' do
          before(:each) do
            product
            sign_in user
          end
          subject { FactoryGirl.create :comment, user_id: user.id, product_id: product.id }
          
          it 'delete the comment' do
            subject
            delete :destroy, { id: subject.id }
            Comment.exists?(subject).should == nil        
          end
        end

        context 'with other comment' do
          subject { FactoryGirl.create :comment, user_id: user2.id, product_id: product.id }

          it 'redirect to forbidden' do
            sign_in user
            subject
            delete :destroy, { id: subject.id }
            response.should redirect_to forbidden_path
          end
        end
      end

      context 'with unsigned user' do
        subject { FactoryGirl.create :comment, user_id: user.id, product_id: product.id }
        it 'redirect to forbidden' do
          subject
          delete :destroy, { id: subject.id }
          response.should redirect_to forbidden_path
        end
      end
    end

  end
end