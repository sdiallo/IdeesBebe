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
#  price       :integer          default(0)
#  selled      :boolean          default(FALSE)
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
  has_many :reports, dependent: :destroy

  accepts_nested_attributes_for :category

  scope :active, ->() { where(active: true) }
  scope :avalaible, ->() { where(active: true, selled: false) }

  validates :name,
    length: {
      minimum: 2,
      maximum: 60,
      message: I18n.t('product.name.length')
    },
    format: {
      with: /\A[[:digit:][:alpha:]\s'\-_]*\z/u,
      message: I18n.t('product.name.format')
    }

  validates :price,
    numericality: {
      only_integer: true,
      greater_than: 0,
      message: I18n.t('product.price.numericality')
    },
    length: {
      minimum: 1,
      maximum: 9,
      message: I18n.t('product.price.length')
    }

  validates :category_id, presence: { message: I18n.t('product.category.presence') }


  before_save :to_slug, if: :name_changed?

  def slug
    "#{id}-#{super}"
  end

  def selled_to
    status.where(done: true).first.user
  end

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
end
