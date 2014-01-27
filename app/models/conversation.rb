class Conversation < ActiveRecord::Base
  belongs_to :product
  belongs_to :buyer, class_name: 'User', foreign_key: 'user_id'
  has_many :messages

  scope :about, ->(product) { where(product: product) }
  scope :with, ->(user) { where(buyer: user) }

  def last_message
    messages.order('created_at DESC').limit(1).first
  end
end
