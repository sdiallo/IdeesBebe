class Product < ActiveRecord::Base
  belongs_to :user
  has_many :assets, :dependent => :destroy

  include Slugable

  validates :name, length: { minimum: 2, maximum: 60 }, uniqueness: { message: "Ce nom de produit est déjà utilisé"}
  validates :description, length: { maximum: 140 }, allow_blank: true
  before_save :to_slug, :if => :name_changed?

  MAXIMUM_UPLOAD_PHOTO = 1

  def upload_photo asset

    if assets.count < MAXIMUM_UPLOAD_PHOTO
      uploader = PhotoUploader.new
      uploader.store!(asset)
      assets.create(photo: asset)
    end
  end
end
