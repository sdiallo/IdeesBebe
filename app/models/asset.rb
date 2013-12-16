# == Schema Information
#
# Table name: assets
#
#  id              :integer          not null, primary key
#  file            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  referencer_id   :integer
#  referencer_type :string(255)
#  starred         :boolean          default(FALSE)
#  uploading       :boolean          default(FALSE)
#

class Asset < ActiveRecord::Base
  belongs_to :referencer, polymorphic: true

  mount_uploader :file, PhotoUploader

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
      referencer_type == 'Product'
    end

    # Set starred at true if it's the first asset for a product
    def stars_if_first
      self.starred = true if referencer.assets.where(starred: true).empty?
    end

    # Set starred at true for another asset of the product if the destroyed asset is the starred one
    def random_starred
      distance = Asset.select('id').where(referencer_id: referencer_id, referencer_type: referencer_type, starred: false)
      Asset.find(distance.sample).update_attributes!(starred: true) if distance.any?
    end
end
