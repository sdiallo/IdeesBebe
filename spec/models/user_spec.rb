require 'spec_helper'

describe User, focus: true do
  describe 'Correctly create user' do
    describe "#username_to_slug" do
      let(:user) { FactoryGirl.create :user, username: 'mom & dad @home!' }
      it "generate the right slug" do
        user
        user.slug.should == "mom_and_dad_at_home"
      end
    end

  end
end
