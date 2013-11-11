require 'spec_helper'

describe User do
  describe 'Correctly create user' do
    describe "#username_to_slug" do
      let(:user) { FactoryGirl.create :user, username: 'mom & dad @home!' }

      it "generate the right slug on create" do
        user
        user.slug.should == "mom_and_dad_at_home"
      end

      it "generate the right slug on update" do
        user
        user.update_attributes(username: 'test on @test')
        user.slug.should == "test_on_at_test"
      end
    end
  end
end
