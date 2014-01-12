class ProductAssetsController < ApplicationController


  load_and_authorize_resource :product_asset, except: :create
  load_resource :product, only: :create


  before_action :rename_cancan_var

  def create
    raise CanCan::AccessDenied if @product.user != current_user
    return redirect_to edit_product_path(@product.slug), alert: I18n.t('asset.file.presence') if not asset_params[:file].present?
    authorized_upload(asset_params[:file])
    asset = @product.assets.build(asset_params)
    if asset.save
      redirect_to edit_product_path(@product.slug), alert: I18n.t('asset.create.success')
    else
      redirect_to edit_product_path(@product.slug), alert: I18n.t('asset.create.error')
    end
  end

  # PUT /product_asset/1
  def update
    if @asset.update(asset_params)
      flash[:notice] = I18n.t('asset.become_starred.success')
    else
      flash[:alert] = I18n.t('asset.become_starred.error')
    end
    redirect_to edit_product_path(@asset.product.slug)
  end

  # DELETE /product_asset/1
  def destroy
    if @asset.destroy
      flash[:notice] = I18n.t('asset.destroy.success')
    else
      flash[:alert] = I18n.t('asset.destroy.error')
    end
    redirect_to edit_product_path(@asset.product.slug)
  end

  private
    #TODO: Trouver une solution avec cancan
    def rename_cancan_var
      @asset = @product_asset
    end

    def asset_params
      params.require(:product_asset).permit(:file, :starred)
    end
end