# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#  slug                   :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require 'spec_helper'
require 'cancan/matchers'

describe User do
  it_behaves_like Slugable do
    subject { FactoryGirl.create :user, username: "momé dad hOme" }
  end

  describe 'Abilities' do
    subject(:ability){ Ability.new(user) }

    context 'with a guest user' do
      let(:user){ User.new }

      context 'concerning a product' do

        it 'can :index on Product' do
          ability.should be_able_to(:index, Product.new)
        end

        it 'can :show on all the ressources' do
          ability.should be_able_to(:show, :all)
        end
      end
    end

    context 'with a connected user' do
      let(:user) { FactoryGirl.create :user }
      let(:user2) { FactoryGirl.create :user }

      before(:each) { user.stub(:new_record?).and_return(false) }

      context 'concerning a comment' do

        it 'can :create a comment' do
          ability.should be_able_to(:create, Comment.new)
        end

        it 'can :destroy his comment' do
          ability.should be_able_to(:destroy, Comment.new(user: user))
        end

        it 'cannot :destroy comment from another' do
          ability.should_not be_able_to(:destroy, Comment.new(user: user2))
        end
      end

      context 'concerning a user' do

        it 'can :destroy his account' do
          ability.should be_able_to(:destroy, user)
        end

        it 'cannot :destroy comment from another' do
          ability.should_not be_able_to(:destroy, user2)
        end
      end

      context 'concerning an product asset' do
        let(:product) { FactoryGirl.create :product, user: user }
        let(:product2) { FactoryGirl.create :product, user: user2 }

        it 'can :destroy asset for his product' do
          ability.should be_able_to(:destroy, ProductAsset.new(product: product))
        end

        it 'cannot :destroy asset from product of another' do
          ability.should_not be_able_to(:destroy, ProductAsset.new(product: product2))
        end

        it "can stars (:update) one of his product's assets" do
          ability.should be_able_to(:update, ProductAsset.new(product: product))
        end

        it "cannot stars (:update) asset from product of another" do
          ability.should_not be_able_to(:update, ProductAsset.new(product: product2))
        end
      end

      context 'concerning a profile' do

        it 'can :manage his profile' do
          ability.should be_able_to(:manage, Profile.new(user: user))
        end

        it 'cannot :manage profile from another' do
          ability.should_not be_able_to(:manage, Profile.new(user: user2))
        end
      end

      context 'concerning a product' do

        it 'can :manage his product' do
          ability.should be_able_to(:manage, Product.new(user: user))
        end

        it 'cannot :manage product from another' do
          ability.should_not be_able_to(:manage, Product.new(user: user2))
        end
      end
    end
  end
end
