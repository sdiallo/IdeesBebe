# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  sender_id   :integer
#  product_id  :integer
#  receiver_id :integer
#

class Message < ActiveRecord::Base
  
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  belongs_to :product
  
  validates :content,
    length: {
      minimum: 2,
      maximum: 250,
      message: I18n.t('comment.content.length')
    },
    presence: { message: I18n.t('comment.content.presence') }

  scope :with, ->(user) { where('sender_id = ? OR receiver_id = ?', user.id, user.id) }
  
  after_create ->(message) { Notifier.new_message(message).deliver }
  after_create :reminder_owner, unless: :from_owner?
  after_create :average_response_time, if: :from_owner?

  def from_owner?
    product.owner == sender
  end

  private

    def average_response_time
      last_message = Message.where(product_id: product_id, receiver_id: sender_id, sender_id: receiver_id).order('created_at DESC').pluck(:created_at).first
      diff = sender.response_time + (created_at.to_i - last_message.to_i)

      sender.update_attributes!(response_time: diff/Message.where(sender_id: sender_id).count)
    end

    def still_pending?
      product.last_message_with(sender) == self
    end

    def reminder_owner
      Notifier.reminder_owner(self).deliver if still_pending?
    end
    handle_asynchronously :reminder_owner, run_at: ->(message) { message.created_at + 3.days }
end
