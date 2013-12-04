require 'spec_helper'

shared_examples_for Slugable do
  it 'return the right slug' do
    subject.to_slug.should == 'mome-dad-home'
  end
end