class ChangePhotoToAsset < ActiveRecord::Migration
  def change
    rename_column :assets, :photo, :asset
  end
end
