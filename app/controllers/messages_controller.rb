class MessagesController < ApplicationController

  authorize_resource :message
  load_resource :product

  def create

    conversation = Conversation.find_or_create_by(product_id: params[:product_id], user_id: message_params[:sender_id])
    message = conversation.messages.build(message_params)
    if message.save
      flash[:notice] = I18n.t('message.create.success')
    elsif message.errors.any?
      flash[:error] = message.errors.first[1]
    else
      flash[:error] = I18n.t('message.create.error')
    end
    redirect_to product_path(conversation.product.slug)
  end

  private

    def message_params
      params.require(:message).permit(:content, :sender_id)
    end
end
