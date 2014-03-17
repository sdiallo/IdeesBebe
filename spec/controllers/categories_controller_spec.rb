require 'spec_helper'

describe CategoriesController do
  let(:user){ FactoryGirl.create :user }
  let(:user2){ FactoryGirl.create :user }
  let(:category) { FactoryGirl.create :category, main_category_id: main.id }
  let(:main) { FactoryGirl.create :category }
  let(:product) { FactoryGirl.create :product, name: "lol", owner: user, category_id: category.id }
  let(:status) { FactoryGirl.create :status, product_id: product.id, done: true, user_id: user2.id }
  let(:product2) { FactoryGirl.create :product, name: "lol", owner: user, category_id: category.id }
  let(:status2) { FactoryGirl.create :status, product_id: product2.id, done: false, user_id: user2.id }
  let(:product3) { FactoryGirl.create :product, name: "lol", owner: user, category_id: category.id }

  before(:each) do
    status
    status2
    product3
  end

  describe '#show' do
    before(:each) do
      get :show, { id: main.slug }
    end

    it 'assigns @category' do
      assigns(:category).should == main
    end

    it 'assigns @products' do
      assigns(:products).should == [product3, product2, product]
    end

    it 'render show template' do
      response.should render_template :show
    end
  end

  describe '#show_subcategory' do
    before(:each) do
      get :show_subcategory, { category_id: main.slug, id: category.slug }
    end

    it 'assigns @category' do
      assigns(:category).should == main
    end

    it 'assigns @subcategory' do
      assigns(:subcategory).should == category
    end

    it 'assigns @products' do
      assigns(:products).should == [product3, product2, product]
    end

    it 'render show_subcategory template' do
      response.should render_template :show_subcategory
    end
  end
end