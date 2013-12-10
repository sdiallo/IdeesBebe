class AssetsController < ApplicationController

  load_and_authorize_resource :asset


  # PUT /products/1/asset/1
  def become_starred
    if @asset.become_starred
      flash[:notice] = I18n.t('asset.become_starred.success')
    else
      flash[:error] = I18n.t('asset.become_starred.error')
    end
    @product = Product.find(@asset.referencer_id)
    redirect_to edit_product_path(@product.slug)
  end

  def destroy
    if @asset.referencer_type == 'Profile'
      @user = Profile.find(@asset.referencer_id).user
      redirect = edit_profile_path(@user.slug)
    else
      @product = Product.find(@asset.referencer_id)
      redirect = edit_product_path(@product.slug)
    end

    if @asset.destroy
      flash[:notice] = I18n.t('asset.destroy.success')
    else
      flash[:error] = I18n.t('asset.destroy.error')
    end
    redirect_to redirect
  end
end
