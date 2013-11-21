class Asset < ActiveRecord::Base
  belongs_to :referencer, polymorphic: true

  mount_uploader :asset, PhotoUploader

  before_create :stars_if_first_asset, if: :product_referencer?
  before_destroy :random_starred_asset, if: [:product_referencer? , :starred]

  # Set starred at true if it's the first asset for a product
  def stars_if_first_asset
    starred_asset = Asset.where(referencer_id: referencer_id, referencer_type: referencer_type, starred: true)
    if starred_asset.empty?
      self.starred = true
    end
  end

  # Set starred at true for another asset of the product if the destroyed asset is the starred one
  def random_starred_asset
    distance = Asset.where(referencer_id: referencer_id, referencer_type: referencer_type, starred: false).map(&:id)
    random_asset = Asset.find(distance.sample).update_attributes!(starred: true)
  end

  def product_referencer?
    referencer_type == 'Product' ? true : false
  end

  # Set starred at true and unstar the previous starred asset if exists
  def become_starred
    old_asset = Asset.where(referencer_id: referencer_id, referencer_type: referencer_type, starred: true)
    unless old_asset.empty?
      old_asset.first.update_attributes!(starred: false)
    end
    self.update_attributes!(starred: true)
  end
end
