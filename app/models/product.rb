# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  category_id :integer
#  active      :boolean          default(TRUE)
#

class Product < ActiveRecord::Base

  include Slugable

  MAXIMUM_UPLOAD_PHOTO = 2
  LIMIT_TIME_TO_BECOME_INACTIVE = 7.days.to_i
  BECOME_INACTIVE_UNTIL = 5

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'
  belongs_to :category

  has_many :assets, foreign_key: 'product_id', class_name: 'ProductAsset', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :messages

  accepts_nested_attributes_for :category

  validates :name,
    length: {
      minimum: 2,
      maximum: 60,
      message: I18n.t('product.name.length')
    },
    uniqueness: {
      case_sensitive: false,
      message: I18n.t('product.name.uniqueness')
    },
    format: {
      with: /\A[[:digit:][:alpha:]\s'\-_]*\z/u,
      message: I18n.t('product.name.format')
    }

  validates :description,
    length: {
      maximum: 140,
      message: I18n.t('product.description.length')
    },
    allow_blank: true

  validates :category_id, presence: { message: I18n.t('product.category.presence') }

  before_save :to_slug, if: :name_changed?

  def starred_asset
    assets.where(starred: true).first.try(:file)
  end

  def has_maximum_upload?
    assets.count == MAXIMUM_UPLOAD_PHOTO
  end

  def unresponsive_messages_count_for_owner
    count = 0
    pending_messages_for_owner.each do |msg|
      count += (Time.now.to_i - msg.created_at.to_i) < LIMIT_TIME_TO_BECOME_INACTIVE ? 0 : 1
    end
    count
  end

  def pending_messages_for_owner
    last_messages.keep_if{ |msg| msg.sender_id != owner.id }
  end

  def last_messages
    ids = potential_buyers_ids
    last_messages = []

    return last_messages if ids.empty? 

    ids.each do |id|
      last_messages << messages.where('receiver_id = ? OR sender_id = ?', id, id).order('created_at DESC').first
    end
    last_messages
  end

  def last_message_with user
    messages.with(user).order('created_at DESC').try(:first)
  end

  private

    def potential_buyers_ids
      messages.where('receiver_id = ?', owner.id).group(:sender_id).order(:sender_id).pluck(:sender_id)
    end
end
