require 'spec_helper'

shared_examples_for Slugable do
  it 'return the right slug' do
    subject.to_slug.should == 'mom_and_dad_at_home'
  end
end