class MessagesController < ApplicationController

  authorize_resource :message

  def create
    message = current_user.messages_sent.build(message_params)
    if message.save
      flash[:notice] = I18n.t('message.create.success')
    elsif message.errors.any?
      flash[:error] = message.errors.first[1]
    else
      flash[:error] = I18n.t('message.create.error')
    end
    redirect_to product_path(message.product.slug)
  end

  private

    def message_params
      params.require(:message).permit(:content, :product_id, :receiver_id)
    end
end
