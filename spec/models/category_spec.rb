require 'spec_helper'

describe Category do

  describe '#all_product' do
    subject { FactoryGirl.create :category, main_category_id: main }
    let(:main) { FactoryGirl.create :category}
  end
end
