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
  BECOME_INACTIVE_UNTIL = 10.days

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'
  belongs_to :category

  has_many :assets, foreign_key: 'product_id', class_name: 'ProductAsset', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :status
  has_many :messages, through: :status

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

  scope :active, ->() { where(active: true) }

  before_save :to_slug, if: :name_changed?

  def starred_asset
    assets.where(starred: true).first.try(:file)
  end

  def has_maximum_upload?
    assets.count == MAXIMUM_UPLOAD_PHOTO
  end

  def pending_messages_for_owner
    last_messages.keep_if{ |msg| msg.sender_id != owner.id }
  end

  def last_messages
    lasts = []

    return lasts if status.empty?

    status.each do |status|
      lasts << status.messages.order('created_at DESC').first
    end
    lasts
  end

  def last_message_with user
    messages.with(user).order('created_at DESC').try(:first)
  end
end
