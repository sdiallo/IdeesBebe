class MessagesController < ApplicationController

  authorize_resource :message
  load_resource :product, find_by: :slug, id_param: :product_id, only: [:index, :show]
  load_resource :product, only: :create
  load_resource :user, find_by: :slug, id_param: :id, only: :show

  def index
    @messages = @product.last_messages
  end

  def show
    @messages = @product.messages.with(@user)
    @last_message = @messages.last
  end

  def create
    message = @product.messages.build(message_params.merge(sender_id: current_user.id))
    if message.save
      flash[:notice] = I18n.t('message.create.success')
    elsif message.errors.any?
      flash[:error] = message.errors.first[1]
    else
      flash[:error] = I18n.t('message.create.error')
    end
    
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to product_path(@product.slug)
  end

  private

    def message_params
      params.require(:message).permit(:content, :receiver_id)
    end
end
