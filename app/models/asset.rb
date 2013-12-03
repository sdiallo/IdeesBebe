class Asset < ActiveRecord::Base
  belongs_to :referencer, polymorphic: true

  mount_uploader :asset, PhotoUploader

  before_create :stars_if_first, if: :product_referencer?
  before_destroy :random_starred, if: [:product_referencer? , :starred]

  # Set starred at true and unstar the previous starred asset if exists
  def become_starred
    old_asset = Asset.where(referencer_id: referencer_id, referencer_type: referencer_type, starred: true)
    old_asset.first.update_attributes!(starred: false) unless old_asset.empty?
    self.update_attributes!(starred: true)
  end


  private
    def product_referencer?
      referencer_type == 'Product' ? true : false
    end

    # Set starred at true if it's the first asset for a product
    def stars_if_first
      starred_asset = Asset.where(referencer_id: referencer_id, referencer_type: referencer_type, starred: true)
      self.starred = true if starred_asset.empty?
    end

    # Set starred at true for another asset of the product if the destroyed asset is the starred one
    def random_starred
      distance = Asset.where(referencer_id: referencer_id, referencer_type: referencer_type, starred: false).map(&:id)
      random_asset = Asset.find(distance.sample).update_attributes!(starred: true) if distance.any?
    end
end
