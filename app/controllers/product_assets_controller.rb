class ProductAssetsController < ApplicationController


  load_and_authorize_resource :product_asset, except: :create
  load_resource :product, only: :create

  def create
    raise CanCan::AccessDenied if @product.user != current_user
    asset = @product.assets.build(asset_params)
    if not asset.file? or not asset.valid?
      alert = I18n.t('asset.file.non-valid')
    elsif asset.save!
      alert = I18n.t('asset.create.success')
    else
      alert = I18n.t('asset.create.error')
    end
    redirect_to edit_product_path(@product.slug), alert: alert
  end

  # PUT /product_asset/1
  def update
    if @product_asset.update(asset_params)
      flash[:notice] = I18n.t('asset.become_starred.success')
    else
      flash[:alert] = I18n.t('asset.become_starred.error')
    end
    redirect_to edit_product_path(@product_asset.product.slug)
  end

  # DELETE /product_asset/1
  def destroy
    if @product_asset.destroy
      flash[:notice] = I18n.t('asset.destroy.success')
    else
      flash[:alert] = I18n.t('asset.destroy.error')
    end
    redirect_to edit_product_path(@product_asset.product.slug)
  end

  private

    def asset_params
      params.require(:product_asset).permit(:file, :starred)
    end
end
