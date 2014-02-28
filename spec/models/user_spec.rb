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
#  response_time          :integer          default(0)
#  provider               :string(255)
#  fb_id                  :string(255)
#  fb_tk                  :string(255)
#

require 'spec_helper'
require 'cancan/matchers'

describe User do
  subject { FactoryGirl.create :user }



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
        let(:product) { FactoryGirl.create :product, owner: user }
        let(:product2) { FactoryGirl.create :product, owner: user2 }

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
          ability.should be_able_to(:manage, Product.new(owner: user))
        end

        it 'cannot :manage product from another' do
          ability.should_not be_able_to(:manage, Product.new(owner: user2))
        end
      end

      context 'concerning a message' do
        let(:product) { FactoryGirl.create :product, owner: user2 }
        let(:status) { FactoryGirl.create :status, product: product, user_id: user.id }

        it 'can :create message' do
          ability.should be_able_to(:create, Message.new(sender_id: user.id, receiver_id: user2.id, status: status, content: 'test'))
        end
      end
    end
  end

  describe 'when creates an user' do

    it 'create a profile' do
      expect {
        subject
      }.to change{Profile.count}.by 1
    end


    it 'sends a welcoming email' do
      subject
      Delayed::Worker.new.work_off
      deliveries_with_subject(I18n.t('notifier.welcome.subject')).count == 1
    end
  end

  describe '#is_owner_of?' do
    subject { FactoryGirl.create :user }
    let(:product) { FactoryGirl.create :product, owner: subject }

    context 'with one of his products' do
      
      it 'returns true' do
        subject.is_owner_of?(product).should == true
      end
    end

    context 'with products from other' do
      let(:user2) { FactoryGirl.create :user }
      let(:product) { FactoryGirl.create :product, owner: user2 }
      
      it 'returns false' do
        subject.is_owner_of?(product).should == false
      end
    end
  end
end
