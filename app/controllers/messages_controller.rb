class MessagesController < ApplicationController

  authorize_resource :message
  load_resource :product

  def create

    conversation = Conversation.find(message_params[:conversation_id]) if message_params[:conversation_id].present?
    conversation ||= Conversation.find_or_create_by(product: @product, user_id: current_user)

    message = conversation.messages.build(message_params.merge(sender: current_user))
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
      params.require(:message).permit(:content, :conversation_id)
    end
end
