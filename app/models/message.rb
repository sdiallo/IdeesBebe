# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  sender_id   :integer
#  receiver_id :integer
#  status_id   :integer
#

class Message < ActiveRecord::Base
  
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  belongs_to :status

  LIMIT_STRAIGHT = 2
  
  validates :content,
    length: {
      minimum: 2,
      maximum: 250,
      message: I18n.t('comment.content.length')
    },
    presence: { message: I18n.t('comment.content.presence') }

  scope :with, ->(user) { where('sender_id = ? OR receiver_id = ?', user.id, user.id) }
  
  after_create ->(message) { Notifier.delay.new_message(message) }
  after_create :reminder_owner_3_days, unless: :from_owner?
  after_create :reminder_owner_7_days, unless: :from_owner?
  after_create :unactive_product, unless: :from_owner?
  after_create :reactive_product, unless: :product_is_active?
  after_create :response_time, if: :from_owner?

  def from_owner?
    status.product.owner == sender
  end

  private

    # Reactive product for owner

    def product_is_active?
      status.product.active
    end

    def reactive_product
      status.product.update_attributes!(active: true)
    end

    # Response time for owner

    def response_time
      owner_msg = status.messages.where(sender_id: sender_id).where('messages.id != ?', id).maximum(:created_at)
      query = Message.joins(:status)
        .where('messages.status_id = ?', status_id)
        .where('messages.receiver_id = ?', sender_id)
      query = query.where('messages.created_at > ?', owner_msg) if not owner_msg.nil?

      query = query.minimum(:created_at)

      time = sender.response_time + (created_at.to_i - query.to_i)
      sender.update_attributes!(response_time: time)
    end


    # Reminder for owner

    def need_to_remember?
      (status.product.last_message_with(sender)) == self and status.product.avalaible? and not status.closed
    end

    def reminder_owner_3_days
      Notifier.reminder_owner_3_days(self).deliver if need_to_remember?
    end
    handle_asynchronously :reminder_owner_3_days, run_at: ->(message) { message.created_at + 3.days }

    def reminder_owner_7_days
      Notifier.reminder_owner_7_days(self).deliver if need_to_remember?
    end
    handle_asynchronously :reminder_owner_7_days, run_at: ->(message) { message.created_at + 7.days }

    def unactive_product
      if need_to_remember?
        status.product.update_attributes!(active: false)
        Notifier.product_become_inactive(status.product).deliver
      end
    end
    handle_asynchronously :unactive_product, run_at: ->(message) { message.created_at + Product::BECOME_INACTIVE_UNTIL }
end
