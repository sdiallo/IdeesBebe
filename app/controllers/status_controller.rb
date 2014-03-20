class StatusController < ApplicationController

  authorize_resource :status
  
  load_resource :product
  load_resource :user, find_by: :slug, id_param: :id, except: :index

  def index
    raise CanCan::AccessDenied if not current_user.is_owner_of? @product
    @status = @product.status.order('done ASC, closed ASC')
  end

  def show
    raise CanCan::AccessDenied unless current_user.is_owner_of? @product or current_user == @user
    @status = Status.find_by(user_id: @user.id, product_id: @product.id)
    @receiver = current_user.is_owner_of?(@product) ? @status.user : @product.owner
    @messages = @status.messages.order(:created_at)
  end

  def update
    raise CanCan::AccessDenied unless current_user.is_owner_of? @product
    @status = Status.find_by(user_id: @user.id, product_id: @product.id)
    @status.update(status_params)

    respond_to do |format|
      format.html { redirect_to product_status_path(@product.slug, @status.user.slug) }
      format.js
    end
  end

  private

    def status_params
      params.require(:status).permit(:closed, :done)      
    end
end
