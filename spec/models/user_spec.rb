require 'spec_helper'
require 'cancan/matchers'

describe User do
  it_behaves_like Slugable do
    subject { FactoryGirl.create :user, username: "mom & dad @home!" }
  end

  describe 'Abilities', focus: true do
    subject(:ability){ Ability.new(user) }

    context 'with a guest user' do
      let(:user){ User.new }

      context 'concerning a product' do

        it{ should be_able_to(:index, Product.new) }
      end
    end
  end
end
