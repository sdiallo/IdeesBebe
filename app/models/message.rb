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

  def from_owner?
    product.owner == sender
  end

  private

    def still_pending?
      product.last_message_with(sender) == self
    end

    def reminder_owner
      Notifier.reminder_owner(self).deliver if still_pending?
    end
    handle_asynchronously :reminder_owner, run_at: ->(message) { message.created_at + 3.days }
end
