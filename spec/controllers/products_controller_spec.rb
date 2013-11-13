require 'spec_helper'

describe ProductsController do
  subject { FactoryGirl.create :user }
  let(:user2) { FactoryGirl.create :user }

  before(:each) { sign_in subject }

  describe 'GET #new' do

    context "with my profile" do
      it "authorize to create a product" do
        get :new, profile_id: subject.slug
        expect(assigns(:user)).to eq(subject)
      end
    end

    context "with other profile" do
      it "doesn't authorize to create a product" do
        get :new, profile_id: user2.slug
        expect(response).to redirect_to profile_path(user2.slug)
      end
    end
  end

  describe 'POST #create' do

    context "with my profile" do

      context "with correct params" do
        it "create a product" do
          post :create, profile_id: subject.slug, product: {"name" => "test", "description" => "Great product for a golden test" }
          expect(response).to redirect_to product_path(subject.products.first.slug)
          expect(assigns(:user)).to eq(subject)
        end
      end

      context "with incorrect params" do
        it "doesn't create a product without name" do
          post :create, profile_id: subject.slug, product: {"name" => "", "description" => "Great product for a golden test" }
          subject.products.first.should == nil
          expect(assigns(:user)).to eq(subject)
        end

        it "doesn't create a product without a more than 140char description" do
          post :create, profile_id: subject.slug, product: {"name" => "test", "description" => "Long string"*1000 }
          subject.products.first.should == nil
          expect(assigns(:user)).to eq(subject)
        end
      end
    end

    context "with other profile" do
      it "doesn't authorize to create a product" do
        post :create, profile_id: user2.slug, product: {"name" => "test", "description" => "Great product for a golden test" }
        subject.products.first.should == nil
        expect(response).to redirect_to profile_path(user2.slug)
      end
    end
  end

  describe 'GET #show' do
    let(:product) { FactoryGirl.create :product, user_id: subject.id}
    it 'return 200 with slug' do
      get :show, { id: product.slug }
      expect(assigns(:user)).to eq(subject)
      expect(response.code).to eq('200')
    end

    it 'return 200 with id' do
      get :show, { id: product.id }
      expect(assigns(:user)).to eq(subject)
      expect(response.code).to eq('200')
    end
  end


  describe 'GET #edit' do
  end

  describe 'PUT #update' do
  end


  describe 'DELETE #destroy' do
  end
end