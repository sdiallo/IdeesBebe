class Product < ActiveRecord::Base
  belongs_to :user
  has_many :assets, :dependent => :destroy

  include Slugable

  validates :name, length: { minimum: 2, maximum: 60 }, uniqueness: { message: "Ce nom de produit est déjà utilisé"}
  validates :description, length: { maximum: 140 }, allow_blank: true
  before_save :to_slug, :if => :name_changed?

  MAXIMUM_UPLOAD_PHOTO = 2

  def upload_photo asset

    if assets.count < MAXIMUM_UPLOAD_PHOTO
      uploader = PhotoUploader.new
      uploader.store!(asset)
      new_asset = assets.create(photo: asset)
      set_main_asset new_asset if assets.count == 1
    end
  end

  def set_main_asset asset
    update_attributes!(star_id: asset.id)
  end

  def get_main_asset
    assets.find(star_id)
  end

  def has_main_asset?
    star_id.nil? ? false : true
  end
end
