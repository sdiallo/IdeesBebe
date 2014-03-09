# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  closed     :boolean
#  done       :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Status < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :messages

  after_update :reactive_product, if: [:closed_changed?]
  after_update :mark_product_as_selled, if: [:done_changed?, :done]

  def mark_product_as_selled
    product.update_attributes!(selled: true)
  end

  def pending_messages_count
    date = messages.where(sender_id: product.user_id).maximum(:created_at) || DateTime.new
    messages
      .where(sender_id: user_id)
      .where('messages.created_at > ?', date)
      .count
  end

  def can_send_message? user
    return messages.order('created_at DESC').limit(1).first.from_owner? ? false : true if user.id == product.user_id
    product.active and not closed and (messages.order('created_at DESC').limit(Message::LIMIT_STRAIGHT).reject{ |msg| msg.sender_id != user.id }.count < Message::LIMIT_STRAIGHT)
  end

  def last_message
    messages.order('messages.created_at DESC').first
  end

  private

    def reactive_product
      product.update_attributes!(active: true) if not product.active
    end
end
