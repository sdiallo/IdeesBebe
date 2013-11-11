require 'spec_helper'

describe User do
  it_behaves_like Slugable do
    subject { FactoryGirl.create :user, username: "mom & dad @home!" }
  end  
end
