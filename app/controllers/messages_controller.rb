class MessagesController < ApplicationController

  authorize_resource :message
  load_resource :product, only: :create
  load_resource :user, find_by: :slug, id_param: :profile_id, only: :index

  def index
    raise CanCan::AccessDenied if @user != current_user
    @state = params[:state]
    @status = params[:state] == 'pending' ? @user.conversations.pending(@user) : @user.conversations.try("#{@state}")
    @status ||= @user.conversations
    @status = @status.sort_by(&:updated_at).reverse
  end

  def create
    status = message_params[:status_id].present? ? Status.find(message_params[:status_id]) : @product.status.create!(user_id: current_user.id)
    message = status.messages.build(message_params.merge(sender_id: current_user.id))
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
      params.require(:message).permit(:content, :receiver_id, :status_id)
    end
end
