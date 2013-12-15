# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  slug             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  main_category_id :integer
#

require 'spec_helper'

describe Category do

  describe '#all_product' do
    subject { FactoryGirl.create :category, main_category_id: main.id }
    let(:main) { FactoryGirl.create :category}
    let(:product) { FactoryGirl.create :product, name: "lol", category_id: subject.id }
    let(:product2) { FactoryGirl.create :product, name: "lol1",  category_id: subject.id }
    let(:product3) { FactoryGirl.create :product, name: "lol2",  category_id: subject.id }
   

    context 'with a subcategory' do
      it 'returns all the products this category' do
        product
        product2
        product3
        subject.all_products.map(&:id).should == [product3, product2, product].map(&:id)
      end
    end

    context 'with a main category' do
      let(:category2) { FactoryGirl.create :category, main_category_id: main.id }
      let(:product3) { FactoryGirl.create :product, name: "lol2",  category_id: category2.id }

      it 'returns all the products of his subcategories' do
        product
        product2
        product3
        main.all_products.map(&:id).should == [product3, product, product2].map(&:id)
      end
    end
  end
end
