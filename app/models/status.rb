class Status < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :messages

  def pending_messages_count
    date = messages.where(sender_id: product.user_id).maximum(:created_at) || DateTime.new
    messages
      .where(sender_id: user_id)
      .where('messages.created_at > ?', date)
      .count
  end
end
