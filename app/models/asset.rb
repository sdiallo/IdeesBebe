class Asset < ActiveRecord::Base
  belongs_to :product

  mount_uploader :photo, PhotoUploader

end
