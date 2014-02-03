class MessagesController < ApplicationController

  authorize_resource :message
  load_resource :product, find_by: :slug, id_param: :product_id, only: :index
  load_resource :product, only: :create

  def index
    @messages = @product.last_messages
  end

  def show
    
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
    redirect_to product_path(@product.slug)
  end

  private

    def message_params
      params.require(:message).permit(:content, :receiver_id)
    end
end
