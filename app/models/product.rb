class Product < ActiveRecord::Base

  include Slugable

  MAXIMUM_UPLOAD_PHOTO = 2

  belongs_to :user
  belongs_to :category

  has_many :assets, as: :referencer, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :category

  validates :name,
    length: { minimum: 2, maximum: 60, message: I18n.t('product.name.length')  },
    uniqueness: { case_sensitive: false, message: I18n.t('product.name.uniqueness') },
    format: { with: /\A[[:digit:][:alpha:]\s'\-_]*\z/u, message: I18n.t('product.name.format')  }
  validates :description, length: { maximum: 140, message: I18n.t('product.description.length')  }, allow_blank: true
  validates :category_id, presence: { message: I18n.t('product.category.presence') }

  before_save :to_slug, :if => :name_changed?

  def starred_asset
    star = assets.where(referencer_id: self.id, referencer_type: self.class.name, starred: true)
    star.empty? ? nil : star.first.file
  end

  def assets?
    assets.where(referencer_id: self.id, referencer_type: self.class.name).any?
  end

  def has_maximum_upload?
    assets.count == MAXIMUM_UPLOAD_PHOTO
  end
end
