# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  product_id :integer
#  file       :string(255)
#  starred    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Photo < ActiveRecord::Base

  belongs_to :product

  mount_uploader :file, PhotoUploader

  before_create :stars_if_first
  before_destroy :random_starred, if: :starred
  before_update :unstar, if: [:starred_changed?, :starred]

  private

    def unstar
      old_asset = Photo.where(product: product, starred: true)
      old_asset.first.update_attributes!(starred: false)
    end

    # Set starred at true if it's the first asset for a product
    def stars_if_first
      self.starred = product.photos.count.zero?
      nil
    end

    # Set starred at true for another asset of the product if the destroyed asset is the starred one
    def random_starred
      distance = Photo.select('id').where(product: product, starred: false)
      Photo.find(distance.sample).update_attributes!(starred: true) if distance.any?
    end
end
