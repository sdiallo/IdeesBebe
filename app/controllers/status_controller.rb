class StatusController < ApplicationController

  authorize_resource :status
  
  load_resource :product, find_by: :slug, id_param: :product_id
  load_resource :user, find_by: :slug, id_param: :id, except: :index

  def index
    raise CanCan::AccessDenied if not current_user.is_owner_of? @product
    @status = @product.status
  end

  def show
    raise CanCan::AccessDenied unless current_user.is_owner_of? @product or current_user == @user
    @status = Status.find_by(user_id: @user.id, product_id: @product.id)
    @messages = @status.messages.order('created_at DESC')
  end

  def update
    raise CanCan::AccessDenied unless current_user.is_owner_of? @product
    status = Status.find_by(user_id: @user.id, product_id: @product.id)
    status.update(status_params)
    redirect_to action: :index
  end

  private

    def status_params
      params.require(:status).permit(:closed, :done)      
    end
end
