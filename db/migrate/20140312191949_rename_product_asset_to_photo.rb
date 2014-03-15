class RenameProductAssetToPhoto < ActiveRecord::Migration
  def change
    rename_table :product_assets, :photos
  end
end
