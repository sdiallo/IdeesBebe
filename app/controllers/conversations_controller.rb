class ConversationsController < ApplicationController

  load_and_authorize_resource :product, find_by: :slug, id_param: :product_id
  load_resource :conversation, only: :show

  def index
    @conversations = @product.conversations
  end

  def show
  end
end
