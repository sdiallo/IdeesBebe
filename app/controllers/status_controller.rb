class StatusController < ApplicationController

  authorize_resource :status
  
  load_resource :product, find_by: :slug, id_param: :product_id
  load_resource :user, find_by: :slug, id_param: :id, only: :show

  def index
    raise CanCan::AccessDenied if not current_user.is_owner_of? @product
    @status = @product.status
  end

  def show
    raise CanCan::AccessDenied unless current_user.is_owner_of? @product or current_user == @user
    @status = Status.find_by(user_id: @user.id, product_id: @product.id)
    @avalaible_status = Status.where(product_id: @product.id).where(closed: [nil, false])
    @receiver = current_user.is_owner_of?(@product) ? @status.user : @product.owner
    @messages = @status.messages.order('created_at DESC')
  end
end
