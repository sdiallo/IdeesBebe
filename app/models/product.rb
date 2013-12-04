class Product < ActiveRecord::Base

  include Slugable

  MAXIMUM_UPLOAD_PHOTO = 2

  belongs_to :user
  belongs_to :category
  has_many :assets, as: :referencer, dependent: :destroy
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :category


  validates :name,
    length: { minimum: 2, maximum: 60 },
    uniqueness: { case_sensitive: false, message: "Ce nom de produit est déjà utilisé" },
    format: { with: /\A[[:digit:][:alpha:]\s'\-_]*\z/u }
  validates :description, length: { maximum: 140 }, allow_blank: true
  validates :category_id, presence: { message: "une categorie est oblgiatoire" }

  before_save :to_slug, :if => :name_changed?

  def starred_asset
    self.assets? ? assets.where(referencer_id: self.id, referencer_type: self.class.name, starred: true).first.asset : nil
  end

  def assets?
    assets.where(referencer_id: self.id, referencer_type: self.class.name).any? ? true : false
  end

  def has_maximum_upload?
    assets.count == MAXIMUM_UPLOAD_PHOTO ? true : false
  end
end
