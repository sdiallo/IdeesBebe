class AssetsController < ApplicationController

  before_action :set_asset
  before_action :must_be_current_user

  # PUT /products/1/asset/1
  def become_starred
    @asset.become_starred
    redirect_to @@redirect
  end

  def destroy
    @asset.remove_asset!
    @asset.destroy
    redirect_to @@redirect
  end

  private
    def set_asset
      @asset = Asset.find(params[:id])
      if @asset.referencer_type == 'Profile'
        @profile = Profile.find(@asset.referencer_id)
        @user = @profile.user
        @@redirect = edit_profile_path(@user.slug)
      else
        @product = Product.find(@asset.referencer_id)
        @user = @product.user
        @@redirect = edit_product_path(@product.slug)
      end 
    end
end
