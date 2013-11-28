class Product < ActiveRecord::Base
  belongs_to :user
  has_many :assets, as: :referencer, dependent: :destroy
  has_many :comments, dependent: :destroy

  include Slugable

  validates :name, length: { minimum: 2, maximum: 60 }, uniqueness: { case_sensitive: false, message: "Ce nom de produit est déjà utilisé" }
  validates :description, length: { maximum: 140 }, allow_blank: true
  before_save :to_slug, :if => :name_changed?

  MAXIMUM_UPLOAD_PHOTO = 2

  def starred_asset
    return assets.where(referencer_id: self.id, referencer_type: self.class.name, starred: true).first.asset if self.assets?
    return nil
  end

  def assets?
    assets.where(referencer_id: self.id, referencer_type: self.class.name).any? ? true : false
  end

  def has_maximum_upload?
    assets.count == MAXIMUM_UPLOAD_PHOTO ? true : false
  end
end
