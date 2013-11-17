require 'spec_helper'

describe Profile do

  describe AvatarUploader do
    include CarrierWave::Test::Matchers

    before do
      AvatarUploader.enable_processing = true
      @uploader = AvatarUploader.new(@user, :avatar)
      @uploader.store!(File.open("#{Rails.root}/app/assets/images/default_avatar.png"))
    end

    after do
      AvatarUploader.enable_processing = false
      @uploader.remove!
    end

    context 'avatar version' do
      it "create an avatar with 160x160" do
        @uploader.should have_dimensions(160, 160)
      end
    end

    context 'the thumb version' do
      it "create an avatar with 100x100" do
        @uploader.thumb.should have_dimensions(100, 100)
      end
    end
  end
end